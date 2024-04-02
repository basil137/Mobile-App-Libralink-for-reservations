import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/preference/preferences.dart';
import 'package:project2/screens/reservation_screen.dart';
import 'package:project2/screens/user_information_screen.dart';
import 'package:project2/util/img_fonts_clr.dart';
import 'package:project2/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  bool loading = true;
  String? userName;
  String? userId;

  // List<QueryDocumentSnapshot> usersAll = [];
  void getdataAll() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').where("userEmail",isEqualTo: FirebaseAuth.instance.currentUser!.email.toString()).get();
    // usersAll.addAll(querySnapshot.docs);
    print("===================================number=${querySnapshot.docs.length}");

    SetPref.setpref(querySnapshot.docs[0].get("userName"), querySnapshot.docs[0].get("userId"));
    getpref();
    // getUserName();
    setState(() {});
  }

   void getpref() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    userName = sharedpref.getString("userName");
    userId = sharedpref.getString("userId");
    setState(() {});
  }

  // void getUserName() {
  //   print("===================================number=${usersAll.length}");
  //   for (int i = 0; i < usersAll.length; i++) {
  //     String s = usersAll[i].get("userEmail").toString();
  //     print("++++++++++++++++++++++++++++++++++++email from userAll=$s\n\n");
  //     String ss = FirebaseAuth.instance.currentUser!.email!;
  //     print("+++++++++++++++++++++++++++++++++email from firebaseAuth=$ss\n\n");
  //     if (usersAll[i].get("userEmail").toString() ==
  //         FirebaseAuth.instance.currentUser!.email!) {
  //       SetPref.setpref(usersAll[i].get("userName"), usersAll[i].get("userId"));
  //       getpref();
  //       break;
  //     }
  //   }
  // }

  @override
  void initState() {
    getdataAll();
    // Future.delayed(const Duration(seconds: 1));
    super.initState();
  }

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoScreen(
                        userId: userId,
                        userName: userName,
                      ),
                    ));
              },
              icon: const Icon(
                Icons.person_pin,
                size: 35,
              ))
        ],
      ),
      drawer: Drawer(
        // width: 275,
        child: ContainerOfDrawer(
          userId: userId,
          userName: userName,
        ),
      ),
      body: ListView(
        children: [
          // const Text("welcome"),
          // MaterialButton(
          //   color: Colors.red,
          //   textColor: Colors.white,
          //   onPressed: () async {
          //     SharedPreferences sharedpref =
          //         await SharedPreferences.getInstance();
          //     sharedpref.setString(
          //         "name", FirebaseAuth.instance.currentUser!.email!);
          //   },
          //   child: const Text("Set name"),
          // ),
          // MaterialButton(
          //   textColor: Colors.white,
          //   color: Colors.red,
          //   onPressed: () async {
          //     SharedPreferences sharedpref =
          //         await SharedPreferences.getInstance();
          //     Object? name = sharedpref.get("name");
          //     print("$name");
          //   },
          //   child: const Text("print name"),
          // ),
          // ...List.generate(
          //   usersAll.length,
          //   (index) => Card(
          //     child: ListTile(
          //       title: Text("$userName"),
          //     ),
          //   ),
          // ),

          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            alignment: Alignment.center,
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(AddImage.homePageimg, width: 500),
                const Text(
                  "Library Booking\nPlatform",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 37,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationScreen(userId: userId,userName: userName,),));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.center,
              height: 56,
              width: 296,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(colors: [
                  Color(0xff9A8877),
                  Color(0xffC3CFE2),
                ]),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
