import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD14EBA),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            
          ),
          
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white,height: 1.27), // Texto branco
        ),
      ),
    );
  }
}
