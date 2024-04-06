import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/util/img_fonts_clr.dart';
import 'package:project2/util/screens.dart';
import 'package:project2/widgets/container_dialog.dart';
import 'package:project2/widgets/drawer.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, this.userName, this.userId});
  final String? userName;
  final String? userId;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSize;
  String? selectedFloor;
  String? selectedTimeFrom;
  String? selectedTimeTo;
  String? selectedIdTable;
  String? uid;

  bool loadingGetTables = false;

  bool loadingReserveTable = false;

  bool timeValid = true;

  List tablesAll = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  editAvailablityTable() async {
    CollectionReference collectionFloor =
        FirebaseFirestore.instance.collection('floor $selectedFloor');
        print(
        "===================================collectionFloor done");

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

    if (querySnapshotAvailableTableId.docs.isNotEmpty) {
      await collectionFloor
          .doc(querySnapshotAvailableTableId.docs[0].id)
          .update({"availablity": false});
    }
    print(
        "===================================update is done");
  }

  addReservationTable() async {
    QuerySnapshot querySnapshotCurrentUser = await FirebaseFirestore.instance
        .collection('users')
        .where("userEmail",
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();
    print(
        "===================================number users for reservation=${querySnapshotCurrentUser.docs.length}");
    uid = querySnapshotCurrentUser.docs[0].id;
    CollectionReference collectionReservationTable = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reservationTable");
    try {
      print("++++++++++++++++++++++++++++++++++++++++++++++ttable added");
      await collectionReservationTable.add(
        {
          "size": selectedSize,
          "floorTable": selectedFloor,
          "timeFrom": selectedTimeFrom,
          "timeTo": selectedTimeTo,
          "idTable": selectedIdTable,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    tablesAll.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
      drawer: Drawer(
        // width: 275,
        child: ContainerOfDrawer(
          userId: widget.userId,
          userName: widget.userName,
        ),
      ),
      body: loadingReserveTable
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: DropdownMenu(
                        inputDecorationTheme: const InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        width: MediaQuery.sizeOf(context).width * 0.99,
                        enableSearch: true,
                        hintText: "Floor number",
                        // enableFilter: true,
                        onSelected: (value) {
                          setState(() {
                            selectedFloor = value!.data;
                          });
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(
                              value: Text("0"), label: "Ground Floor"),
                          DropdownMenuEntry(
                              value: Text("1"), label: "1st Floor"),
                          DropdownMenuEntry(
                              value: Text("2"), label: "2nd Floor"),
                        ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownMenu(
                      inputDecorationTheme: const InputDecorationTheme(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
                        ),
                      ),
                      width: MediaQuery.sizeOf(context).width * 0.99,
                      enableSearch: true,
                      hintText: "Size table",
                      // enableFilter: true,
                      onSelected: (value) {
                        setState(() {
                          selectedSize = value!.data;
                        });
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                            value: Text("S"), label: "Small (Computer)"),
                        DropdownMenuEntry(
                            value: Text("M"), label: "Medium (3-4 persons)"),
                        DropdownMenuEntry(
                            value: Text("L"), label: "Large (5-6 persons)"),
                      ]),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownMenu(
                          width: MediaQuery.sizeOf(context).width * 0.49,
                          inputDecorationTheme: const InputDecorationTheme(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                            ),
                          ),
                          // width: MediaQuery.sizeOf(context).width * 0.99,
                          hintText: "From",
                          onSelected: (value) {
                            setState(() {
                              selectedTimeFrom = value!.data;
                            });
                          },
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(
                                value: Text("8.5"), label: "8:30 AM"),
                            DropdownMenuEntry(
                                value: Text("9"), label: "9:00 AM"),
                            DropdownMenuEntry(
                                value: Text("9.5"), label: "9:30 AM"),
                            DropdownMenuEntry(
                                value: Text("10"), label: "10:00 AM"),
                            DropdownMenuEntry(
                                value: Text("10.5"), label: "10:30 AM"),
                            DropdownMenuEntry(
                                value: Text("11"), label: "11:00 AM"),
                            DropdownMenuEntry(
                                value: Text("11.5"), label: "11:30 AM"),
                            DropdownMenuEntry(
                                value: Text("12"), label: "12:00 PM"),
                            DropdownMenuEntry(
                                value: Text("12.5"), label: "12:30 PM"),
                            DropdownMenuEntry(
                                value: Text("13"), label: "1:00 PM"),
                            DropdownMenuEntry(
                                value: Text("13.5"), label: "1:30 PM"),
                            DropdownMenuEntry(
                                value: Text("14"), label: "2:00 PM"),
                            DropdownMenuEntry(
                                value: Text("14.5"), label: "2:30 PM"),
                            DropdownMenuEntry(
                                value: Text("15"), label: "3:00 PM"),
                            DropdownMenuEntry(
                                value: Text("15.5"), label: "3:30 PM"),
                          ]),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.01,
                      ),
                      DropdownMenu(
                        width: MediaQuery.sizeOf(context).width * 0.49,
                        inputDecorationTheme: const InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        // width: MediaQuery.sizeOf(context).width * 0.99,
                        hintText: "To",
                        onSelected: (value) {
                          setState(() {
                            selectedTimeTo = value!.data;
                          });
                        },
                        enabled: selectedTimeFrom == null ? false : true,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: Text("9"), label: "9:00 AM"),
                          DropdownMenuEntry(
                              value: Text("9.5"), label: "9:30 AM"),
                          DropdownMenuEntry(
                              value: Text("10"), label: "10:00 AM"),
                          DropdownMenuEntry(
                              value: Text("10.5"), label: "10:30 AM"),
                          DropdownMenuEntry(
                              value: Text("11"), label: "11:00 AM"),
                          DropdownMenuEntry(
                              value: Text("11.5"), label: "11:30 AM"),
                          DropdownMenuEntry(
                              value: Text("12"), label: "12:00 PM"),
                          DropdownMenuEntry(
                              value: Text("12.5"), label: "12:30 PM"),
                          DropdownMenuEntry(
                              value: Text("13"), label: "1:00 PM"),
                          DropdownMenuEntry(
                              value: Text("13.5"), label: "1:30 PM"),
                          DropdownMenuEntry(
                              value: Text("14"), label: "2:00 PM"),
                          DropdownMenuEntry(
                              value: Text("14.5"), label: "2:30 PM"),
                          DropdownMenuEntry(
                              value: Text("15"), label: "3:00 PM"),
                          DropdownMenuEntry(
                              value: Text("15.5"), label: "3:30 PM"),
                          DropdownMenuEntry(
                              value: Text("16"), label: "4:00 PM"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () async {
                      if (selectedTimeFrom != null && selectedTimeTo != null) {
                        if (double.parse(selectedTimeTo!) <=
                            double.parse(selectedTimeFrom!)) {
                          timeValid = false;
                          setState(() {});
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.scale,
                            title: "Time Invalid",
                            desc: 'time To is erlier than time from!',
                            // btnOkOnPress: () {},
                            // btnOkColor: const Color(0xff9A8877),
                            btnCancel: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 36,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    gradient: const LinearGradient(colors: [
                                      Color(0xff9A8877),
                                      Color(0xffC3CFE2),
                                    ])),
                                child: const Text(
                                  "Ok",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ).show();
                        } else {
                          timeValid = true;
                          setState(() {});
                        }
                      }
                      loadingGetTables = true;
                      setState(() {});
                      QuerySnapshot querySnapshotFiltterTables =
                          await FirebaseFirestore.instance
                              .collection('floor $selectedFloor')
                              .where(
                                "size",
                                isEqualTo: selectedSize,
                              )
                              .where("availablity", isEqualTo: true)
                              .get();
                      print(
                          "===================================number Tables=${querySnapshotFiltterTables.docs.length}");
                      tablesAll.clear();
                      tablesAll.addAll(querySnapshotFiltterTables.docs);
                      loadingGetTables = false;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      margin: const EdgeInsets.only(right: 120, left: 120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(colors: [
                          Color(0xff9A8877),
                          Color(0xffC3CFE2),
                        ]),
                      ),
                      child: const Text(
                        'Show',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (loadingGetTables)
                    const SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (timeValid == false)
                    Container(
                        padding: const EdgeInsets.only(top: 24),
                        child: const Text(
                          "Error Time Invalid",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                          textAlign: TextAlign.center,
                        ))
                  else
                    tablesAll.isEmpty
                        ? Container(
                            padding: const EdgeInsets.only(top: 24),
                            child: const Text(
                              "Not Found Tables available",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                              textAlign: TextAlign.center,
                            ))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tablesAll.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () async {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.question,
                                    animType: AnimType.scale,
                                    title: "Do you want to reserve this table?",
                                    desc: '',
                                    btnOk: InkWell(
                                      onTap: () async {
                                        selectedIdTable =
                                            tablesAll[i]["idTable"];

                                        loadingReserveTable = true;
                                        setState(() {});
                                        addReservationTable();
                                        editAvailablityTable();
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Screens.homePageScreen,
                                          (route) => false,
                                        );
                                        setState(() {
                                          loadingReserveTable = false;
                                        });
                                      },
                                      child: const ContainerOfDialog(text: "Ok",),
                                    ),
                                    btnCancel: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const ContainerOfDialog(text: "Cancel",)
                                    ),
                                  ).show();
                                },
                                child: Card(
                                  color: AddColor.primarycolor,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    // enabled: false,
                                    leading: Text(
                                        "Id Table:${tablesAll[i]["idTable"]}"),
                                    title: Text("Floor #$selectedFloor"),
                                    subtitle:
                                        Text("Size->${tablesAll[i]["size"]}"),
                                    trailing:
                                        const Icon(Icons.access_alarms_sharp),
                                  ),
                                ),
                              );
                            },
                          )
                ],
              ),
            ),
    );
  }
}


