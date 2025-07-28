import 'package:expense/models/expense_model.dart';

enum CategoryFilter { all, food, transport, fun, other }

abstract class ExpenseState {}

class InitialExpenseState extends ExpenseState {}

class LoadingExpenseState extends ExpenseState {}

class ExpenseErrorState extends ExpenseState {
  final String errorMessage;

  ExpenseErrorState(this.errorMessage);
}

class LoadedExpenseState extends ExpenseState {
  final List<ExpenseModel> expenses;
  final CategoryFilter filter;

  LoadedExpenseState({
    this.expenses = const [],
    this.filter = CategoryFilter.all,
  });

  List<ExpenseModel> get filteredExpenses {
    List<ExpenseModel> filtered = [];
    if (filter == CategoryFilter.all) {
      return expenses;
    }

    for (var itemExpense in expenses) {
      switch (filter) {
        case CategoryFilter.food:
          if (itemExpense.category == ExpenseCategory.food) {
            filtered.add(itemExpense);
          }
          break;
        case CategoryFilter.transport:
          if (itemExpense.category == ExpenseCategory.transport) {
            filtered.add(itemExpense);
          }
          break;
        case CategoryFilter.fun:
          if (itemExpense.category == ExpenseCategory.fun) {
            filtered.add(itemExpense);
          }
          break;
        case CategoryFilter.other:
          if (itemExpense.category == ExpenseCategory.other) {
            filtered.add(itemExpense);
          }
          break;
        case CategoryFilter.all:
          break;
      }
    }
    return filtered;
  }

  double get totalAmount {
    double sum = 0;
    for (var itemExpense in expenses) {
      sum += itemExpense.amount;
    }
    return sum;
  }

  LoadedExpenseState copyWith({
    List<ExpenseModel>? expenses,
    CategoryFilter? filter,
  }) {
    return LoadedExpenseState(
      expenses: expenses ?? this.expenses,
      filter: filter ?? this.filter,
    );
  }
}
