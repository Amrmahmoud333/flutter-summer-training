import 'package:expense/cubit/expense_cubit.dart';
import 'package:expense/cubit/theme_cubit.dart';
import 'package:expense/screens/expense_screen.dart';
import 'package:expense/service%20/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExpenseCubit(LocalStorageService()),
          ),
          BlocProvider(create: (context) => ThemeCubit()),
        ],

        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Expense App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              darkTheme: ThemeData.dark(),
              themeMode: state,
              home: const ExpenseScreen(),
            );
          },
        ),
      ),
    );
  }
}
