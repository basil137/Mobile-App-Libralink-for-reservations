import 'package:flutter/material.dart';
import 'package:Libralink/util/img_fonts_clr.dart';
import 'package:Libralink/util/screens.dart';

class VerifiedScreen extends StatefulWidget {
   VerifiedScreen({super.key, required this.myId, required this.myEmail, required this.myName, required this.mypass});
  final String myId;
  final String myEmail;
  final String myName;
  final String mypass;




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
              "Please verify your email",
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
           Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "You're almost there! We sent an email to ",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${widget.myEmail}",
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
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
                "Go to Login",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
