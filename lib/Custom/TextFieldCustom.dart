import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String data;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  CustomText(
      this.data, {
        this.textColor,
        this.fontSize,
        this.fontWeight,
        this.fontFamily,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? 'regular',
      ),
    );
  }
}
