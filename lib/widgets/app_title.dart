import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String text;

  const AppTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        height: 44 / 34,
      ),
    );
  }
}