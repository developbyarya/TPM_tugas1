import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = "0";
  String? _firstNum;
  String? _operation;
  bool _waitingForSecond = false;
  String _expression = "";
  bool _justCalculated = false;

  void _handleNumber(String num) {
    if (_justCalculated) {
      setState(() {
        _display = num;
        _expression = "";
        _justCalculated = false;
      });
      return;
    }
    if (_waitingForSecond) {
      setState(() {
        _display = num;
        _waitingForSecond = false;
      });
      return;
    }
    setState(() {
      if (_display == "0" && num != ".") {
        _display = num;
      } else {
        if (num == "." && _display.contains(".")) return;
        if (_display.length >= 12) return;
        _display += num;
      }
    });
  }

  void _handleOperation(String op) {
    setState(() {
      _justCalculated = false;
      if (_operation != null && !_waitingForSecond) {
        double a = double.tryParse(_firstNum ?? "0") ?? double.nan;
        double b = double.tryParse(_display) ?? double.nan;
        
        double result = _compute(a, b, _operation!);
        String resultStr = _formatResult(result);
        
        _display = resultStr;
        _firstNum = resultStr;
        _expression = "$resultStr $op";
      } else {
        _firstNum = _display;
        _expression = "$_display $op";
      }
      _operation = op;
      _waitingForSecond = true;
    });
  }

  double _compute(double a, double b, String op) {
    if (op == "+") return a + b;
    if (op == "-") return a - b;
    if (op == "×") return a * b;
    if (op == "÷") {
      if (b == 0) return double.nan;
      return a / b;
    }
    return b;
  }

  String _formatResult(double n) {
    if (n.isNaN) return "Error";
    if (n.isInfinite) return "∞";
    
    // Menghindari 0 berlebih di belakang desimal (mirip toFixed di JS)
    String str = (n % 1 == 0) ? n.toInt().toString() : n.toStringAsFixed(10);
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0*$'), ''); // Hapus trailing zero
      str = str.replaceAll(RegExp(r'\.$'), ''); // Hapus titik jika tidak ada desimal lagi
    }
    
    return str.length > 12 ? n.toStringAsExponential(4) : str;
  }

  void _handleEquals() {
    if (_operation == null || _firstNum == null) return;
    
    double a = double.tryParse(_firstNum!) ?? double.nan;
    double b = double.tryParse(_display) ?? double.nan;
    
    double result = _compute(a, b, _operation!);
    String resultStr = _formatResult(result);
    
    setState(() {
      _expression = "$_firstNum $_operation $_display =";
      _display = resultStr;
      _firstNum = null;
      _operation = null;
      _waitingForSecond = false;
      _justCalculated = true;
    });
  }

  void _handleClear() {
    setState(() {
      _display = "0";
      _firstNum = null;
      _operation = null;
      _waitingForSecond = false;
      _expression = "";
      _justCalculated = false;
    });
  }

  void _handleCE() {
    setState(() {
      _display = "0";
      _waitingForSecond = false;
      _justCalculated = false;
    });
  }

  void _handleBackspace() {
    setState(() {
      if (_justCalculated) {
        _handleClear();
        return;
      }
      if (_display == "Error" || _display == "∞" || _display.length <= 1) {
        _display = "0";
      } else {
        _display = _display.substring(0, _display.length - 1);
      }
    });
  }

  void _handleToggleSign() {
    setState(() {
      if (_display == "0" || _display == "Error" || _display == "∞") return;
      if (_display.startsWith("-")) {
        _display = _display.substring(1);
      } else {
        _display = "-$_display";
      }
    });
  }

  bool _isOpActive(String op) => _operation == op && _waitingForSecond;

  // Helpers untuk styling dinamis
  double _getDisplayFontSize() {
    if (_display.length > 10) return 32.0;
    if (_display.length > 7) return 48.0;
    if (_display.length > 5) return 60.0;
    return 72.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('Kalkulator'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Area Display
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 24, bottom: 16, left: 24, top: 8),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: const TextStyle(color: Colors.white54, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 100),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _getDisplayFontSize(),
                        fontWeight: FontWeight.w300,
                        height: 1.0, // Menyesuaikan line-height
                      ),
                      child: Text(_display),
                    ),
                  ],
                ),
              ),
            ),

            // Area Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // Baris 1: AC, CE, +/-, ÷
                  Row(
                    children: [
                      _buildBtn("AC", const Color(0xFFA5A5A5), const Color(0xFF1C1C1E), _handleClear),
                      _buildBtn("CE", const Color(0xFFA5A5A5), const Color(0xFF1C1C1E), _handleCE),
                      _buildBtn("+/−", const Color(0xFFA5A5A5), const Color(0xFF1C1C1E), _handleToggleSign),
                      _buildOpBtn("÷"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris 2: 7, 8, 9, ×
                  Row(
                    children: [
                      _buildNumBtn("7"),
                      _buildNumBtn("8"),
                      _buildNumBtn("9"),
                      _buildOpBtn("×"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris 3: 4, 5, 6, -
                  Row(
                    children: [
                      _buildNumBtn("4"),
                      _buildNumBtn("5"),
                      _buildNumBtn("6"),
                      _buildOpBtn("-"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris 4: 1, 2, 3, +
                  Row(
                    children: [
                      _buildNumBtn("1"),
                      _buildNumBtn("2"),
                      _buildNumBtn("3"),
                      _buildOpBtn("+"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris 5: 0, ., ⌫, =
                  Row(
                    children: [
                      _buildNumBtn("0"),
                      _buildNumBtn("."),
                      _buildBtn("⌫", const Color(0xFFA5A5A5), const Color(0xFF1C1C1E), _handleBackspace),
                      _buildBtn("=", const Color(0xFF30D158), Colors.white, _handleEquals, isLargeText: true),
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

  // Builder Button untuk Angka (Warna default Putih, Teks Gelap)
  Widget _buildNumBtn(String text) {
    return _buildBtn(text, Colors.white, const Color(0xFF1C1C1E), () => _handleNumber(text), isLargeText: true);
  }

  // Builder Button untuk Operator (Warna Oranye dinamis)
  Widget _buildOpBtn(String op) {
    bool isActive = _isOpActive(op);
    return _buildBtn(
      op,
      isActive ? Colors.white : const Color(0xFFFF9F0A),
      isActive ? const Color(0xFFFF9F0A) : Colors.white,
      () => _handleOperation(op),
      isLargeText: true,
    );
  }

  // Widget Button Dasar
  Widget _buildBtn(String text, Color bgColor, Color textColor, VoidCallback onTap, {bool isLargeText = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40), // Bentuk membulat (pill/circle)
          child: Ink(
            height: 72,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: isLargeText ? 28 : 20,
                  fontWeight: isLargeText ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}