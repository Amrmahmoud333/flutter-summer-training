enum ExpenseCategory { food, transport, fun, other, all }

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
  });
}
