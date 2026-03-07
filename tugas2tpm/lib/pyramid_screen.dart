import 'package:flutter/material.dart';
import 'dart:math';

class PyramidScreen extends StatefulWidget {
  const PyramidScreen({super.key});

  @override
  State<PyramidScreen> createState() => _PyramidScreenState();
}

class _PyramidScreenState extends State<PyramidScreen> {
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _slantController = TextEditingController();

  double? _baseArea, _lateralArea, _totalArea, _volume;

  void _calculate() {
    final double? base = double.tryParse(_baseController.text);
    final double? height = double.tryParse(_heightController.text);
    double? slant = double.tryParse(_slantController.text);

    if (base != null && height != null) {
      setState(() {
        _baseArea = base * base;
        slant ??= sqrt((height * height) + ((base / 2) * (base / 2)));
        _lateralArea = 2 * base * slant!;
        _totalArea = _baseArea! + _lateralArea!;
        _volume = (1 / 3) * _baseArea! * height;
      });
    }
  }

  void _reset() {
    setState(() {
      _baseController.clear();
      _heightController.clear();
      _slantController.clear();
      _baseArea = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pyramid Formula')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Parameter Piramid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInputRow('Sisi Alas (a)', _baseController),
            const SizedBox(height: 12),
            _buildInputRow('Tinggi Piramid (t)', _heightController),
            const SizedBox(height: 12),
            _buildInputRow('Tinggi Miring (s)', _slantController, hint: 'Opsional'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3267E3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _calculate,
                    child: const Text('Hitung', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _reset,
                    child: const Text('Reset', style: TextStyle(color: Colors.black54)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_baseArea != null) ...[
              const Text('Hasil Perhitungan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildResultCard('Luas Alas', _baseArea!, Colors.blue.shade50, Colors.blue),
              _buildResultCard('Luas Selimut', _lateralArea!, Colors.orange.shade50, Colors.orange),
              _buildResultCard('Luas Permukaan Total', _totalArea!, Colors.green.shade50, Colors.green),
              _buildResultCard('Volume', _volume!, Colors.purple.shade50, Colors.purple),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller, {String hint = ''}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(String label, double value, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value.toStringAsFixed(value % 1 == 0 ? 0 : 2),
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}