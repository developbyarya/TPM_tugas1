import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_tpm1/components/Input.dart';
import 'package:tugas_tpm1/components/button.dart';
import 'package:tugas_tpm1/utils/colors.dart' as UserColors;

class CekBilanganScreen extends StatefulWidget {
  const CekBilanganScreen({super.key});

  @override
  State<CekBilanganScreen> createState() => _CekBilanganScreenState();
}

class _CekBilanganScreenState extends State<CekBilanganScreen> {
  final TextEditingController _numberController = TextEditingController();
  bool _showResult = false;
  int? _checkedNumber;
  bool? _isOdd;
  bool? _isPrime;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  bool _checkIsPrime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    for (int i = 3; i * i <= n; i += 2) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void _cekBilangan() {
    final text = _numberController.text.trim();
    if (text.isEmpty) return;

    final number = int.tryParse(text);
    if (number == null) return;

    setState(() {
      _checkedNumber = number;
      _isOdd = number % 2 != 0;
      _isPrime = _checkIsPrime(number);
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Check Number',
          style: TextStyle(
            fontFamily: GoogleFonts.inter().fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Input Section Card
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Masukkan Bilangan',
                      style: TextStyle(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: UserColors.Colors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Input(
                      label: 'Bilangan Bulat',
                      controller: _numberController,
                      hintText: 'Contoh: 17',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        type: ButtonType.primary,
                        text: 'Cek Bilangan',
                        leadingIcon: const Icon(Icons.search, size: 20),
                        onPressed: _cekBilangan,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Result Section Card
              if (_showResult && _checkedNumber != null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: UserColors.Colors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: UserColors.Colors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil Pengecekan Bilangan',
                        style: TextStyle(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$_checkedNumber',
                        style: TextStyle(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Jenis Bilangan (Odd/Even)
                          Expanded(
                            child: _ResultTag(
                              label: 'Jenis Bilangan',
                              value: _isOdd! ? 'GANJIL' : 'GENAP',
                              valueBgColor: const Color(0xFFFFEB3B),
                              valueTextColor: UserColors.Colors.textBlack,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Bilangan Prima
                          Expanded(
                            child: _ResultTag(
                              label: 'Bilangan Prima',
                              value: _isPrime! ? 'PRIMA ✓' : 'BUKAN PRIMA',
                              valueBgColor: _isPrime!
                                  ? UserColors.Colors.success
                                  : const Color(0xFFE53935),
                              valueTextColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultTag extends StatelessWidget {
  final String label;
  final String value;
  final Color valueBgColor;
  final Color valueTextColor;

  const _ResultTag({
    required this.label,
    required this.value,
    required this.valueBgColor,
    required this.valueTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: valueBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
