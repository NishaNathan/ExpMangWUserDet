import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trainbookingapp/model/ExpenseModel/expensemodel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        amount REAL,
        formattedDate TEXT,  -- Column for storing formatted date
        formattedTime TEXT,  -- Column for storing formatted time
        expenseType TEXT     -- New column for expense type
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE expenses ADD COLUMN formattedDate TEXT');
      await db.execute('ALTER TABLE expenses ADD COLUMN formattedTime TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE expenses ADD COLUMN expenseType TEXT');
    }
  }

  Future<int> addExpense(Expense expense) async {
    Database db = await instance.database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    Database db = await instance.database;
    var expenses = await db.query('expenses', orderBy: 'formattedDate DESC');
    return expenses.map((e) => Expense.fromMap(e)).toList();
  }

  Future<int> updateExpense(Expense expense) async {
    Database db = await instance.database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    Database db = await instance.database;

    print('Deleting expense with ID: $id');

    int result = await db.delete('expenses', where: 'id = ?', whereArgs: [id]);

    print('Number of rows deleted: $result');

    return result;
  }

  Future<Map<String, double>> getTotalExpensesByCategory() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT category, formattedDate, SUM(amount) as total FROM expenses GROUP BY category');

    print('Query Result: $result');

    Map<String, double> summary = {};
    for (var row in result) {
      String category = row['category'] as String? ?? 'Unknown';
      double total = (row['total'] as double?) ?? 0.0;

      summary[category] = total;
    }

    print('Processed Summary: $summary');

    return summary;
  }

  Future<void> clearAllExpenses() async {
    Database db = await instance.database;
    await db.delete('expenses');
  }

  Future<void> printTableInfo() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("PRAGMA table_info(expenses)");
    print(result);
  }
}
