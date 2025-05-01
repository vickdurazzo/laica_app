import 'package:flutter/material.dart';
import 'package:laica_app/utils/device_utils.dart';

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
    double screenWidth = DeviceUtils.getScreenWidth(context);
    double buttonWidth = screenWidth * 0.8; // 85% da largura da tela
    return Container(
      width: buttonWidth > 500 ? 500 : buttonWidth, // Max width of 500
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
