import 'package:flutter/material.dart';
import 'package:project2/util/img_fonts_clr.dart';
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
      drawer: Drawer(
        // width: 275,
        child: ContainerOfDrawer(
          userId: widget.userId,
          userName: widget.userName,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Center(
              child: DropdownMenu(
                  inputDecorationTheme: const InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.black),
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
                    DropdownMenuEntry(value: Text("0"), label: "Ground Floor"),
                    DropdownMenuEntry(value: Text("1"), label: "1st Floor"),
                    DropdownMenuEntry(value: Text("2"), label: "2nd Floor"),
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
          ],
        ),
      ),
    );
  }
}
