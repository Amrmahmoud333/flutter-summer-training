import 'package:expense/cubit/posts_cubit.dart';
import 'package:expense/screens/posts_screen.dart';
import 'package:expense/service%20/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.inti();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Posts App',
          theme: ThemeData(),
          home: PostsScreen(),
        ),
      ),
    );
  }
}
