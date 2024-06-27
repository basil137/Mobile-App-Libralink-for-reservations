

import 'package:Libralink/preference/preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Libralink/util/img_fonts_clr.dart';
import 'package:Libralink/util/parameters.dart';
import 'package:Libralink/util/screens.dart';
import 'package:Libralink/widgets/container_dialog.dart';
import 'package:Libralink/widgets/drawer.dart';

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
  String? selectedDayTable;

  int? dateDay;
  int? dateMonth;
  int? dateyear;

  int today = ((DateTime.now().weekday + 2) % 7);

  String? selectedTimeTo;
  String? selectedIdTable;
  String? uid;

  bool loadingGetTables = false;

  bool loadingReserveTable = false;

  bool timeValid = true;
  bool maxTime = true;

  List tablesAll = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int minuteFormat(String min) {
    if (min == "5")
      return 30;
    else
      return 0;
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

 


  void filterMapField() async {
    loadingGetTables = true;
    setState(() {});
    QuerySnapshot querySnapshotFiltterTables = await FirebaseFirestore.instance
        .collection("floor $selectedFloor")
        .where(ParametersFloor.sizeTable, isEqualTo: selectedSize)
        .where(ParametersFloor.availablity, isEqualTo: true)
        .get();


   

    tablesAll.clear();

    print(
        "===================================number Tables=${querySnapshotFiltterTables.docs.length}");

    for (int i = 0; i < querySnapshotFiltterTables.docs.length; i++) {
      print("======================================in big loop $i");
      QuerySnapshot<Map> querySnapshotTime = await FirebaseFirestore.instance
          .collection("floor $selectedFloor")
          .doc(querySnapshotFiltterTables.docs[i].id)
          .collection(ParametersFloor.timeTable)
          .where(ParametersFloor.dayTable, isEqualTo: selectedDayTable)
          .get();

      double selectedTimeFromINT = double.parse(selectedTimeFrom.toString());
      double selectedTimeToINT = double.parse(selectedTimeTo.toString());

      if (querySnapshotTime.docs.length != 0) {
        for (double j = selectedTimeFromINT;
            j < selectedTimeToINT;
            j = j + 0.5) {
          print("=======================================in small loop $j");

          if (j >= 10) {
            if (querySnapshotTime.docs[0]
                    .data()[j.toString().replaceRange(2, 3, ",")] ==
                false) {
              // tablesAll.remove(querySnapshotFiltterTables.docs[i]);
              print("number of tables all after false=${tablesAll.length}");
              break;
            }
          }

          if (j < 10) {
            if (querySnapshotTime.docs[0]
                    .data()[j.toString().replaceRange(1, 2, ",")] ==
                false) {
              // tablesAll.remove(querySnapshotFiltterTables.docs[i]);
              print("number of tables all after false=${tablesAll.length}");
              break;
            }
          }

          if (j == selectedTimeToINT - 0.5) {
            tablesAll.add(querySnapshotFiltterTables.docs[i]);
            print("number of tables all after add =${tablesAll.length}");
          }

          print(
              "======================================${querySnapshotTime.docs[0].data()[j.toString()]}");
        }
      }

    } //big loop for all tables match size and floor

    loadingGetTables = false;
    setState(() {});
  }

  editAvailablityTable() async {
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

    for (double i = selectedTimeFromINT; i < selectedTimeToINT; i = i + 0.5) {
      print("==============================i===$i");
      await collectionTimeTable.doc(querySnapshot.docs[0].id).update({
        if (i >= 10) i.toString().replaceRange(2, 3, ","): false,
        if (i < 10) i.toString().replaceRange(1, 2, ","): false,
      });
    }

    print("===================================update add reservation is done");
  }

  addReservationTable() async {
    QuerySnapshot querySnapshotCurrentUser = await FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .where(ParametersUsers.userEmail,
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();
    print(
        "===================================number users for reservation=${querySnapshotCurrentUser.docs.length}");
    uid = querySnapshotCurrentUser.docs[0].id;
    CollectionReference collectionReservationTable = FirebaseFirestore.instance
        .collection(ParametersUsers.nameCollection)
        .doc(uid)
        .collection(ParametersUsers.reservationTable);
    try {
      await collectionReservationTable.add(
        {
          ParametersReservationTable.sizeTableReserve: selectedSize,
          ParametersReservationTable.floorTableReserve: selectedFloor,
          ParametersReservationTable.timeFrom: selectedTimeFrom,
          ParametersReservationTable.timeTo: selectedTimeTo,
          ParametersReservationTable.idTableReserve: selectedIdTable,
          ParametersReservationTable.dayTableReservation: selectedDayTable,
          ParametersReservationTable.dateDay: dateDay,
          ParametersReservationTable.datemonth: dateMonth,
          ParametersReservationTable.dateyear: dateyear,
        },
      );

      print("++++++++++++++++++++++++++++++++++++++++++++++ttable added");
    } catch (e) {
      print(e);
    }
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
                              value: Text("0"), label: "Floor 0"),
                          DropdownMenuEntry(
                              value: Text("1"), label: "Floor 1"),
                          DropdownMenuEntry(
                              value: Text("2"), label: "Floor 2"),
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
                      hintText: "Table Size",
                      onSelected: (value) {
                        setState(() {
                          selectedSize = value!.data;
                        });
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                            value: Text("S"), label: "Small (Computer)"),
                        DropdownMenuEntry(
                            value: Text("M"), label: "Medium (3-4 students)"),
                        DropdownMenuEntry(
                            value: Text("L"), label: "Large (5-6 students)"),
                      ]),
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
                      hintText: "Day",

                      onSelected: (value) {
                        setState(() {
                          selectedDayTable = value!.data;
                        });
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                            value: Text("2"),
                            label: "Sunday",
                            enabled: today > 2 ? false : true),
                        DropdownMenuEntry(
                            value: Text("3"),
                            label: "Monday",
                            enabled: today > 3 ? false : true),
                        DropdownMenuEntry(
                            value: Text("4"),
                            label: "Tuesday",
                            enabled: today > 4 ? false : true),
                        DropdownMenuEntry(
                            value: Text("5"),
                            label: "Wednesday",
                            enabled: today > 5 ? false : true),
                        DropdownMenuEntry(
                            value: Text("6"),
                            label: "Thursday",
                            enabled: today > 6 ? false : true),
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
                                value: Text("9.0"), label: "9:00 AM"),
                            DropdownMenuEntry(
                                value: Text("9.5"), label: "9:30 AM"),
                            DropdownMenuEntry(
                                value: Text("10.0"), label: "10:00 AM"),
                            DropdownMenuEntry(
                                value: Text("10.5"), label: "10:30 AM"),
                            DropdownMenuEntry(
                                value: Text("11.0"), label: "11:00 AM"),
                            DropdownMenuEntry(
                                value: Text("11.5"), label: "11:30 AM"),
                            DropdownMenuEntry(
                                value: Text("12.0"), label: "12:00 PM"),
                            DropdownMenuEntry(
                                value: Text("12.5"), label: "12:30 PM"),
                            DropdownMenuEntry(
                                value: Text("13.0"), label: "1:00 PM"),
                            DropdownMenuEntry(
                                value: Text("13.5"), label: "1:30 PM"),
                            DropdownMenuEntry(
                                value: Text("14.0"), label: "2:00 PM"),
                            DropdownMenuEntry(
                                value: Text("14.5"), label: "2:30 PM"),
                            DropdownMenuEntry(
                                value: Text("15.0"), label: "3:00 PM"),
                            DropdownMenuEntry(
                                value: Text("15.5"), label: "3:30 PM"),
                            /////////
                            // DropdownMenuEntry(
                            //     value: Text("0.5"), label: "12:30 AM"),
                            // DropdownMenuEntry(
                            //     value: Text("1.0"), label: "1:00 AM"),
                            // DropdownMenuEntry(
                            //     value: Text("16.0"), label: "4:00 PM"),
                            /////////
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
                        hintText: "To",
                        onSelected: (value) {
                          setState(() {
                            selectedTimeTo = value!.data;
                          });
                        },
                        enabled: selectedTimeFrom == null ? false : true,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(
                              value: Text("9.0"), label: "9:00 AM"),
                          DropdownMenuEntry(
                              value: Text("9.5"), label: "9:30 AM"),
                          DropdownMenuEntry(
                              value: Text("10.0"), label: "10:00 AM"),
                          DropdownMenuEntry(
                              value: Text("10.5"), label: "10:30 AM"),
                          DropdownMenuEntry(
                              value: Text("11.0"), label: "11:00 AM"),
                          DropdownMenuEntry(
                              value: Text("11.5"), label: "11:30 AM"),
                          DropdownMenuEntry(
                              value: Text("12.0"), label: "12:00 PM"),
                          DropdownMenuEntry(
                              value: Text("12.5"), label: "12:30 PM"),
                          DropdownMenuEntry(
                              value: Text("13.0"), label: "1:00 PM"),
                          DropdownMenuEntry(
                              value: Text("13.5"), label: "1:30 PM"),
                          DropdownMenuEntry(
                              value: Text("14.0"), label: "2:00 PM"),
                          DropdownMenuEntry(
                              value: Text("14.5"), label: "2:30 PM"),
                          DropdownMenuEntry(
                              value: Text("15.0"), label: "3:00 PM"),
                          DropdownMenuEntry(
                              value: Text("15.5"), label: "3:30 PM"),
                          DropdownMenuEntry(
                              value: Text("16.0"), label: "4:00 PM"),
                          /////////
                          ///
                          // DropdownMenuEntry(
                          //     value: Text("16.5"), label: "4:30 PM"),
                          // DropdownMenuEntry(
                          //     value: Text("1.0"), label: "1:00 AM"),
                          // DropdownMenuEntry(
                          //     value: Text("1.5"), label: "1:30 AM"),
                          /////////
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      InkWell(
                        onTap: () async {
                     

                          if (selectedTimeFrom != null &&
                              selectedTimeTo != null &&
                              selectedDayTable != null) {
                            if (double.parse(selectedTimeTo!) <=
                                double.parse(selectedTimeFrom!)) {
                              timeValid = false;
                              setState(() {});
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.scale,
                                title: "Invalid Time",
                                desc: 'Please make sure you choose the time correctly!',
                                
                                btnCancel: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: ContainerOfDialog(
                                    widthContainer: 100,
                                    text: "Ok",
                                  ),
                                ),
                              ).show();
                            } else if (double.parse(selectedTimeTo!) -
                                    double.parse(selectedTimeFrom!) >
                                3) {
                              setState(() {
                                maxTime = false;
                              });
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.scale,
                                title: "Invalid time period ",
                                desc: "You can't make a reservation for mor than 3 hours",
                                
                                btnCancel: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: ContainerOfDialog(
                                    widthContainer: 100,
                                    text: "Ok",
                                  ),
                                ),
                              ).show();
                            } else {
                              filterMapField();
                              maxTime = true;
                              timeValid = true;
                              setState(() {});
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 120,
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
                      SizedBox(
                        width: 50,
                      ),
                    ],
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
                          "Invalid time",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                          textAlign: TextAlign.center,
                        ))
                  else if (!maxTime)
                    Container(
                        padding: const EdgeInsets.only(top: 24),
                        child: const Text(
                          "No Available Tables Found",
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
                              "No Available Tables Found",
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
                                        selectedIdTable = tablesAll[i]
                                            [ParametersFloor.idTable];

                                        loadingReserveTable = true;
                                        int today =
                                            ((DateTime.now().weekday + 2) % 7);

                                        var date;

                                        if (convertToInt(selectedDayTable!) >=
                                            today) {
                                          date = DateTime.now().add(Duration(
                                              days: convertToInt(
                                                      selectedDayTable!) -
                                                  today));
                                        } else {
                                          date = DateTime.now().add(Duration(
                                              days: convertToInt(
                                                      selectedDayTable!) +
                                                  7 -
                                                  today));
                                        }

                                        dateDay = date.day;
                                        dateMonth = date.month;
                                        dateyear = date.year;

                                     

                                        SetPref.setprefDate(
                                            dateDay!, dateMonth!, dateyear!);

                                        SetPref.setprefInfoReserve(
                                            selectedIdTable!,
                                            selectedSize!,
                                            selectedFloor!,
                                            selectedTimeFrom!,
                                            selectedTimeTo!,
                                            selectedDayTable!);
                                        if (double.parse(selectedTimeFrom!) <
                                            10) {
                                          SetPref.setprefTimeFrom(
                                              int.parse(selectedTimeFrom!
                                                  .substring(0, 1)),
                                              minuteFormat(selectedTimeFrom!
                                                  .substring(2, 3)));
                                        } else {
                                          SetPref.setprefTimeFrom(
                                              int.parse(selectedTimeFrom!
                                                  .substring(0, 2)),
                                              minuteFormat(selectedTimeFrom!
                                                  .substring(3, 4)));
                                        }

                                        if (double.parse(selectedTimeTo!) <
                                            10) {
                                          SetPref.setprefTimeTo(
                                              int.parse(selectedTimeTo!
                                                  .substring(0, 1)),
                                              minuteFormat(selectedTimeTo!
                                                  .substring(2, 3)));
                                        } else {
                                          SetPref.setprefTimeTo(
                                              int.parse(selectedTimeTo!
                                                  .substring(0, 2)),
                                              minuteFormat(selectedTimeTo!
                                                  .substring(3, 4)));
                                        }
                                        setState(() {});
                                        addReservationTable();
                                        editAvailablityTable();

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
                                        "Reservation has been added",
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
                                        setState(() {
                                          loadingReserveTable = false;
                                        });
                                      },
                                      child: const ContainerOfDialog(
                                        text: "Yes",
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
                                child: Card(
                                  color: AddColor.primarycolor,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    // enabled: false,
                                    leading: Text(
                                        "Table Id:${tablesAll[i][ParametersFloor.idTable]}"),
                                    title: Text("Floor #$selectedFloor"),
                                    subtitle: Text(
                                        "Size->${tablesAll[i][ParametersFloor.sizeTable]}"),
                                    // trailing: Text(
                                    //     "Day:${dayFormat(selectedDayTable!)}"),
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
