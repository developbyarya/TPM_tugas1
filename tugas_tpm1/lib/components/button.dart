import 'package:flutter/material.dart';
import 'package:tugas_tpm1/utils/colors.dart' as UserColors;

enum ButtonType {
  primary, secondary
}

class Button extends StatelessWidget {
  final ButtonType type;
  final String text;
  final VoidCallback onPressed;
  final Icon? leadingIcon;
  final Icon? trailingIcon;
  late ButtonStyle style;
  Button({super.key, required this.type, required this.text, required this.onPressed, this.leadingIcon, this.trailingIcon}){
    switch (type) {
      case ButtonType.primary:
        style = ButtonStyle(
          backgroundColor:WidgetStateProperty.all(UserColors.Colors.primary),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        );
        break;
      case ButtonType.secondary:
        style = ButtonStyle(
          backgroundColor:WidgetStateProperty.all(UserColors.Colors.secondaryLight),
          foregroundColor: WidgetStateProperty.all(UserColors.Colors.secondary),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),

        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, style: style, child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          if (leadingIcon != null) leadingIcon!,
          Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.8),),
          if (trailingIcon != null) SizedBox(width: 8),
          if (trailingIcon != null) trailingIcon!,
          ],
        ),
      ),
    );
  }
}