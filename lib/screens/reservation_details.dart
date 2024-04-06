import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project2/util/img_fonts_clr.dart';
import 'package:project2/util/screens.dart';
import 'package:project2/widgets/container_dialog.dart';
import 'package:project2/widgets/primery_container.dart';

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

  String? uid;

  bool loadingGetDetailsPage = true;
  // bool loadingDeletereservation = false;

  deleteReservation() async {
    //######################################################
    //delete from users collection
    CollectionReference collectionReservationTable = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reservationTable");

    QuerySnapshot querySnapshotUserBook = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reservationTable")
        .get();

    print(
        "========================================number of books for user=${querySnapshotUserBook.docs.length}");

    await collectionReservationTable
        .doc(querySnapshotUserBook.docs[0].id)
        .delete();

    //###########################################################
    //switch availablity to True from floor# collection

    QuerySnapshot querySnapshotAvailableTableId =
        await FirebaseFirestore.instance
            .collection('floor $selectedFloor')
            .where(
              "idTable",
              isEqualTo: selectedIdTable,
            )
            .get();

    print(
        "===================================number tables match id=${querySnapshotAvailableTableId.docs.length}");

    await FirebaseFirestore.instance
        .collection("floor $selectedFloor")
        .doc(querySnapshotAvailableTableId.docs[0].id)
        .update({"availablity": true});
    print("===================================update is done");
  }

  getReservationDetails() async {
    QuerySnapshot querySnapshotCurrentUser = await FirebaseFirestore.instance
        .collection('users')
        .where("userEmail",
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();
    print(
        "===================================number users for reservation details=${querySnapshotCurrentUser.docs.length}");
    uid = querySnapshotCurrentUser.docs[0].id;

    QuerySnapshot querySnapshotUserBook = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reservationTable")
        .get();

    selectedFloor = querySnapshotUserBook.docs[0]["floorTable"];

    selectedSize = querySnapshotUserBook.docs[0]["size"];

    selectedIdTable = querySnapshotUserBook.docs[0]["idTable"];
    // print( "======================================================selected id table=$selectedIdTable");

    selectedTimeFrom = querySnapshotUserBook.docs[0]["timeFrom"];

    selectedTimeTo = querySnapshotUserBook.docs[0]["timeTo"];
    setState(() {});
    loadingGetDetailsPage = false;
    setState(() {});
  }

  @override
  void initState() {
    getReservationDetails();
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
                      // enabled: false,
                      leading: Text("Id Table:$selectedIdTable"),
                      title: Text("Floor #$selectedFloor"),
                      subtitle: Text("Size->$selectedSize"),
                      // trailing: const Icon(Icons.access_alarms_sharp),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.scale,
                      title: "Are you sure to delete this reservation?",
                      desc: '',
                      btnOk: InkWell(
                        onTap: () async {
                          // loadingDeletereservation = true;
                          // setState(() {});
                          deleteReservation();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Screens.homePageScreen,
                            (route) => false,
                          );
                          // loadingDeletereservation = false;
                          // setState(() {});
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
                    text: "Cancel The Reservation",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ReservationDetailsScreen()));
                  },
                  child: Container(
                    // margin:const EdgeInsets.only(right: 32, left: 32,),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scan QR Code',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red[800]),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.red[800],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
