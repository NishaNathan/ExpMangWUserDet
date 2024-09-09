import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trainbookingapp/common/commonwidgets/dialoghelper.dart';
import 'package:trainbookingapp/common/network/dbhelper.dart';
import 'package:trainbookingapp/model/ExpenseModel/expensemodel.dart';

class ExpenseController extends GetxController {
  var isExpense = true.obs;
  var selectedCategory = ''.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = DateTime.now().obs;
  final TextEditingController amountController = TextEditingController();

  var selectedexpense = 'Expense';

  var expenses = <Expense>[].obs;

  var leftIconColor = Colors.black.obs;
  var rightIconColor = Colors.black.obs;

  var isSavingLoad = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateNavigationIconColors();
  }

  void toggleExpenseType(bool isExpenseSelected) {
    isExpense.value = isExpenseSelected;
    selectedexpense = "";
    if (isExpenseSelected == true) {
      selectedexpense = 'Expense';
    } else {
      selectedexpense = 'Income';
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void setSelectedDate(DateTime date) {
    if (selectedDate.value != date) {
      selectedDate.value = date;
    }
    updateNavigationIconColors();
  }

  void setSelectedTime(DateTime dateTime) {
    if (selectedTime.value != dateTime) {
      selectedTime.value = dateTime;
    }
  }

  bool validateAndSaveExpense() {
    if (amountController.text.isEmpty) {
      DialogHelper.showErrorDialog(title: "Error", description: "Enter Amount");
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      DialogHelper.showErrorDialog(
          title: "Error", description: "Please select a category");
      return false;
    }
    return true;
  }

  void updateNavigationIconColors() {
    DateTime now = DateTime.now();
    DateTime oneYearAgo = now.subtract(const Duration(days: 365));
    leftIconColor.value =
        selectedDate.value.isAfter(oneYearAgo) ? Colors.black : Colors.grey;
    rightIconColor.value =
        selectedDate.value.isBefore(now) ? Colors.black : Colors.grey;
  }

  Text formatAmountText(double amount) {
    bool isExpense = amount < 0;
    return Text(
      '${isExpense ? '- ' : ''}₹${amount.abs().toStringAsFixed(2)}',
      style: TextStyle(
        color: isExpense ? Colors.red : Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MMM/yyyy').format(date);
  }

  Future<void> saveExpense(Expense expense) async {
    if (!validateAndSaveExpense()) return;

    isSavingLoad.value = true;
    try {
      final double amount = double.parse(amountController.text);

      final expense = Expense(
          category: selectedCategory.value,
          amount: isExpense.value ? -amount : amount,
          formattedDate: _formatDate(selectedDate.value),
          formattedTime: _formatTime(selectedTime.value),
          expenseType: selectedexpense);

      await DatabaseHelper.instance.addExpense(expense);

      amountController.clear();
      setSelectedCategory('');
      setSelectedDate(DateTime.now());
      setSelectedTime(DateTime.now());
      toggleExpenseType(true);

      expenses.add(expense);
      update();
      DialogHelper.showSuccessDialog(
        title: "Success",
        description: "Expense saved successfully!",
        onConfirm: () {
          Get.back();
        },
      );
    } catch (e) {
      DialogHelper.showErrorDialog(
        title: "Error",
        description: "Failed to save expense. Please try again.",
      );
    } finally {
      isSavingLoad.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
