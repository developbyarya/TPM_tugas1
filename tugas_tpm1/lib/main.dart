import 'package:flutter/material.dart';
import 'package:tugas_tpm1/auth/auth_gate.dart';
import 'package:tugas_tpm1/pages/pyramid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://sxnnrtuymyhpvorqbine.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN4bm5ydHV5bXlocHZvcnFiaW5lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI3MjA5NDAsImV4cCI6MjA4ODI5Njk0MH0.WGMZhmyxyvdBHB-Zrn5Hv93zf5dC1MMKZQqWgV5y2yQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Homepage(),
      home: AuthGate(),
    );
  }
}