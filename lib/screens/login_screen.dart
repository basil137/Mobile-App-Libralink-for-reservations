
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/exptions.dart';
import 'package:Libralink/screens/reg_screen.dart';
import 'package:Libralink/util/screens.dart';
import 'package:Libralink/widgets/alignoptionstosign.dart';
import 'package:Libralink/widgets/stackbackgroundcontainer.dart';
import 'package:Libralink/widgets/textfeilds.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  bool secreteyePassLog = true;

  bool emailValid = true; //exist email or not
  bool passValid = true; //match pass with database or not

  GlobalKey<FormState> keyformLog = GlobalKey();
  TextEditingController emailcontrollerLog = TextEditingController();
  TextEditingController passcontrollerLog = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        const StackBackgrounContainer(
                          subjectText: "Hello\nLog in!",
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, top: 8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: Colors.white,
                          ),
                          height: MediaQuery.sizeOf(context).height *0.78,
                          width: double.infinity,
                          child: Form(
                            key: keyformLog,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomTextFormFeild(
                                  customController: emailcontrollerLog,
                                  lableText: "Email",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    RegExp regEmail = RegExp(RegExption.email);

                                    if (val!.isEmpty) {
                                      return "this field is requaired";
                                    }

                                    if (!regEmail.hasMatch(val)) {
                                      return "'$val' is invalid email";
                                    }
                                    if (emailValid == false) {
                                      return "No user found for that email.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                TextFormField(
                                  //password..................................///////////////////////////////////////////////////
                                  controller: passcontrollerLog,
                                  autovalidateMode: AutovalidateMode.always,

                                  validator: (val) {
                                    RegExp regPassword =
                                        RegExp(RegExption.passwordValedate);

                                    if (val!.isEmpty) {
                                      return "this field is requaired";
                                    }

                                    if (!regPassword.hasMatch(val)) {
                                      return "invalid Password";
                                    }
                                    if (!passValid) {
                                      return "Wrong password provided for that user.";
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: secreteyePassLog,
                                  decoration: InputDecoration(
                                      errorBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black87)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black87)),
                                      suffixIcon: IconButton(
                                        color: Colors.black54,
                                        onPressed: () {
                                          setState(() {
                                            secreteyePassLog =
                                                !secreteyePassLog;
                                          });
                                        },
                                        icon: secreteyePassLog
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(
                                                Icons.visibility_rounded),
                                      ),
                                      label: const Text(
                                        'Password',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (keyformLog.currentState!.validate()) {}
                                    try {
                                      setState(() {
                                        loading = true;
                                      });
                                      final credential = await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                        email: emailcontrollerLog.text,
                                        password: passcontrollerLog.text,
                                      );
                                      setState(() {
                                        loading = false;
                                      });
                                      if (credential.user!.emailVerified) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Screens.homePageScreen,
                                            (route) => false);
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        // FirebaseAuth.instance.currentUser!
                                        //     .sendEmailVerification;
                                        credential.user!.sendEmailVerification();
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.scale,
                                          title: 'Verify Your Email!',
                                          desc:
                                              'your email has not been verified, check your email and login again',
                                          btnOkOnPress: () {},
                                          btnOkColor: const Color(0xff9A8877),
                                          btnOk: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 36,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                        Color(0xff9A8877),
                                                        Color(0xffC3CFE2),
                                                      ])),
                                              child: const Text("OK"),
                                            ),
                                          ),
                                        ).show();
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        loading = false;
                                      });
                                      if (e.code == 'user-not-found') {
                                        print(
                                            '===========================No user found for that email.');
                                        // setState(() {
                                        emailValid = false;
                                        // });
                                      } else {
                                        // setState(() {
                                        emailValid = true;
                                        // });
                                      }

                                      if (e.code == 'wrong-password') {
                                        print(
                                            '=================================Wrong password provided for that user.');
                                        // setState(() {
                                        passValid = false;
                                        // });
                                      } else {
                                        // setState(() {
                                        passValid = true;
                                        // });
                                      }
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 56,
                                    width: 296,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xff9A8877),
                                        Color(0xffC3CFE2),
                                      ]),
                                    ),
                                    child: const Text(
                                      'LOG IN',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                                const AlignOptionsToSign(
                                  optionToSign: "Sign up",
                                  quastion: "don't have an account?",
                                  goToWidget: SignUpScreen(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
