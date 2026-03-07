import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'group_data_screen.dart';
import 'calculator_screen.dart';
import 'number_checker_screen.dart';
import 'sum_calculator_screen.dart';
import 'stopwatch_screen.dart';
import 'pyramid_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Pemrograman Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3267E3), // Warna biru utama
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/', // Mulai dari halaman Login
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/group-data': (context) => const GroupDataScreen(),
        '/calculator': (context) => const CalculatorScreen(),
        '/number-checker': (context) => const NumberCheckerScreen(),
        '/sum-calculator': (context) => const CharacterCounterScreen(),
        '/stopwatch': (context) => const StopwatchScreen(),
        '/pyramid': (context) => const PyramidScreen(),
      },
    );
  }
}