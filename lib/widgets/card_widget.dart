import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget? child;

  const CardWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.0,
      height: 164.0,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(16, 6, 30, 0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF10061e),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
