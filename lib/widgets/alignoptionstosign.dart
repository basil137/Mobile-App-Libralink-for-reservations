import 'package:flutter/material.dart';

class AlignOptionsToSign extends StatelessWidget {
  const AlignOptionsToSign({
    super.key,
    required this.optionToSign,
    required this.quastion, required this.goToWidget,
  });

  final String optionToSign;
  final String quastion;
  final Widget goToWidget;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        //text.rich
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            quastion,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => goToWidget,
                  ));
            },
            child: Text(
              optionToSign,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
