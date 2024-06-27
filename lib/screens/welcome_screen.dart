import 'package:flutter/material.dart';
import 'package:Libralink/screens/reg_screen.dart';
import 'package:Libralink/util/img_fonts_clr.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( 
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff9A8877),
          Color(0xffC3CFE2),
        ])),
        child: Column(children: [
           Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Image.asset(AddImage.logo,width: 200,),
          ),
          const SizedBox(
            height: 16,
          ),
           Text.rich(
            TextSpan(
              children: [
                const TextSpan(text:"Welcome To ",style: TextStyle(fontSize: 30, color: Colors.black,fontWeight: FontWeight.w600), ),
                TextSpan(text: "Libralink",style: TextStyle(fontSize: 30, color: AddColor.logoColor,fontWeight: FontWeight.w600),),
              ]
            )
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: Container(
              height: 56,
              width: 320,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Text(
                'LOG IN',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()));
            },
            child: Container(
              alignment: Alignment.center,
              height: 56,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Text(
                'SIGN UP',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87 ),
              ),
            ),
          ),
          const Spacer(),
          
        ]),
      ),
    );
  }
}
