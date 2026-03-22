import 'package:flutter/material.dart';

class DateCalculatorScreen extends StatefulWidget {
  const DateCalculatorScreen({super.key});

  @override
  State<DateCalculatorScreen> createState() => _DateCalculatorScreenState();
}

class _DateCalculatorScreenState extends State<DateCalculatorScreen> {
  DateTime? _wetonDate;
  String _wetonResult = '';

  DateTime? _dobDate;
  String _ageResult = '';

  DateTime? _hijriDate;
  String _hijriResult = '';

  // Fungsi SnackBar dibuat default bawaan Flutter
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  void _calculateWeton(DateTime date) {
    final DateTime epoch = DateTime(1945, 8, 17);
    final int diff = date.difference(epoch).inDays;

    const List<String> pasaranList = [
      'Legi',
      'Pahing',
      'Pon',
      'Wage',
      'Kliwon',
    ];
    int pasaranIndex = diff % 5;
    if (pasaranIndex < 0) pasaranIndex += 5;

    const List<String> hariList = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    String hari = hariList[date.weekday - 1];

    setState(() {
      _wetonDate = date;
      _wetonResult = '$hari ${pasaranList[pasaranIndex]}';
    });
  }

  void _calculateAge(DateTime dob) {
    DateTime now = DateTime.now();

    // Mencegah input tanggal masa depan (teks error dibuat natural)
    if (dob.isAfter(now)) {
      _showError('Tanggal lahir tidak valid');
      return;
    }

    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;

    if (days < 0) {
      months--;
      DateTime prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    Duration timeDiff = now.difference(DateTime(now.year, now.month, now.day));
    int hours = timeDiff.inHours;
    int minutes = timeDiff.inMinutes % 60;

    setState(() {
      _dobDate = dob;
      _ageResult =
          '$years Tahun, $months Bulan, $days Hari\n$hours Jam, $minutes Menit';
    });
  }

  void _calculateHijri(DateTime date) {
    int day = date.day;
    int month = date.month;
    int year = date.year;

    if (month < 3) {
      year -= 1;
      month += 12;
    }

    int a = (year / 100).floor();
    int b = 2 - a + (a / 4).floor();

    int jd =
        (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524;
    jd = jd - 1948440 + 10632;

    int n = ((jd - 1) / 10631).floor();
    jd = jd - 10631 * n + 354;
    int j =
        (((10985 - jd) / 5316).floor()) * ((50 * jd) / 17719).floor() +
        ((jd / 5670).floor()) * ((43 * jd) / 15238).floor();
    jd =
        jd -
        (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
        ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
        29;

    int hMonth = ((24 * jd) / 709).floor();
    int hDay = jd - ((709 * hMonth) / 24).floor();
    int hYear = 30 * n + j - 30;

    const List<String> hijriMonths = [
      'Muharram',
      'Safar',
      'Rabiul Awal',
      'Rabiul Akhir',
      'Jumadil Awal',
      'Jumadil Akhir',
      'Rajab',
      'Sya\'ban',
      'Ramadhan',
      'Syawal',
      'Dzulqa\'dah',
      'Dzulhijjah',
    ];

    setState(() {
      _hijriDate = date;
      _hijriResult = '$hDay ${hijriMonths[hMonth - 1]} $hYear H';
    });
  }

  Future<void> _selectDate(
    BuildContext context,
    Function(DateTime) onSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Batas kalender diperlebar (Tahun 1 sampai 9999)
      firstDate: DateTime(1),
      lastDate: DateTime(9999),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF3267E3)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Kalkulator Waktu & Tanggal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildFeatureCard(
              title: '1. Cek Hari & Weton',
              icon: Icons.calendar_month,
              color: Colors.orange,
              selectedDate: _wetonDate,
              resultText: _wetonResult,
              onTap: () => _selectDate(context, _calculateWeton),
              placeholder: 'Pilih tanggal untuk melihat weton',
            ),
            const SizedBox(height: 24),

            _buildFeatureCard(
              title: '2. Kalkulator Umur Detail',
              icon: Icons.cake,
              color: Colors.green,
              selectedDate: _dobDate,
              resultText: _ageResult,
              onTap: () => _selectDate(context, _calculateAge),
              placeholder: 'Pilih tanggal lahir Anda',
            ),
            const SizedBox(height: 24),

            _buildFeatureCard(
              title: '3. Konversi Masehi ke Hijriah',
              icon: Icons.brightness_3,
              color: Colors.purple,
              selectedDate: _hijriDate,
              resultText: _hijriResult,
              onTap: () => _selectDate(context, _calculateHijri),
              placeholder: 'Pilih tanggal Masehi',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required MaterialColor color,
    required DateTime? selectedDate,
    required String resultText,
    required VoidCallback onTap,
    required String placeholder,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.shade900,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit_calendar),
                  label: Text(
                    selectedDate == null
                        ? 'Pilih Tanggal'
                        : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: resultText.isNotEmpty
                        ? color.shade600
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText.isNotEmpty ? 'Hasil:' : placeholder,
                        style: TextStyle(
                          color: resultText.isNotEmpty
                              ? Colors.white70
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      if (resultText.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          resultText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
