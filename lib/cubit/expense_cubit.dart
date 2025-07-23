import 'package:expense/cubit/expense_state.dart';
import 'package:expense/models/expense_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseState());

  void addExpense(String title, double amount, ExpenseCategory category) {
    final newExpense = ExpenseModel(
      amount: amount,
      title: title,
      category: category,
      id: DateTime.now().toIso8601String(),
    );
    final upadatedEps = [...state.expenses, newExpense];
    emit(state.copyWith(expenses: upadatedEps));
  }

  void deleteExpense(String id) {
    final upadatedEps =
        state.expenses.where((expense) => expense.id != id).toList();
    emit(state.copyWith(expenses: upadatedEps));
  }

  void changeFilter(CategoryFilter category) {
    emit(state.copyWith(filter: category));
  }
}
