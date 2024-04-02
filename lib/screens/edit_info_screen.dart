import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({
    super.key,
    required this.lableText,
    required this.keyBoardType,
    required this.oldText,
    this.validator,
    this.ontap,
  });

  final String lableText;
  final TextInputType keyBoardType;
  final String oldText;

  final String? Function(String?)? validator;
  final void Function()? ontap;

  // final TextEditingController customController;

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  GlobalKey<FormState> keyform = GlobalKey();
  TextEditingController customController = TextEditingController();
  @override
  void initState() {
    customController.text = widget.oldText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: keyform,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: TextFormField(
                keyboardType: widget.keyBoardType,
                controller: customController,
                autovalidateMode: AutovalidateMode.always,
                validator: widget.validator,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                  label: const Text(
                    "lableText",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (keyform.currentState!.validate()) {
                  await users
                      .doc()
                      .update({"userName": customController.text});
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
                  'Save',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
