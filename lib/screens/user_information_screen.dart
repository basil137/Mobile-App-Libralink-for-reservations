import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/exptions.dart';
import 'package:Libralink/util/img_fonts_clr.dart';
import 'package:Libralink/widgets/card_user_info.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key, this.userName, this.userId});
  final String? userName;
  final String? userId;
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 200,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AddImage.logo,
                width: 40,
              ),
              const SizedBox(
                width: 8,
              ),
              Text("Libralink",
                  style: TextStyle(
                      color: AddColor.logoColor, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          children: [
            CardUserInfo(
              colorEdit: Colors.blue[900]!,
              keyBoardType: TextInputType.name,
              leadText: "Name",
              titleText: widget.userName.toString(),
              
              validator: (val) {
                if (val!.isEmpty) {
                  return "this field is requaired";
                } else {
                  return null;
                }
              },
            ),
            CardUserInfo(
              colorEdit: Colors.blue[900]!,
              leadText: "ID Num",
              titleText: widget.userId.toString(),
              keyBoardType: TextInputType.number,
              validator: (val) {
                RegExp regId = RegExp(RegExption.noNumber);
                if (val!.isEmpty) {
                  // idValid = false;
                  return "this field is requaired";
                }
                if (regId.hasMatch(val)) {
                  // idValid = false;
                  return "must be only numbers";
                }
                if (val.length != 6) {
                  // idValid = false;
                  return "requaired only6 digits";
                } else {
                  // idValid = true;
                  return null;
                }
              },
            ),
            CardUserInfo(
              colorEdit: Colors.blueGrey[300]!,
              keyBoardType: TextInputType.emailAddress,
              leadText: "Email",
              titleText: FirebaseAuth.instance.currentUser!.email.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
