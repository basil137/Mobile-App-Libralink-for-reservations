import 'package:flutter/material.dart';

// class EmailTextFormFeild extends StatelessWidget {
//   const EmailTextFormFeild({
//     super.key,
//     required this.emailController,
//     required this.emailExistSignUp, required this.lableText, required this.emailExistLogIn,
//   });

//   final TextEditingController emailController;
//   final bool emailExistSignUp;
//   final String lableText;
//   final bool emailExistLogIn;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: emailController,
//       autovalidateMode: AutovalidateMode.always,
//       validator: (val) {
//         RegExp regEmail = RegExp(RegExption.email);

//         if (val!.isEmpty) {
//           return "this field is requaired";
//         }

//         if (!regEmail.hasMatch(val)) {
//           return "'$val' is invalid email";
//         }
//         if (emailExistSignUp == false) {
//           return "The account already exists for that email.";
//         }
//         if (emailExistLogIn == false) {
//           return "No user found for that email.";
//         }
//         else {
//           return null;

//         }
//       },
//       decoration:  InputDecoration(
//           errorBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.black87)),
//           focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.black87)),
//           label: Text(
//             lableText,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           )),
//     );
//   }
// }

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
