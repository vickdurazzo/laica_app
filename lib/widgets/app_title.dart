import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String text;
  final double? fontSize;

  const AppTitle({super.key, required this.text, this.fontSize = 34.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        height: 44 / 34,
      ),
    );
  }
}