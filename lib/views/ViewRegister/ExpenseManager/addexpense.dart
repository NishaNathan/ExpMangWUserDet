import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';
import 'package:trainbookingapp/common/commonwidgets/commontextformfield.dart';
import 'package:trainbookingapp/common/network/dbhelper.dart';
import 'package:trainbookingapp/controller/ExpenseController/expensecontroller.dart';
import 'package:trainbookingapp/model/ExpenseModel/expensemodel.dart';

class AddExpenseScreen extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());
  final Function onAdd;

  AddExpenseScreen({super.key, required this.onAdd});

  final List<Map<String, dynamic>> categories = [
    {'title': 'Food', 'icon': Icons.fastfood, 'color': Colors.orange},
    {'title': 'Travel', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'title': 'Social', 'icon': Icons.group, 'color': Colors.green},
    {'title': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'title': 'Bills', 'icon': Icons.receipt, 'color': Colors.red},
    {'title': 'Entertainment', 'icon': Icons.movie, 'color': Colors.teal},
    {
      'title': 'Health',
      'icon': Icons.health_and_safety,
      'color': Colors.deepOrange
    },
  ];

  String _formatDate(DateTime date) {
    return DateFormat('dd/MMM/yyyy').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  void _saveExpense(BuildContext context) async {
    if (expenseController.validateAndSaveExpense()) {
      final double amount =
          double.parse(expenseController.amountController.text);

      final expense = Expense(
          category: expenseController.selectedCategory.value,
          amount: expenseController.isExpense.value ? -amount : amount,
          formattedDate: _formatDate(expenseController.selectedDate.value),
          formattedTime: _formatTime(expenseController.selectedTime.value),
          expenseType: expenseController.selectedexpense);
      await DatabaseHelper.instance.addExpense(expense);
      expenseController.amountController.clear();
      expenseController.setSelectedCategory('');
      expenseController.setSelectedDate(DateTime.now());
      expenseController.setSelectedTime(DateTime.now());
      expenseController.toggleExpenseType(true);

      onAdd();
      Navigator.pop(context);
    }
  }

  void _showCategorySelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  expenseController
                      .setSelectedCategory(categories[index]['title']);
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      categories[index]['icon'],
                      size: 40,
                      color: categories[index]['color'],
                    ),
                    Text(categories[index]['title']),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: expenseController.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null &&
        selectedDate != expenseController.selectedDate.value) {
      expenseController.setSelectedDate(selectedDate);
    }
  }

  void _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(expenseController.selectedTime.value),
    );

    if (selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        expenseController.selectedDate.value.year,
        expenseController.selectedDate.value.month,
        expenseController.selectedDate.value.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      expenseController.setSelectedTime(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueViolet,
        title: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.white),
        ),
        
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    selectedColor: blueViolet,
                    label: Text(
                      'Expense',
                      style: TextStyle(
                        color: expenseController.isExpense.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: expenseController.isExpense.value,
                    onSelected: (value) =>
                        expenseController.toggleExpenseType(true),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    selectedColor: blueViolet,
                    label: Text(
                      'Income',
                      style: TextStyle(
                        color: expenseController.isExpense.value
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    selected: !expenseController.isExpense.value,
                    onSelected: (value) =>
                        expenseController.toggleExpenseType(false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => GestureDetector(
                  onTap: () => _showCategorySelectionSheet(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.category,
                          color: Color.fromRGBO(109, 100, 255, 1),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          expenseController.selectedCategory.value.isEmpty
                              ? 'Select Category'
                              : expenseController.selectedCategory.value,
                          style: TextStyle(color: blueViolet),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            CommonTextField(
                controller: expenseController.amountController,
                hintText: 'Amount',
                isPassword: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Amount';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: blueViolet,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Select Date',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: blueViolet,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timelapse_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Select Time',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Date: ${_formatDate(expenseController.selectedDate.value)}'),
                  const SizedBox(height: 10),
                  Text(
                      'Time: ${_formatTime(expenseController.selectedTime.value)}'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Obx(() {
                  return expenseController.isSavingLoad.value
                      ? CircularProgressIndicator(
                          backgroundColor: whiteColor,
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (expenseController.validateAndSaveExpense()) {
                              Expense newExpense = Expense(
                                  category:
                                      expenseController.selectedCategory.value,
                                  amount: double.parse(
                                      expenseController.amountController.text),
                                  formattedDate: DateFormat('dd/MMM/yyyy')
                                      .format(
                                          expenseController.selectedDate.value),
                                  formattedTime: DateFormat('HH:mm').format(
                                      expenseController.selectedTime.value),
                                  expenseType:
                                      expenseController.selectedexpense);

                              expenseController.saveExpense(newExpense);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueViolet,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            elevation: 2,
                          ),
                          child: Text(
                            'Save Expense',
                            style: TextStyle(color: whiteColor),
                          ),
                        );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
