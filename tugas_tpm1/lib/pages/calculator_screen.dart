import 'package:flutter/material.dart';

// Class bantuan untuk menyimpan riwayat setiap langkah perhitungan
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
  
  // State: Menyimpan seluruh riwayat angka dan operator yang dimasukkan
  final List<CalcStep> _steps = [];
  String _errorMessage = '';

  // Getter (Logika Inti): Menghitung total dari atas ke bawah secara real-time
  double get _currentTotal {
    if (_steps.isEmpty) return 0;
    
    double total = 0;
    for (int i = 0; i < _steps.length; i++) {
      var step = _steps[i];
      
      // Khusus angka pertama, kita jadikan sebagai nilai dasar (base value)
      if (i == 0) {
        if (step.operation == '-') {
          total = -step.value;
        } else {
          total = step.value; 
        }
      } else {
        // Angka kedua dan seterusnya diproses sesuai operator
        if (step.operation == '+') total += step.value;
        else if (step.operation == '-') total -= step.value;
        else if (step.operation == '×') total *= step.value;
        else if (step.operation == '÷') {
          if (step.value != 0) {
            total /= step.value;
          } else {
            return double.nan; // Mencegah error dibagi 0
          }
        }
      }
    }
    return total;
  }

  // Fungsi merapikan tampilan angka desimal
  String _formatNumber(double n) {
    if (n.isNaN) return 'Error: Dibagi 0';
    if (n.isInfinite) return '∞';
    return n % 1 == 0 
        ? n.toInt().toString() 
        : n.toStringAsFixed(4).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  // Fungsi saat tombol operasi ditekan
  void _addStep(String op) {
    final double? val = double.tryParse(_controller.text);
    if (val == null) {
      setState(() => _errorMessage = 'Masukkan angka yang valid!');
      return;
    }

    setState(() {
      _steps.add(CalcStep(operation: op, value: val));
      _controller.clear();
      _errorMessage = '';
    });
  }

  void _removeStep(int index) {
    setState(() => _steps.removeAt(index));
  }

  void _clearAll() {
    setState(() {
      _steps.clear();
      _controller.clear();
      _errorMessage = '';
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
            // 1. Panel Hasil (Total Real-time)
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
                  Text(
                    _steps.isEmpty ? '0' : _formatNumber(_currentTotal),
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Input Angka
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan angka...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerLeft, child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13))),
            ],
            const SizedBox(height: 16),

            // 3. Tombol 4 Operasi Kalkulator
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

            // 4. Header Riwayat
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

            // 5. List Riwayat Hitung
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