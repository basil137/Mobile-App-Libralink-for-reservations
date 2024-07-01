import 'package:Libralink/widgets/container_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/preference/preferences.dart';
import 'package:Libralink/screens/reservation_details.dart';
import 'package:Libralink/screens/reservation_screen.dart';
import 'package:Libralink/screens/user_information_screen.dart';
import 'package:Libralink/util/img_fonts_clr.dart';
import 'package:Libralink/util/parameters.dart';
import 'package:Libralink/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  bool loadingGetDataAndCheckAllowed = true;
  String? userName;
  String? userId;

  String? selectedSize;
  String? selectedFloor;
  String? selectedTimeFrom;
  String? selectedTimeTo;
  String? selectedIdTable;
  String? selectedDayTable;

  int? dateDay;
  int? dateMonth;
  int? dateyear;

  bool allowedBooking = false;
  String? uid;

  int minuteFormat(String min) {
    if (min == "5")
      return 30;
    else
      return 0;
  }

  convertToInt(String day) {
    if (day == "0")
      return 0;
    else if (day == "1")
      return 1;
    else if (day == "2")
      return 2;
    else if (day == "3")
      return 3;
    else if (day == "4")
      return 4;
    else if (day == "5")
      return 5;
    else if (day == "6") return 6;
  }

  myRequestPermission() async { //sultan//////////////////////
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void checkReset() async {
    CollectionReference collectionReferenceReset =
        FirebaseFirestore.instance.collection("reset");

    print("+++++++++++++++++++ in cheack reset");

    if (DateTime.now().weekday == 5 || DateTime.now().weekday == 6) {
    print("++++++++++++++++++++++++++++++++++in weekend");


      QuerySnapshot querySnapshotReset =
          await FirebaseFirestore.instance.collection("reset").get();

      bool reset = querySnapshotReset.docs[0]["reset"];

    print("++++++++++++++++++++++++++++++++++in weekend reset=$reset");


      if (reset == false) {

      print("++++++++++++++++++++++++++++++++++in weekend &&  reset == false");

        await collectionReferenceReset
            .doc(querySnapshotReset.docs[0].id)
            .update({"reset": true});

        //##################################  floor 0   ##########################

        QuerySnapshot querySnapshotAllTables0 =
            await FirebaseFirestore.instance.collection('floor 0').get();// number of tables in collection floor #

        for (int i = 0; i < querySnapshotAllTables0.docs.length; i++) { 
          QuerySnapshot querySnapshotTimeTable0 = await FirebaseFirestore
              .instance
              .collection("floor 0")
              .doc(querySnapshotAllTables0.docs[i].id)
              .collection(ParametersFloor.timeTable)
              .get();//5 days in every table time

          for (int j = 0; j < querySnapshotTimeTable0.docs.length; j++) {
            FirebaseFirestore.instance
                .collection("floor 0")
                .doc(querySnapshotAllTables0.docs[i].id)
                .collection(ParametersFloor.timeTable)
                .doc(querySnapshotTimeTable0.docs[j].id)
                .update({
              "8,5": true,
              "9,0": true,
              "9,5": true,
              "10,0": true,
              "10,5": true,
              "11,0": true,
              "11,5": true,
              "12,0": true,
              "12,5": true,
              "13,0": true,
              "13,5": true,
              "14,0": true,
              "14,5": true,
              "15,0": true,
              "15,5": true,
            });
          }
        }

        //##################################  floor 1   ##########################

        QuerySnapshot querySnapshotAllTables1 =
            await FirebaseFirestore.instance.collection('floor 1').get();

        for (int i = 0; i < querySnapshotAllTables1.docs.length; i++) {
          QuerySnapshot querySnapshotTimeTable1 = await FirebaseFirestore
              .instance
              .collection("floor 1")
              .doc(querySnapshotAllTables1.docs[i].id)
              .collection(ParametersFloor.timeTable)
              .get();

          for (int j = 0; j < querySnapshotTimeTable1.docs.length; j++) {
            FirebaseFirestore.instance
                .collection("floor 1")
                .doc(querySnapshotAllTables1.docs[i].id)
                .collection(ParametersFloor.timeTable)
                .doc(querySnapshotTimeTable1.docs[j].id)
                .update({
              "8,5": true,
              "9,0": true,
              "9,5": true,
              "10,0": true,
              "10,5": true,
              "11,0": true,
              "11,5": true,
              "12,0": true,
              "12,5": true,
              "13,0": true,
              "13,5": true,
              "14,0": true,
              "14,5": true,
              "15,0": true,
              "15,5": true,
            });
          }
        }

        // //##################################  floor 2   ##########################

        QuerySnapshot querySnapshotAllTables2 =
            await FirebaseFirestore.instance.collection('floor 2').get();

        for (int i = 0; i < querySnapshotAllTables2.docs.length; i++) {
          QuerySnapshot querySnapshotTimeTable2 = await FirebaseFirestore
              .instance
              .collection("floor 2")
              .doc(querySnapshotAllTables2.docs[i].id)
              .collection(ParametersFloor.timeTable)
              .get();

          for (int j = 0; j < querySnapshotTimeTable2.docs.length; j++) {
            FirebaseFirestore.instance
                .collection("floor 2")
                .doc(querySnapshotAllTables2.docs[i].id)
                .collection(ParametersFloor.timeTable)
                .doc(querySnapshotTimeTable2.docs[j].id)
                .update({
              "8,5": true,
              "9,0": true,
              "9,5": true,
              "10,0": true,
              "10,5": true,
              "11,0": true,
              "11,5": true,
              "12,0": true,
              "12,5": true,
              "13,0": true,
              "13,5": true,
              "14,0": true,
              "14,5": true,
              "15,0": true,
              "15,5": true,
            });
          }
        }
      }//if reset false
    } //if day weekend
    else {

    print("------------------------------------in nooooo weekend");

      QuerySnapshot querySnapshotReset =
          await FirebaseFirestore.instance.collection("reset").get();

      bool reset = querySnapshotReset.docs[0]["reset"];

      if (reset == true) {

    print("------------------------------------in nooooo weekend  &&  reset ==true");

        
        await collectionReferenceReset
            .doc(querySnapshotReset.docs[0].id)
            .update({"reset": false});
      }
    }
  }

  getReservationDetailsAndSetIntoPref() async {
    QuerySnapshot querySnapshotCurrentUser = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .where(ParametersUsers.userEmail,
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();
    print(
        "===================================number users for reservation details=${querySnapshotCurrentUser.docs.length} && the email is ${FirebaseAuth.instance.currentUser!.email.toString()}");
    uid = querySnapshotCurrentUser.docs[0].id;

    QuerySnapshot querySnapshotUserBook = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .doc(uid)
        .collection(ParametersUsers.reservationTable)
        .get();// get reservation of user if there any

    if (querySnapshotUserBook.docs.length != 0) {
      setState(() {
        selectedFloor = querySnapshotUserBook.docs[0]
            [ParametersReservationTable.floorTableReserve];

        selectedSize = querySnapshotUserBook.docs[0]
            [ParametersReservationTable.sizeTableReserve];

        selectedIdTable = querySnapshotUserBook.docs[0]
            [ParametersReservationTable.idTableReserve];
        print(
            "======================================================selected id table=$selectedIdTable");

        selectedTimeFrom =
            querySnapshotUserBook.docs[0][ParametersReservationTable.timeFrom];

        selectedTimeTo =
            querySnapshotUserBook.docs[0][ParametersReservationTable.timeTo];

        selectedDayTable = querySnapshotUserBook.docs[0]
            [ParametersReservationTable.dayTableReservation];

        dateDay =
            querySnapshotUserBook.docs[0][ParametersReservationTable.dateDay];

        dateMonth =
            querySnapshotUserBook.docs[0][ParametersReservationTable.datemonth];

        dateyear =
            querySnapshotUserBook.docs[0][ParametersReservationTable.dateyear];
      });
      print(
          "---------$selectedFloor-------------$selectedSize------$selectedIdTable------$selectedTimeFrom--------$selectedTimeTo-----------$selectedDayTable------------$dateDay--------$dateMonth-----------$dateyear");

      SetPref.setprefDate(dateDay!, dateMonth!, dateyear!);

      SetPref.setprefInfoReserve(
          selectedIdTable!,
          selectedSize!,
          selectedFloor!,
          selectedTimeFrom!,
          selectedTimeTo!,
          selectedDayTable!);

      if (double.parse(selectedTimeFrom!) < 10) {
        SetPref.setprefTimeFrom(int.parse(selectedTimeFrom!.substring(0, 1)),
            minuteFormat(selectedTimeFrom!.substring(2, 3)));//ex. set "9.5" to hour=9 ,min=5
      } else {
        SetPref.setprefTimeFrom(int.parse(selectedTimeFrom!.substring(0, 2)),
            minuteFormat(selectedTimeFrom!.substring(3, 4)));//ex. set "10.0" to hour=10 ,min=0
      }

      if (double.parse(selectedTimeTo!) < 10) {
        SetPref.setprefTimeTo(int.parse(selectedTimeTo!.substring(0, 1)),
            minuteFormat(selectedTimeTo!.substring(2, 3)));
      } else {
        SetPref.setprefTimeTo(int.parse(selectedTimeTo!.substring(0, 2)),
            minuteFormat(selectedTimeTo!.substring(3, 4)));
      }
    }
  }

  deleteReservation() async {
    //######################################################
    //delete from users collection
    CollectionReference collectionReservationTable = FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .doc(uid)
        .collection(ParametersUsers.reservationTable);

    QuerySnapshot querySnapshotUserBook = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .doc(uid)
        .collection(ParametersUsers.reservationTable)
        .get();

    print(
        "========================================number of books for user=${querySnapshotUserBook.docs.length}");

    await collectionReservationTable
        .doc(querySnapshotUserBook.docs[0].id)
        .delete();

    //###########################################################
    //switch timeVAlid to True from floor# collection.TimeAVlid collection

    QuerySnapshot querySnapshotWantedTableId = await FirebaseFirestore.instance
        .collection('floor $selectedFloor')
        .where(
          ParametersFloor.idTable,
          isEqualTo: selectedIdTable,
        )
        .get();

    print(
        "===================================number tables match id=${querySnapshotWantedTableId.docs.length}");

    CollectionReference collectionTimeTable = FirebaseFirestore.instance
        .collection('floor $selectedFloor')
        .doc(querySnapshotWantedTableId.docs[0].id)
        .collection(ParametersFloor.timeTable);
    print("===================================collectionFloor done");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('floor $selectedFloor')
        .doc(querySnapshotWantedTableId.docs[0].id)
        .collection(ParametersFloor.timeTable)
        .where(ParametersFloor.dayTable, isEqualTo: selectedDayTable)
        .get();

    double selectedTimeFromINT = double.parse(selectedTimeFrom.toString());
    double selectedTimeToINT = double.parse(selectedTimeTo.toString());

    for (double i = selectedTimeFromINT; i < selectedTimeToINT; i = i + 0.5) {//time is multpile of 0.5
      print("==============================i===$i");
      await collectionTimeTable.doc(querySnapshot.docs[0].id).update({
        if (i >= 10) i.toString().replaceRange(2, 3, ","): true,
        if (i < 10) i.toString().replaceRange(1, 2, ","): true,
      });
    }

    print(
        "===================================update delete reservation is done");
  } //deleteReservation

  void chekComeORNot() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    int? hourFrom = sharedpref.getInt("hourFrom");
    int? minuteFrom = sharedpref.getInt("minuteFrom");
    int? hourTo = sharedpref.getInt("hourTo");
    int? minuteTo = sharedpref.getInt("minuteTo");
    String? day = sharedpref.getString(ParametersFloor.dayTable);
    int today = ((DateTime.now().weekday + 2) % 7);

    print(
        "---------$hourFrom-------------$minuteFrom------$hourTo------$minuteTo--------$day");

    print("-----------------------the day =${DateTime.now().weekday}");

    QuerySnapshot querySnapshotUserAccount = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .where(ParametersUsers.userEmail,
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();

    bool cheackIn = querySnapshotUserAccount.docs[0][ParametersUsers.checkIn];

    setState(() {});

    if (hourFrom != null &&
        hourTo != null &&
        minuteFrom != null &&
        minuteTo != null &&
        day != null &&
        dateDay != null &&
        dateMonth != null &&
        dateyear != null) {
      bool nowEqualdateDay = DateTime.now().day == dateDay &&
          DateTime.now().month == dateMonth &&
          DateTime.now().year == dateyear;

    

      bool nowGraterdateDay = DateTime.now().year > dateyear! ||
          (DateTime.now().year == dateyear &&
                  DateTime.now().month > dateMonth! ||
              (DateTime.now().month == dateMonth &&
                  DateTime.now().day > dateDay!));

      if (allowedBooking == false) {
        print("============================in allowedbooking==false");

        if (nowGraterdateDay) {
          print("============================in now day >>>>>>>selectday");
          deleteReservation();
          allowedBooking = true;
          setState(() {});
        } else if (nowEqualdateDay &&
            (TimeOfDay.now().hour > hourFrom ||
                (TimeOfDay.now().hour == hourFrom &&
                    TimeOfDay.now().minute >= minuteFrom + 15))) {//If the current time exceeds the reservation time
          print("============================in now day =$today > selectday ");

          if (cheackIn == false) {// if he didn't scaned the qr code
            print("============================in checkin==false");
            deleteReservation();
            allowedBooking = true;
            setState(() {});
          } else if (cheackIn == true &&
              (TimeOfDay.now().hour > hourTo ||
                  (TimeOfDay.now().hour == hourTo &&
                      TimeOfDay.now().minute >= minuteTo))) {//if he does scaned the qr code and exceeds the time to(end of reservation) 
            print("============================in checkin==true &&....");

            deleteReservation();
            await FirebaseFirestore.instance
                .collection("users")
                .doc(querySnapshotUserAccount.docs[0].id)
                .update({
              ParametersUsers.checkIn: false,
            });
            allowedBooking = true;
            setState(() {});
          }
        }
      }
    }

    loadingGetDataAndCheckAllowed = false;
    setState(() {});
  } //

  void checkAllowed() async {//allowed to reserve ... only one reserve allowed
    QuerySnapshot querySnapshotReservationTables = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .collection(ParametersUsers.reservationTable)
        .get();

    if (querySnapshotReservationTables.docs.isEmpty) {
      allowedBooking = true;
      setState(() {});
      print("+++++++++++++++++++++++++++++++++++++++++++ allowed to book");
      print(
          "===================================number books=${querySnapshotReservationTables.docs.length}");
    } else {
      allowedBooking = false;
      setState(() {});
      print(
          "+++++++++++++++++++++++++++++++++++++++++++ notttttt allowed to book");
    }

    chekComeORNot();
  }

  void getdataOfUser() async {
    getReservationDetailsAndSetIntoPref();
    QuerySnapshot querySnapshotUserAccount = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .where(ParametersUsers.userEmail,
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();
    print(
        "===================================number users=${querySnapshotUserAccount.docs.length} &&  the email is ${FirebaseAuth.instance.currentUser!.email.toString()}");
    uid = querySnapshotUserAccount.docs[0].id;

    SetPref.setprefUser(
        querySnapshotUserAccount.docs[0].get(ParametersUsers.userName),
        querySnapshotUserAccount.docs[0].get(ParametersUsers.userId));

    SetPref.setprefUser(
        querySnapshotUserAccount.docs[0].get(ParametersUsers.userName),
        querySnapshotUserAccount.docs[0].get(ParametersUsers.userId));
    getprefUser();

    setState(() {});
    checkAllowed();
  }

  void getprefUser() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    userName = sharedpref.getString("userName");
    userId = sharedpref.getString("userId");
    setState(() {});
  }

  @override
  void initState() {
    
    getdataOfUser();
    myRequestPermission();
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
      body: loadingGetDataAndCheckAllowed
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
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
                  onTap: allowedBooking
                      ? () {
                        checkReset();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservationScreen(
                                  userId: userId,
                                  userName: userName,
                                ),
                              ));
                        }
                      : () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.scale,
                            title: "Warning!",
                            desc:
                                "you are not allowed to reserve more than one table",
                            btnOk: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: const ContainerOfDialog(
                                text: "Ok",
                                widthContainer: 100,
                              ),
                            ),
                          ).show();
                        },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    alignment: Alignment.center,
                    height: 56,
                    width: 296,
                    decoration: BoxDecoration(
                      color: !allowedBooking ? Colors.grey[300] : null,
                      borderRadius: BorderRadius.circular(10),
                      gradient: allowedBooking
                          ? const LinearGradient(colors: [
                              Color(0xff9A8877),
                              Color(0xffC3CFE2),
                            ])
                          : null,
                    ),
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: allowedBooking
                              ? Colors.black87
                              : Colors.grey[500]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                allowedBooking
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ReservationDetailsScreen()));
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
                            'Reservation Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black87),
                          ),
                        ),
                      )
              ],
            ),
    );
  }
}
