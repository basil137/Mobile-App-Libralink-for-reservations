// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/exptions.dart';
import 'package:project2/screens/login_screen.dart';
import 'package:project2/screens/verified_screen.dart';
import 'package:project2/widgets/alignoptionstosign.dart';
import 'package:project2/widgets/stackbackgroundcontainer.dart';
import 'package:project2/widgets/textfeilds.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;

  bool secreteyePass = true; //for show pass
  bool secreteyeNewPass = true;

  String? passconfirm;
  bool passmatch =
      false; //allow to craet an acount or not based on passconfirm is match with pass

  bool emailValid = true; //already exist or not
  bool passStrong = true; //week pass or not
  bool idValid = false;

  GlobalKey<FormState> keyform = GlobalKey(); //for valditor
  TextEditingController nameControllerSign = TextEditingController();
  TextEditingController idControllerSign = TextEditingController();
  TextEditingController passControllerSign = TextEditingController();
  TextEditingController emailControllerSign = TextEditingController();
  TextEditingController passConfirmControllerSign = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() {
    return users
        .add({
          'userName': nameControllerSign.text,
          'userEmail': emailControllerSign.text,
          'userId': idControllerSign.text,
        })
        .then((value) => print("==========================User Added"))
        .catchError((error) =>
            print("======================Failed to add user: $error"));
  }

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
                              subjectText: "Create Your\nAccount"),
                          Container(
                            // margin: EdgeInsets.only(top: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16),

                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              color: Colors.white,
                            ),
                            height: MediaQuery.sizeOf(context).height - 200,
                            width: double.infinity,
                            child: Form(
                              key: keyform,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextFormFeild(
                                    keyboardType: TextInputType.name,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "this field is requaired";
                                      } else {
                                        return null;
                                      }
                                    },
                                    customController: nameControllerSign,
                                    lableText: "Full Name",
                                  ),

                                  CustomTextFormFeild(
                                    customController: idControllerSign,
                                    lableText: "ID Number",
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      RegExp regId =
                                          RegExp(RegExption.noNumber);
                                      if (val!.isEmpty) {
                                        idValid = false;
                                        return "this field is requaired";
                                      }
                                      if (regId.hasMatch(val)) {
                                        idValid = false;
                                        return "must be only numbers";
                                      }
                                      if (val.length != 6) {
                                        idValid = false;
                                        return "requaired only6 digits";
                                      } else {
                                        idValid = true;
                                        return null;
                                      }
                                    },
                                  ),

                                  CustomTextFormFeild(
                                    customController: emailControllerSign,
                                    lableText: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      RegExp regEmail =
                                          RegExp(RegExption.email);

                                      if (val!.isEmpty) {
                                        return "this field is requaired";
                                      }

                                      if (!regEmail.hasMatch(val)) {
                                        return "'$val' is invalid email";
                                      }
                                      if (emailValid == false) {
                                        return "The account already exists for that email.";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),

                                  TextFormField(
                                    //password..................................///////////////////////////////////////////////////
                                    controller: passControllerSign,
                                    autovalidateMode: AutovalidateMode.always,
                                    onChanged: (value) {
                                      passconfirm = value;
                                    },
                                    validator: (val) {
                                      RegExp regPassword =
                                          RegExp(RegExption.passwordValedate);

                                      if (val!.isEmpty) {
                                        return "this field is requaired";
                                      }

                                      if (!regPassword.hasMatch(val)) {
                                        return "invalid Password";
                                      }
                                      if (!passStrong) {
                                        return "The password provided is too weak.";
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: secreteyePass,
                                    decoration: InputDecoration(
                                        errorBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black87)),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black87)),
                                        suffixIcon: IconButton(
                                          color: Colors.black54,
                                          onPressed: () {
                                            setState(() {
                                              secreteyePass = !secreteyePass;
                                            });
                                          },
                                          icon: secreteyePass
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
                                  TextFormField(
                                    //confirm password........................//////////////////////////////////////////////////////////////
                                    autovalidateMode: AutovalidateMode.always,
                                    controller: passConfirmControllerSign,
                                    validator: (val) {
                                      RegExp regNewPassword =
                                          RegExp(RegExption.passwordValedate);
                                      if (val!.isEmpty) {
                                        return "this field is requaired";
                                      }
                                      if (!regNewPassword.hasMatch(val)) {
                                        return "invalid Password";
                                      }
                                      if (val != passconfirm) {
                                        passmatch = false;
                                        return "dose isn't match with password";
                                      } else {
                                        passmatch = true;
                                        return null;
                                      }
                                    },
                                    obscureText: secreteyeNewPass,
                                    decoration: InputDecoration(
                                        errorBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black87)),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black87)),
                                        suffixIcon: IconButton(
                                          color: Colors.black54,
                                          onPressed: () {
                                            setState(() {
                                              secreteyeNewPass =
                                                  !secreteyeNewPass;
                                            });
                                          },
                                          icon: secreteyeNewPass
                                              ? const Icon(Icons.visibility_off)
                                              : const Icon(
                                                  Icons.visibility_rounded),
                                        ),
                                        label: const Text(
                                          'Confirm Password',
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
                                    //Button..............................................///////////////////////////////////////////
                                    onTap: () async {
                                      if (keyform.currentState!.validate()) {}

                                      if (passmatch &&
                                          nameControllerSign.text != '' &&
                                          idValid) {
                                        try {
                                          setState(() {
                                            loading = true;
                                          });
                                          final credential = await FirebaseAuth
                                              .instance
                                              .createUserWithEmailAndPassword(
                                            email: emailControllerSign.text,
                                            password: passControllerSign.text,
                                          );

                                          FirebaseAuth.instance.currentUser!
                                              .sendEmailVerification();

                                          addUser();
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const VerifiedScreen(),
                                              ),
                                              (route) => false);
                                        } on FirebaseAuthException catch (e) {
                                          setState(() {
                                            loading = false;
                                          });
                                          if (e.code == 'weak-password') {
                                            print(
                                                '==============The password provided is too weak.');
                                            // setState(() {
                                            passStrong = false;
                                            // });
                                          } else {
                                            // setState(() {
                                            passStrong = true;
                                            // });
                                          }
                                          if (e.code ==
                                              'email-already-in-use') {
                                            print(
                                                '==============The account already exists for that email.');
                                            setState(() {
                                              emailValid = false;
                                            });
                                          } else {
                                            setState(() {
                                              emailValid = true;
                                            });
                                          }
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
                                        'SIGN UP',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  // const Spacer(),
                                  const AlignOptionsToSign(
                                    quastion: "already have an account?",
                                    optionToSign: "Log in",
                                    goToWidget: LoginScreen(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]));
  }
}
