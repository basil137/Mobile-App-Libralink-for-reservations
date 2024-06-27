// ignore_for_file: avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/screens/scan_qr_screen.dart';

import 'package:Libralink/util/img_fonts_clr.dart';
import 'package:Libralink/util/parameters.dart';
import 'package:Libralink/util/screens.dart';
import 'package:Libralink/widgets/container_dialog.dart';
import 'package:Libralink/widgets/primery_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen({super.key});

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  List tablesAll = [];

  String? selectedSize;
  String? selectedFloor;
  String? selectedTimeFrom;
  String? selectedTimeTo;
  String? selectedIdTable;
  String? selectedDayTable;

  int? dateDay;
  int? dateMonth;
  int? dateyear;

  String? uid;

  bool cheackIn = false;

  bool loadingGetDetailsPage = true;

  bool timeToScan = false;

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

  dayFormat(String day) {
    if (day == "0")
      return "Friday";
    else if (day == "1")
      return "Saturday";
    else if (day == "2")
      return "Sunday";
    else if (day == "3")
      return "Monday";
    else if (day == "4")
      return "Tuesday";
    else if (day == "5")
      return "Wednesday";
    else if (day == "6") return "Thursday";
  }

  String TimeFormating(String? time) {
    if (time == "8.5") {
      return "8:30 AM";
    } else if (time == "9.0") {
      return "9:00 AM";
    } else if (time == "9.5") {
      return "9:30 AM";
    } else if (time == "10.0") {
      return "10:00 AM";
    } else if (time == "10.5") {
      return "10:30 AM";
    } else if (time == "11.0") {
      return "11:00 AM";
    } else if (time == "11.5") {
      return "11:30 AM";
    } else if (time == "12.0") {
      return "12:00 PM";
    } else if (time == "12.5") {
      return "12:30 PM";
    } else if (time == "13.0") {
      return "1:00 PM";
    } else if (time == "13.5") {
      return "1:30 PM";
    } else if (time == "14.0") {
      return "2:00 PM";
    } else if (time == "14.5") {
      return "2:30 PM";
    } else if (time == "15.0") {
      return "3:00 PM";
    } else if (time == "15.5") {
      return "3:30 PM";
    } else if (time == "16.0") {
      return "4:00 PM";
    } else if (time == "0.5") {
      return "12:30 AM";
    } else if (time == "1.0") {
      return "1:00 AM";
    } else if (time == "1.5") {
      return "1:30 AM";
    } else if (time == "16.5") {
      return "4:30 PM";
    }
    return "null";
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
    if (querySnapshotUserBook.docs.length != 0) {
      await collectionReservationTable
          .doc(querySnapshotUserBook.docs[0].id)
          .delete();
    }

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
    if (querySnapshotWantedTableId.docs.length != 0) {
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

      for (double i = selectedTimeFromINT; i < selectedTimeToINT; i = i + 0.5) {
        print("==============================i===$i");
        await collectionTimeTable.doc(querySnapshot.docs[0].id).update({
          if (i >= 10) i.toString().replaceRange(2, 3, ","): true,
          if (i < 10) i.toString().replaceRange(1, 2, ","): true,
        });
      }

      print(
          "===================================update delete reservation is done");
    }
  } //deletereservation////////////////

  cheakTimeToScan() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    int? hourFrom = sharedpref.getInt("hourFrom");
    int? minuteFrom = sharedpref.getInt("minuteFrom");
    int? hourTo = sharedpref.getInt("hourTo");
    int? minuteTo = sharedpref.getInt("minuteTo");

    setState(() {});

    QuerySnapshot querySnapshotUserAccount = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .where(ParametersUsers.userEmail,
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();

    if (hourFrom != null &&
        minuteFrom != null &&
        minuteTo != null &&
        hourTo != null &&
        // day != null &&
        dateDay != null &&
        dateMonth != null &&
        dateyear != null) {
      bool nowEqualdateDay = DateTime.now().day == dateDay &&
          DateTime.now().month == dateMonth &&
          DateTime.now().year == dateyear;

      bool nowLessdateDay = DateTime.now().year < dateyear! ||
          (DateTime.now().year == dateyear &&
                  DateTime.now().month < dateMonth! ||
              (DateTime.now().month == dateMonth &&
                  DateTime.now().day < dateDay!));

      bool nowGraterdateDay = DateTime.now().year > dateyear! ||
          (DateTime.now().year == dateyear &&
                  DateTime.now().month > dateMonth! ||
              (DateTime.now().month == dateMonth &&
                  DateTime.now().day > dateDay!));

      if (nowEqualdateDay &&
          TimeOfDay.now().hour == hourFrom &&
          TimeOfDay.now().minute >= minuteFrom &&
          TimeOfDay.now().minute < minuteFrom + 10) {
        print("============================in scan true");

        timeToScan = true;
        setState(() {});
      } else if (nowLessdateDay ||
          (nowEqualdateDay &&
              (TimeOfDay.now().hour < hourFrom ||
                  (TimeOfDay.now().hour == hourFrom &&
                      TimeOfDay.now().minute < minuteFrom)))) {
        print("============================in scan false");

        timeToScan = false;
        setState(() {});
      } else {
        print("============================in else time>time+10");

        if (cheackIn == false) {
          deleteReservation();
          print("============================in checkin==false & delete");

          Navigator.pushNamedAndRemoveUntil(
            context,
            Screens.homePageScreen,
            (route) => false,
          );
          return null;
        } else if (cheackIn == true &&
            (nowGraterdateDay ||
                (nowEqualdateDay &&
                    (TimeOfDay.now().hour > hourTo ||
                        (TimeOfDay.now().hour == hourTo &&
                            TimeOfDay.now().minute >= minuteTo))))) {
          print("============================in checkin==true &&....");

          deleteReservation();
          await FirebaseFirestore.instance
              .collection("users")
              .doc(querySnapshotUserAccount.docs[0].id)
              .update({
            ParametersUsers.checkIn: false,
          });
          Navigator.pushNamedAndRemoveUntil(
            context,
            Screens.homePageScreen,
            (route) => false,
          );
          return null;
        }
      }
    }

    loadingGetDetailsPage = false;
    setState(() {});
  } //cheakTimeToScan/////////////////////

  void defineCheckIn() async {
    QuerySnapshot querySnapshotUserAccount = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .where(ParametersUsers.userEmail,
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();

    if (querySnapshotUserAccount.docs[0][ParametersUsers.checkIn] == true) {
      cheackIn = true;
      setState(() {});
      print("done define check in and the bool checIn=$cheackIn");
    } else {
      print("in else and the bool checkIn=$cheackIn");
    }

    getReservationDetails();
  } //defineCheckIn///////////////////////

  getReservationDetails() async {
    QuerySnapshot querySnapshotCurrentUser = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .where(ParametersUsers.userEmail,
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();
    print(
        "===================================number users for reservation details=${querySnapshotCurrentUser.docs.length}");
    uid = querySnapshotCurrentUser.docs[0].id;

    QuerySnapshot querySnapshotUserBook = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .doc(uid)
        .collection(ParametersUsers.reservationTable)
        .get();

    setState(() {
      selectedFloor = querySnapshotUserBook.docs[0]
          [ParametersReservationTable.floorTableReserve];

      selectedSize = querySnapshotUserBook.docs[0]
          [ParametersReservationTable.sizeTableReserve];

      selectedIdTable = querySnapshotUserBook.docs[0]
          [ParametersReservationTable.idTableReserve];

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

    cheakTimeToScan();
  }

  @override
  void initState() {
    defineCheckIn();
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
      ),
      body: loadingGetDetailsPage
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                  child: Card(
                    color: AddColor.primarycolor,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Text("Table Id:$selectedIdTable"),
                      title: Text("Floor #$selectedFloor"),
                      subtitle: Text("Size->$selectedSize"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              "${dayFormat(selectedDayTable!)} $dateyear-$dateMonth-$dateDay"),
                          Text(
                              "${TimeFormating(selectedTimeFrom)} - ${TimeFormating(selectedTimeTo)}"),
                        ],
                      ),
                    ),
                  ),
                ),
                cheackIn
                    ? InkWell(
                        onTap: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.scale,
                            title: "Are you sure to check out?",
                            desc: '',
                            btnOk: InkWell(
                              onTap: () async {
                                deleteReservation();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Container(
                                      width: double.infinity,
                                      height: 20,
                                      child: Text(
                                        "you have checked out successfully",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  backgroundColor: AddColor.backgrounSnackBar,
                                ));

                                QuerySnapshot querySnapshotUserAccount =
                                    await FirebaseFirestore.instance
                                        .collection(
                                            ParametersUsers.nameCollection)
                                        .where(ParametersUsers.userEmail,
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.email
                                                .toString())
                                        .get();

                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(querySnapshotUserAccount.docs[0].id)
                                    .update({
                                  ParametersUsers.checkIn: false,
                                });
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Screens.homePageScreen,
                                  (route) => false,
                                );
                              },
                              child: const ContainerOfDialog(
                                text: "Ok",
                              ),
                            ),
                            btnCancel: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ContainerOfDialog(
                                  text: "Cancel",
                                )),
                          ).show();
                        },
                        child: PrimeryContainer(
                          textColor: Colors.red[800]!,
                          text: "Check out",
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.scale,
                            title:
                                "Are you sure you want to delete your reservation?",
                            desc: '',
                            btnOk: InkWell(
                              onTap: () async {
                                deleteReservation();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Container(
                                      width: double.infinity,
                                      height: 20,
                                      // decoration: BoxDecoration(
                                      //   gradient: const LinearGradient(colors: [
                                      //     Color(0xff9A8877),
                                      //     Color(0xffC3CFE2),
                                      //   ]),
                                      // ),
                                      child: Text(
                                        "Reservation has been deleted",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  backgroundColor: AddColor.backgrounSnackBar,
                                ));

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Screens.homePageScreen,
                                  (route) => false,
                                );
                              },
                              child: const ContainerOfDialog(
                                text: "Ok",
                              ),
                            ),
                            btnCancel: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ContainerOfDialog(
                                  text: "Cancel",
                                )),
                          ).show();
                        },
                        child: const PrimeryContainer(
                          textColor: Colors.black87,
                          text: "Cancel Reservation",
                        ),
                      ),
                const SizedBox(
                  height: 16,
                ),
                if (cheackIn == true)
                  const SizedBox()
                else
                  InkWell(
                    onTap: timeToScan
                        ? () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) =>
                                  QRCodeView(selectedIdTable: selectedIdTable),
                            ));
                          }
                        : () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.scale,
                              title: "Reservation hasn't started",
                              desc:
                                  "You can scan QR code between ${TimeFormating(selectedTimeFrom)} until ${TimeFormating(selectedTimeFrom).replaceRange(3, 4, '9')}, after that your reservation will be cancelled automatically ",
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
                      alignment: Alignment.center,
                      height: 56,
                      width: 296,
                      decoration: BoxDecoration(
                        color: !timeToScan ? Colors.grey[300] : null,
                        borderRadius: BorderRadius.circular(10),
                        gradient: timeToScan
                            ? const LinearGradient(colors: [
                                Color(0xff9A8877),
                                Color(0xffC3CFE2),
                              ])
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scan QR Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: timeToScan
                                    ? Colors.red[800]
                                    : Colors.grey[500]),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Icon(Icons.qr_code_scanner,
                              color: timeToScan
                                  ? Colors.red[800]
                                  : Colors.grey[500]),
                        ],
                      ),
                    ),
                  )
              ],
            ),
    );
  }
}
