import 'package:expense/cubit/expense_state.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/service%20/dio_helper.dart';
import 'package:expense/service%20/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit(this._localStorageService) : super(InitialExpenseState()) {
    loadExpenses();
  }
  final LocalStorageService _localStorageService;

  Future<void> loadExpenses() async {
    emit(LoadingExpenseState());
    try {
      final response = await DioHelper.getData(endpoint: 'expense');
      final expnse =
          (response.data as List)
              .map((item) => ExpenseModel.fromJson(item))
              .toList();
      emit(LoadedExpenseState(expenses: expnse));
    } catch (e) {
      emit(ExpenseErrorState(e.toString()));
    }
  }

  void saveExpenses(List<ExpenseModel> expenses) {
    _localStorageService.saveExpenses(expenses);
  }

  Future<void> addExpense(
    String title,
    double amount,
    ExpenseCategory category,
  ) async {
    final state = this.state as LoadedExpenseState;
    // add the new item to the ui
    final newExpense = ExpenseModel(
      amount: amount,
      title: title,
      category: category,
      id: DateTime.now().toIso8601String(),
    );
    final updatedEpns = state.expenses.toList();
    updatedEpns.add(newExpense);
    emit(state.copyWith(expenses: updatedEpns));

    // to add the new item to the Server
    try {
      // send a new item to the api
      await DioHelper.postData(endpoint: 'expense', data: newExpense.toJson());
      // get all the list
      loadExpenses();
    } catch (e) {
      // show a notification to the user
      emit(state);
    }
  }

  Future<void> deleteExpense(String id) async {
    final state = this.state as LoadedExpenseState;
    for (int i = 0; i < state.expenses.length; i++) {
      if (state.expenses[i].id == id) {
        state.expenses.removeAt(i);
        break;
      }
    }
    _localStorageService.saveExpenses(state.expenses);
    emit(state.copyWith(expenses: state.expenses));

    try {
      await DioHelper.deleteData(endpoint: 'expense/$id');
    } catch (e) {
      // show a notification to the user
      emit(state);
    }
  }

  void changeFilter(CategoryFilter category) {
    final state = this.state as LoadedExpenseState;
    emit(state.copyWith(filter: category));
  }
}
