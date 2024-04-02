import 'package:flutter/material.dart';

class StackBackgrounContainer extends StatelessWidget {
  const StackBackgrounContainer({
    super.key, required this.subjectText,
  });
 final String subjectText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 56, left: 24),
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xff9A8877),
          Color(0xffC3CFE2),
        ]),
      ),
      child:  Text(
        subjectText,
        style: const TextStyle(
            fontSize: 30,
            color: Colors.black54,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
