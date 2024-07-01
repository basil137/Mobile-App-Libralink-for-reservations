
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/exptions.dart';
import 'package:Libralink/screens/login_screen.dart';
import 'package:Libralink/screens/verified_screen.dart';
import 'package:Libralink/util/parameters.dart';
import 'package:Libralink/widgets/alignoptionstosign.dart';
import 'package:Libralink/widgets/stackbackgroundcontainer.dart';
import 'package:Libralink/widgets/textfeilds.dart';

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

  CollectionReference users = FirebaseFirestore.instance.collection(ParametersUsers.nameCollection);
  Future<void> addUser() {
    return users
        .add({
          ParametersUsers.userName: nameControllerSign.text,
          ParametersUsers.userEmail: emailControllerSign.text,
          ParametersUsers.userId: idControllerSign.text,
          ParametersUsers.checkIn:false,
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
                // physics: const NeverScrollableScrollPhysics(),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),

                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              color: Colors.white,
                            ),
                            height: MediaQuery.sizeOf(context).height*0.8,
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
                                        return "this field is required";
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
                                        return "this field is required";
                                      }
                                      if (regId.hasMatch(val)) {
                                        idValid = false;
                                        return "must be only numbers";
                                      }
                                      if (val.length != 6) {
                                        idValid = false;
                                        return "only 6 digits required";
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
                                        return "this field is required";
                                      }

                                      if (!regEmail.hasMatch(val)) {
                                        return "'$val' is invalid email";
                                      }
                                      if (emailValid == false) {
                                        return "This email is already used for another account.";
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
                                        return "this field is required";
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
                                                  Icons.visibility_rounded,color: Colors.black,),
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
                                        return "this field is required";
                                      }
                                      if (!regNewPassword.hasMatch(val)) {
                                        return "invalid Password";
                                      }
                                      if (val != passconfirm) {
                                        passmatch = false;
                                        return "dosen't match with password";
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
                                                  Icons.visibility_rounded,color: Colors.black,),
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
                                      if (keyform.currentState!.validate()) {}//sultan/////////

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

                                          

                                          credential.user!.sendEmailVerification();//sultan

                                          addUser();
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                     VerifiedScreen(myEmail:emailControllerSign.text,mypass:passControllerSign.text ,myId:idControllerSign.text,myName: nameControllerSign.text  ,),
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
