import 'package:flutter/material.dart';
import 'dart:math';

class NumberCheckerScreen extends StatefulWidget {
  const NumberCheckerScreen({super.key});

  @override
  State<NumberCheckerScreen> createState() => _NumberCheckerScreenState();
}

class _NumberCheckerScreenState extends State<NumberCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  int? _number;
  bool? _isOdd;
  bool? _isPrime;

  bool _checkPrime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    for (int i = 3; i <= sqrt(n); i += 2) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void _checkNumber() {
    final int? n = int.tryParse(_controller.text);
    if (n != null) {
      setState(() {
        _number = n;
        _isOdd = n % 2 != 0;
        _isPrime = _checkPrime(n);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Number')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Masukkan Bilangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 17',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3267E3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _checkNumber,
                child: const Text('Cek Bilangan', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
            if (_number != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF3267E3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hasil Pengecekan Bilangan', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text('$_number', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildBadge(_isOdd! ? 'GANJIL' : 'GENAP', Colors.orange),
                        const SizedBox(width: 12),
                        _buildBadge(_isPrime! ? 'PRIMA' : 'BUKAN PRIMA', _isPrime! ? Colors.green : Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}