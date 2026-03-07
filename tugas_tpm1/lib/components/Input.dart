import 'package:flutter/material.dart';
import 'package:tugas_tpm1/utils/colors.dart' as UserColors;

class Input extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  Input({super.key, required this.label, this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.8, color: UserColors.Colors.textGrey),),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText ?? 'Masukkan ${label.toLowerCase()}',
            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: UserColors.Colors.hintOverlay),
            fillColor: UserColors.Colors.inputBGPrimary,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }
}