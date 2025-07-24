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
    final updatedEpns = state.expenses.toList();
    updatedEpns.add(newExpense);
    emit(state.copyWith(expenses: updatedEpns));
  }

  void deleteExpense(String id) {
    for (int i = 0; i < state.expenses.length; i++) {
      if (state.expenses[i].id == id) {
        state.expenses.removeAt(i);
        break;
      }
    }
    emit(state.copyWith(expenses: state.expenses));
  }

  void changeFilter(CategoryFilter category) {
    emit(state.copyWith(filter: category));
  }
}
