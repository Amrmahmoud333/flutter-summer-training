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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    // Runs logic to prepare data, then returns a finished object.
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      // Safely converts data before creating the object
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      category: ExpenseCategory.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == json['category'].toString().toLowerCase(),
        orElse: () => ExpenseCategory.other,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.name,
    };
  }
}
