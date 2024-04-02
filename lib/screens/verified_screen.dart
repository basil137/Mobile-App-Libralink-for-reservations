import 'package:flutter/material.dart';
import 'package:project2/util/img_fonts_clr.dart';
import 'package:project2/util/screens.dart';

class VerifiedScreen extends StatefulWidget {
  const VerifiedScreen({super.key});

  @override
  State<VerifiedScreen> createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AddImage.logo,
              width: 40,
            ),
            const SizedBox(
              width: 8,
            ),
            Text("Libralink", style: TextStyle(color: AddColor.logoColor,fontWeight: FontWeight.bold))
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Please Cheack your email then login",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Screens.logInScreen, (route) => false);
            },
            child: Container(
              alignment: Alignment.center,
              height: 36,
              width: 160,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(colors: [
                    Color(0xff9A8877),
                    Color(0xffC3CFE2),
                  ])),
              child: const Text(
                "Go To Login",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
