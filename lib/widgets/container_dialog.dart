import 'package:flutter/material.dart';

class ContainerOfDialog extends StatelessWidget {
  const ContainerOfDialog({
    super.key, required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 36,
      width: 50,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(100),
          gradient:
              const LinearGradient(colors: [
            Color(0xff9A8877),
            Color(0xffC3CFE2),
          ])),
      child:  Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}