import 'package:expense/service%20/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    loadTheme();
  }

  void loadTheme() {
    bool isDrak = LocalStorageService.getData('isDark');
    emit(isDrak ? ThemeMode.dark : ThemeMode.light);
  }

  void switchTheme() {
    final newTheme =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    bool isDark = newTheme == ThemeMode.dark;
    LocalStorageService.setData('isDark', isDark);
    emit(newTheme);
  }
}
