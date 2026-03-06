import 'package:flutter/material.dart';
import 'package:tugas_tpm1/pages/homepage.dart';
import 'package:tugas_tpm1/pages/pyramid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: Homepage(),
      home: PyramidScreen(),
    );
  }
}