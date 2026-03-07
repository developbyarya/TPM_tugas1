import 'package:flutter/material.dart';
import 'package:tugas_tpm1/pages/cek_bilangan.dart';
import 'package:tugas_tpm1/pages/pyramid.dart';

import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const CekBilanganScreen(),
      routes: {
        '/cek-bilangan': (context) => const CekBilanganScreen(),
        '/pyramid': (context) => PyramidScreen(),
      },
    );
  }
}