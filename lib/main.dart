import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/screens/login_screen.dart';
import 'package:Libralink/screens/home_page.dart';
import 'package:Libralink/screens/reg_screen.dart';
import 'package:Libralink/screens/reservation_details.dart';
import 'package:Libralink/screens/reservation_screen.dart';
import 'package:Libralink/screens/user_information_screen.dart';
import 'package:Libralink/screens/welcome_screen.dart';
import 'package:Libralink/util/img_fonts_clr.dart';
import 'package:Libralink/util/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyD3Cn11PEhhOL0_ITGS7jKNNtLdlhjYctw',
            appId: '1:740579927701:android:103466679258fc2bb2dd9c',
            messagingSenderId: '740579927701',
            projectId: 'progect2-762f1',
          ),
        )
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // getToken() async {
  //   String? mytoken = await FirebaseMessaging.instance.getToken();
  //   print("++++++++++++++++++++++++++++++");
  //   print(mytoken);
  // }

  

  @override
  void initState() {
    // myRequestPermission();
    // getToken();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('=================User is currently signed out!');
      } else {
        print('====================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: ('inter'),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: AddColor.backgrounAppBar,
            shadowColor: AddColor.shaddowAppBar,
            elevation: 3,
            centerTitle: true,
          )
          
          ),
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? const HomePageScreen()
          : const WelcomeScreen(),
      routes: {
        Screens.welcomeScreen: (context) => const WelcomeScreen(),
        Screens.signUpScreen: (context) => const SignUpScreen(),
        Screens.logInScreen: (context) => const LoginScreen(),
        Screens.homePageScreen: (context) => const HomePageScreen(),
        Screens.userInfoScreen: (context) => const UserInfoScreen(),
        Screens.reservationScreen: (context) => const ReservationScreen(),
        Screens.reservationDetailsScreen: (context) =>
            const ReservationDetailsScreen(),
      },
    );
  }
}
