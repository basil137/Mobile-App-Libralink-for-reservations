
import 'package:flutter/material.dart';

class PrimeryContainer extends StatelessWidget {
  const PrimeryContainer({
    super.key, required this.text, required this.textColor,
  });
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 56,
      width: 296,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [
          Color(0xff9A8877),
          Color(0xffC3CFE2),
        ]),
      ),
      child:  Text(
        text,
        style:  TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color:textColor),
      ),
    );
  }
}
