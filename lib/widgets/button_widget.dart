import 'package:flutter/material.dart';

import '../my_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  const ButtonWidget(
      {super.key,
      required this.label,
      this.bgColor,
      this.textColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.00,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.transparent),
        color: bgColor ?? MyColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: textColor ?? MyColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
