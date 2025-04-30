import 'package:flutter/material.dart';

class AppSubtitle extends StatelessWidget {
  final String text;

  const AppSubtitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
        ),
    );
  }
}