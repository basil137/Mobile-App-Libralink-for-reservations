import 'package:flutter/material.dart';
import 'package:Libralink/screens/edit_info_screen.dart';
import 'package:Libralink/util/img_fonts_clr.dart';

class CardUserInfo extends StatelessWidget {
  const CardUserInfo({
    super.key,
    required this.leadText,
    required this.titleText,
    this.ontap,
    required this.keyBoardType,
    this.validator, required this.colorEdit,
  });

  final String leadText;
  final String titleText;
  final void Function()? ontap;
  final String? Function(String?)? validator;
  final Color colorEdit;

  final TextInputType keyBoardType;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AddColor.primarycolor,
      child: ListTile(
        title: Text(titleText),
        leading: Text("$leadText:"),
        leadingAndTrailingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 12),
        trailing: InkWell(
          onTap: () {
            if(leadText!="Email")
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
                color: colorEdit,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
