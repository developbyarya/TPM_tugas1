import 'package:flutter/material.dart';
import 'package:tugas_tpm1/components/Input.dart';
import 'package:tugas_tpm1/components/button.dart';

class PyramidScreen extends StatefulWidget {
  const PyramidScreen({super.key});

  @override
  State<PyramidScreen> createState() => _PyramidScreenState();
}

class _PyramidScreenState extends State<PyramidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Pyramid Formula'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text('Parameter Piramid'),
              Input(
                label: 'Height',
              ),
              Input(
                label: 'Width',
              ),
              Input(
                label: 'Length',
              ),
              Row(
                spacing: 12,
                children: [
                Expanded(child: Button(type: ButtonType.primary, text: 'Hitung', leadingIcon: Icon(Icons.calculate), onPressed: (){})),
                Expanded(child: Button(type: ButtonType.secondary, text: 'Reset', onPressed: (){})),
              ],)
            ],
          )
        ),
      )
    );
  }
}