import 'package:flutter/material.dart';

// Class bantuan untuk menyimpan riwayat perhitungan
class CalcStep {
  final String operation;
  final double value;
  CalcStep({required this.operation, required this.value});
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<CalcStep> _steps = [];

  // Getter Logika Inti: Menghitung total dari atas ke bawah
  double get _currentTotal {
    if (_steps.isEmpty) return 0;
    
    double total = 0;
    for (int i = 0; i < _steps.length; i++) {
      var step = _steps[i];
      
      if (i == 0) {
        total = (step.operation == '-') ? -step.value : step.value;
      } else {
        if (step.operation == '+') total += step.value;
        else if (step.operation == '-') total -= step.value;
        else if (step.operation == '×') total *= step.value;
        else if (step.operation == '÷') {
          if (step.value != 0) {
            total /= step.value;
          } else {
            return double.nan;
          }
        }
      }
    }
    return total;
  }

  // Fungsi untuk memunculkan pesan error via SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ' $message', 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating, // Mengambang
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Fungsi Formatting Output
  String _formatNumber(double n) {
    if (n.isNaN) return 'Error';
    if (n.isInfinite) return '∞';
    return n % 1 == 0 
        ? n.toInt().toString() 
        : n.toStringAsFixed(4).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  // Fungsi Eksekusi & Validasi (Error Handling)
  void _addStep(String op) {
    final String inputText = _controller.text.trim();

    // 1. Cek Input Kosong
    if (inputText.isEmpty) {
      _showError('Input angka tidak boleh kosong!');
      return;
    }

    // 2. Cek Karakter Terlalu Panjang
    if (inputText.length > 15) {
      _showError('Angka terlalu panjang (Maksimal 15 digit)!');
      return;
    }

    // 3. Cek Format Angka
    final double? val = double.tryParse(inputText);
    if (val == null) {
      _showError('Format angka tidak valid!');
      return;
    }

    // 4. Cek Pembagian dengan Nol
    if (op == '÷' && val == 0) {
      _showError('Tidak dapat membagi bilangan dengan nol!');
      return;
    }

    // 5. SIMULASI KALKULASI UNTUK MENCEGAH OVERFLOW MEMORI
    double projectedTotal = _currentTotal;
    if (_steps.isEmpty) {
      projectedTotal = (op == '-') ? -val : val;
    } else {
      if (op == '+') projectedTotal += val;
      else if (op == '-') projectedTotal -= val;
      else if (op == '×') projectedTotal *= val;
      else if (op == '÷') projectedTotal /= val;
    }

    // Cek batas maksimum Int 64-bit (9.22 x 10^18)
    // Jika lewat dari ini, .toInt() akan stuck di 9223372036854775807
    if (projectedTotal.isInfinite || projectedTotal.abs() >= 9223372036854775000) {
      _showError('Hasil kalkulasi ditolak! Melampaui batas maksimum sistem.');
      return;
    }

    // Lolos semua pengecekan -> Masukkan ke dalam riwayat kalkulator
    setState(() {
      _steps.add(CalcStep(operation: op, value: val));
      _controller.clear();
    });
  }

  void _removeStep(int index) {
    setState(() => _steps.removeAt(index));
  }

  void _clearAll() {
    setState(() {
      _steps.clear();
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Kalkulator Berantai')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Panel Total Hasil
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
                  const Text('Total Perhitungan', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  // FittedBox membantu agar teks mengecil otomatis jika angka mulai panjang
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _steps.isEmpty ? '0' : _formatNumber(_currentTotal),
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Input TextField
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              maxLength: 15, 
              decoration: InputDecoration(
                hintText: 'Masukkan angka...',
                filled: true,
                fillColor: Colors.white,
                counterText: '', 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Operasi Dasar
            Row(
              children: [
                Expanded(child: _buildOpBtn('+ Tambah', Colors.green, () => _addStep('+'))),
                const SizedBox(width: 8),
                Expanded(child: _buildOpBtn('- Kurang', Colors.red, () => _addStep('-'))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildOpBtn('× Kali', Colors.purple, () => _addStep('×'))),
                const SizedBox(width: 8),
                Expanded(child: _buildOpBtn('÷ Bagi', Colors.orange, () => _addStep('÷'))),
              ],
            ),
            const SizedBox(height: 24),

            // Header Daftar Riwayat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Riwayat Kalkulasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (_steps.isNotEmpty)
                  TextButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.delete_sweep, color: Colors.red, size: 18),
                    label: const Text('Hapus Semua', style: TextStyle(color: Colors.red, fontSize: 13)),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Daftar Riwayat
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: _steps.isEmpty
                    ? const Center(child: Text('Ketik angka dan pilih operator di atas', style: TextStyle(color: Colors.grey)))
                    : ListView.separated(
                        itemCount: _steps.length,
                        separatorBuilder: (context, index) => Divider(color: Colors.grey.shade100, height: 1),
                        itemBuilder: (context, index) {
                          final step = _steps[index];
                          return ListTile(
                            leading: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                              alignment: Alignment.center,
                              child: Text(step.operation, style: const TextStyle(color: Color(0xFF3267E3), fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            title: Text(_formatNumber(step.value), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                              onPressed: () => _removeStep(index),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpBtn(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}