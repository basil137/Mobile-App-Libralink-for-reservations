import 'package:flutter/material.dart';
import 'package:project2/screens/edit_info_screen.dart';
import 'package:project2/util/img_fonts_clr.dart';

class CardUserInfo extends StatelessWidget {
  const CardUserInfo({
    super.key,
    required this.leadText,
    required this.titleText,
    this.ontap,
    required this.keyBoardType,
    this.validator,
  });

  final String leadText;
  final String titleText;
  final void Function()? ontap;
  final String? Function(String?)? validator;

  final TextInputType keyBoardType;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AddColor.primarycolor,
      // margin: const EdgeInsets.symmetric(vertical: ),
      child: ListTile(
        title: Text(titleText),
        leading: Text("$leadText:"),
        leadingAndTrailingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
        trailing: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditInfoScreen(
                    lableText: leadText,
                    keyBoardType: keyBoardType,
                    oldText: titleText,
                    ontap: ontap,
                    validator: validator,
                  ),
                ));
          },
          child: Text(
            "edit",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.blue[900],
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
