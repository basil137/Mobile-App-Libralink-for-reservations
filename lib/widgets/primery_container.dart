
import 'package:flutter/material.dart';

class PrimeryContainer extends StatelessWidget {
  const PrimeryContainer({
    super.key, required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin:const EdgeInsets.only(right: 32, left: 32),
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
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87),
      ),
    );
  }
}
