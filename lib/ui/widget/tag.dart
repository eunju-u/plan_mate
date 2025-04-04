import 'package:flutter/material.dart';
import 'package:plan_mate/utils/colors.dart';

class Tag extends StatelessWidget {
  final Color? color;
  final String text;

  const Tag({
    super.key,
    this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 1,
          color: color ?? whiteColor,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            height: 1,
            fontFamily: "400m",
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}