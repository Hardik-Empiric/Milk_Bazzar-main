import 'package:flutter/material.dart';

class GlobalText extends StatelessWidget {
  String text;
  double? fontSize;
  Color? color;
  dynamic fontWeight;
  Function()? onTap;
  TextAlign? textAlign;
  GlobalText(
      {Key? key,
        required this.text,
        this.fontSize,
        this.color,
        this.fontWeight,
        this.onTap,
        this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: 'MPLUS1',
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
