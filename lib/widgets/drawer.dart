import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/util/img_fonts_clr.dart';
import 'package:Libralink/util/screens.dart';

class ContainerOfDrawer extends StatelessWidget {
  const ContainerOfDrawer({
    super.key, required this.userName, required this.userId,
  });
  final String? userName;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          AddColor.gridColor1,
          AddColor.gridColor2,
        ],
      )),
      padding: const EdgeInsets.all(10),
      height: 600,
      child: ListView(
        children: [
          Row(
            children: [
              
              Expanded(
                child: ListTile(
                  textColor: Colors.black,
                  title: Text("$userName"),
                  subtitle: Text(FirebaseAuth.instance.currentUser!.email!),
                  titleTextStyle: const TextStyle(fontWeight: FontWeight.w700,fontSize: 18),
                  subtitleTextStyle: const TextStyle(fontSize: 12),
                  trailing: Text("$userId",),
                  leadingAndTrailingTextStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Screens.homePageScreen, (route) => false);
            },
            child: Card(
              color: AddColor.primarycolor,
              child: const ListTile(
                title: Text("Home Page"),
                leading: Icon(Icons.home),
                titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18),
              ),
            ),
          ),
          InkWell(
            onTap: () async{
              await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, Screens.welcomeScreen, (route) => false);
            },
            child: Card(
              color: AddColor.primarycolor,
              child: const ListTile(
                title: Text("Log Out"),
                leading: Icon(Icons.exit_to_app_rounded),
                titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
