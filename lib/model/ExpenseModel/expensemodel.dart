class Expense {
  int? id;
  String category;
  double amount;
  String formattedDate;
  String formattedTime;
  String expenseType;

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.formattedDate,
    required this.formattedTime,
    required this.expenseType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'formattedDate': formattedDate,
      'formattedTime': formattedTime,
      'expenseType': expenseType,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'] ?? 'Unknown',
      amount: map['amount'] ?? 0.0,
      formattedDate: map['formattedDate'] ?? '',
      formattedTime: map['formattedTime'] ?? '',
      expenseType: map['expenseType'] ?? 'General',
    );
  }
}
