import 'package:flutter/material.dart';

class GroupDataScreen extends StatelessWidget {
  const GroupDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> members = [
      {"name": "Muhammad Faisal Amin", "nim": "12345678"},
      {"name": "Budi Santoso", "nim": "12345679"},
      {"name": "Citra Dewi", "nim": "12345680"},
      {"name": "Dian Pratiwi", "nim": "12345681"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('About Team')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.diamond_outlined, color: Color(0xFF3267E3)),
                SizedBox(width: 8),
                Text(
                  'Anggota Kelompok',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: members.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.transparent),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        members[index]['name']!,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        members[index]['nim']!,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}