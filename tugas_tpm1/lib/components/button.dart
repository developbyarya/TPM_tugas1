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
  ButtonStyle style = const ButtonStyle();
  Button({super.key, required this.type, required this.text, required this.onPressed, this.leadingIcon, this.trailingIcon}){
    switch (type) {
      case ButtonType.primary:
        style = ButtonStyle(
          backgroundColor:WidgetStateProperty.all(UserColors.Colors.primary),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        );
        break;
      case ButtonType.secondary:
        style = ButtonStyle(
          backgroundColor:WidgetStateProperty.all(UserColors.Colors.secondaryLight),
          foregroundColor: WidgetStateProperty.all(UserColors.Colors.secondary),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(text));
  }
}