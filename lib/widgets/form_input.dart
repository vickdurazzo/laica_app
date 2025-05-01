import 'package:flutter/material.dart';
import 'package:laica_app/utils/device_utils.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData suffixIcon;
  final String inputType;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.suffixIcon,    
    this.onTap,
    this.inputType = 'text', 
  });

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    if(inputType == 'email'){
      keyboardType = TextInputType.emailAddress;
    } else if(inputType == 'password'){
      keyboardType = TextInputType.visiblePassword;
    } else if (inputType == 'date') {
      keyboardType = TextInputType.datetime;
    } else if (inputType == 'name') {
      keyboardType = TextInputType.name;
    } else if(inputType == 'cellphone'){
      keyboardType = TextInputType.phone;
    }else {
      keyboardType = TextInputType.text;
    }
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final textFieldWidth = screenWidth * 0.85;
    final maxWidth = 500.0;

    return Center(
      
      child: SizedBox(
        width: textFieldWidth > maxWidth ? maxWidth : textFieldWidth,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            readOnly: onTap != null,
            obscureText: inputType == 'password',
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(suffixIcon, color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ),
      ),
    );
  }
}