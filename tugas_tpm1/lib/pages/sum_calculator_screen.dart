import 'package:flutter/material.dart';

class CharacterCounterScreen extends StatefulWidget {
  const CharacterCounterScreen({super.key});

  @override
  State<CharacterCounterScreen> createState() => _CharacterCounterScreenState();
}

class _CharacterCounterScreenState extends State<CharacterCounterScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _dataList = [];

  void _addData() {
    final String text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        _dataList.add({
          'text': text,
          'length': text.length, 
        });
        _controller.clear();
      });
    }
  }

  void _removeData(int index) {
    setState(() => _dataList.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    int totalCharacters = _dataList.fold(0, (sum, item) => sum + (item['length'] as int));

    return Scaffold(
      appBar: AppBar(title: const Text('Character Counter')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF3267E3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Jumlah Data', '${_dataList.length}'),
                  _buildStat('Total Karakter', '$totalCharacters'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text, 
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata/kalimat...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3267E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addData,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Daftar Input', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: ListView.separated(
                itemCount: _dataList.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = _dataList[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: Text('${index + 1}', style: const TextStyle(color: Color(0xFF3267E3))),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['text'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '(${item['length']} kar)',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeData(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}