import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';
import 'package:trainbookingapp/common/network/dbhelper.dart';
import 'package:trainbookingapp/controller/ExpenseController/expensecontroller.dart';
import 'package:trainbookingapp/model/ExpenseModel/expensemodel.dart';
import 'package:trainbookingapp/views/ViewRegister/ExpenseManager/addexpense.dart';

class ExpenseManger extends StatefulWidget {
  const ExpenseManger({super.key});

  @override
  State<ExpenseManger> createState() => _ExpenseMangerState();
}

class _ExpenseMangerState extends State<ExpenseManger> {
  final ExpenseController expenseController = Get.put(ExpenseController());
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpensesForSelectedDate(expenseController.selectedDate.value);
  }

  void _loadExpenses() async {
    List<Expense> expenseList = await dbHelper.getExpenses();
    setState(() {
      expenses = expenseList;
    });
  }

  void _addExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(onAdd: () {
          _loadExpensesForSelectedDate(expenseController.selectedDate.value);
        }),
      ),
    );
  }

  void _showSummary() async {
    Map<String, double> summary = await dbHelper.getTotalExpensesByCategory();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Expense Summary",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blueViolet,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: summary.entries
              .map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text('₹${e.value.toStringAsFixed(2)}')))
              .toList(),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(
                  color: blueViolet,
                ),
              ))
        ],
      ),
    );
  }

  void _showEditDialog(Expense expense) {
    final TextEditingController amountController =
        TextEditingController(text: expense.amount.abs().toString());
    String selectedCategory = expense.category;
    bool isEditing = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(isEditing ? Icons.save : Icons.edit),
                    onPressed: () async {
                      if (isEditing) {
                        double updatedAmount =
                            double.parse(amountController.text) *
                                (expense.amount < 0 ? -1 : 1);
                        Expense updatedExpense = Expense(
                            id: expense.id,
                            category: selectedCategory,
                            amount: updatedAmount,
                            formattedDate: expense.formattedDate,
                            formattedTime: expense.formattedTime,
                            expenseType: expense.expenseType);
                        await dbHelper.updateExpense(updatedExpense);
                        _loadExpensesForSelectedDate(
                            expenseController.selectedDate.value);
                        Navigator.pop(context);
                      }
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await dbHelper.deleteExpense(expense.id!);
                      _loadExpensesForSelectedDate(
                          expenseController.selectedDate.value);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(expense.category,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                enabled: isEditing,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: isEditing ? selectedCategory : null,
                onChanged: isEditing
                    ? (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      }
                    : null,
                items: [
                  'Food',
                  'Travel',
                  'Social',
                  'Shopping',
                  'Bills',
                  'Entertainment',
                  'Health'
                ].map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(_getCategoryIcon(category)),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Travel':
        return Icons.directions_car;
      case 'Social':
        return Icons.group;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Bills':
        return Icons.receipt;
      case 'Entertainment':
        return Icons.movie;
      case 'Health':
        return Icons.health_and_safety;
      default:
        return Icons.category;
    }
  }

  Future<void> _loadExpensesForSelectedDate(DateTime selectedDate) async {
    
    expenseController.expenses.clear();

    
    List<Expense> allExpenses = await dbHelper.getExpenses();

    
    List<Expense> filteredExpenses = allExpenses.where((expense) {
      DateTime expenseDate = _parseFormattedDate(expense.formattedDate);
      return expenseDate.year == selectedDate.year &&
          expenseDate.month == selectedDate.month &&
          expenseDate.day == selectedDate.day;
    }).toList();

    
    expenseController.expenses.addAll(filteredExpenses);
  }

  DateTime _parseFormattedDate(String formattedDate) {
    try {
      return DateFormat('dd/MMM/yyyy').parse(formattedDate);
    } catch (e) {
      print('Error parsing date: $formattedDate, Error: $e');
      return DateTime.now();
    }
  }

  void _goToPreviousDate() {
    DateTime oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    if (expenseController.selectedDate.value.isAfter(oneYearAgo)) {
      expenseController.selectedDate.value = expenseController
          .selectedDate.value
          .subtract(const Duration(days: 1));

      _loadExpensesForSelectedDate(expenseController.selectedDate.value);
      expenseController.updateNavigationIconColors();
    }
  }

  void _goToNextDate() {
    DateTime today = DateTime.now();
    if (expenseController.selectedDate.value.isBefore(today)) {
      expenseController.selectedDate.value =
          expenseController.selectedDate.value.add(const Duration(days: 1));

      _loadExpensesForSelectedDate(expenseController.selectedDate.value);
      expenseController.updateNavigationIconColors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _goToPreviousDate,
                    color: expenseController.leftIconColor.value,
                  )),
              Obx(() => Text(
                    DateFormat('dd/MMM/yyyy')
                        .format(expenseController.selectedDate.value),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              Obx(() => IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _goToNextDate,
                    color: expenseController.rightIconColor.value,
                  )),
            ],
          ),
          Divider(
            color: blueViolet,
            thickness: 2,
          ),
          
          Expanded(
            child: Obx(() {
              if (expenseController.expenses.isEmpty) {
                return const Center(
                  child: Text(
                    'No expenses for this date.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: expenseController.expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenseController.expenses[index];
                  
                  return ListTile(
                    leading: const Icon(
                      Icons.category,
                      color: Colors.blueGrey,
                    ),
                    title: Text(expense.category),
                    trailing: Text(
                      expense.expenseType == "Expense"
                          ? '- ₹${expense.amount.abs().toStringAsFixed(2)}'
                          : '+ ₹${expense.amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: expense.expenseType == "Expense"
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      _showEditDialog(expense);
                    },
                    onLongPress: () async {
                      await dbHelper.deleteExpense(expense.id!);
                      _loadExpensesForSelectedDate(
                          expenseController.selectedDate.value);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addExpense,
            backgroundColor: blueViolet,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            backgroundColor: blueViolet,
            onPressed: () {
              _showSummary();
            },
            child: Icon(
              Icons.pie_chart,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
