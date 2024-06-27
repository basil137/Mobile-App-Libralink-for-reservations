import 'package:flutter/material.dart';



class CustomTextFormFeild extends StatelessWidget {
  const CustomTextFormFeild({
    super.key,
    required this.customController,
    required this.lableText,
    required this.keyboardType,
    this.validator,
  });

  final TextEditingController customController;
  final String lableText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: customController,
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
      decoration: InputDecoration(
        errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87)),
        label: Text(
          lableText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
