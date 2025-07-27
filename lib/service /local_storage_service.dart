import 'dart:convert';

import 'package:expense/models/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? sharedPref;
  static init() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  Future<void> saveExpenses(List<ExpenseModel> expenses) async {
    // 1. Convert each ExpenseModel to a Map
    final List<Map<String, dynamic>> expensesJson =
        expenses
            .map(
              (expense) => {
                'id': expense.id,
                'title': expense.title,
                'amount': expense.amount,
                'category': expense.category.name, // Convert enum to string
              },
            )
            .toList();
    // 2. Encode the list of maps into a single JSON string
    final String encodedData = json.encode(expensesJson);

    // 3. Save the string using the setString method
    await sharedPref!.setString('expenses', encodedData);
  }

  Future<List<ExpenseModel>> loadExpenses() async {
    final String? expenseString = sharedPref!.getString('expenses');

    if (expenseString != null) {
      final List<dynamic> expensesJson = json.decode(expenseString);
      return expensesJson
          .map(
            (json) => ExpenseModel(
              id: json['id'],
              title: json['title'],
              amount: json['amount'],
              category: ExpenseCategory.values.firstWhere(
                (e) => e.name == json['category'],
                orElse: () => ExpenseCategory.other,
              ),
            ),
          )
          .toList();
    }
    return [];
  }

  static Future<bool> setData(String key, dynamic value) async {
    if (value is String) {
      return await sharedPref!.setString(key, value);
    } else if (value is int) {
      return await sharedPref!.setInt(key, value);
    } else if (value is double) {
      return await sharedPref!.setDouble(key, value);
    } else if (value is bool) {
      return await sharedPref!.setBool(key, value);
    } else if (value is List<String>) {
      return await sharedPref!.setStringList(key, value);
    }
    return false;
  }

  static dynamic getData(dynamic key) {
    return sharedPref!.get(key);
  }

  static Future<bool> removeData(String key) async {
    return await sharedPref!.remove(key);
  }

  static Future<bool> clear() async {
    return await sharedPref!.clear();
  }
}
