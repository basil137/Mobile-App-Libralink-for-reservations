import 'package:flutter/material.dart';

class ContainerOfDialog extends StatelessWidget {
  const ContainerOfDialog({
    super.key, required this.text, this.widthContainer,
  });
  final String text;
  final double? widthContainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 36,
      width:widthContainer==null? 50 :widthContainer,
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