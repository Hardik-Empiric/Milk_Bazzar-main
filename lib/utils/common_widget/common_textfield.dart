import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';

class CommonTextField extends StatelessWidget {
  int? maxLine;
  String? labelText;
  String? hintText;
  int? maxLength;
  Widget? prefix;
  Widget? suffix;
  bool? readOnly;
  Color? hintColor;
  Color? focusBorderColor;
  double? hintTextSize;
  List<TextInputFormatter>? inputFormatters;
  Function()? onTap;
  dynamic keyBoardType;
  TextEditingController? controller;
  CommonTextField({
    Key? key,
    this.controller,
    this.maxLine,
    this.labelText,
    this.hintText,
    this.prefix,
    this.suffix,
    this.onTap,
    this.maxLength,
    this.readOnly,
    this.hintColor,
    this.hintTextSize,
    this.focusBorderColor,
    this.inputFormatters,
    this.keyBoardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: controller,
        keyboardType: keyBoardType,
        maxLength: maxLength,
        onTap: onTap,
        maxLines: maxLine,
        readOnly: readOnly ?? false,
        inputFormatters: inputFormatters,
        style: const TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
            fontFamily: "Graphik"),
        decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            labelText: labelText,
            labelStyle: TextStyle(
                color: AppColors.textColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Graphik"),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide:  BorderSide(color: AppColors.blue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide:
              const BorderSide(color: AppColors.borderColor, width: 2),
            ),
            hintText: hintText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            hintStyle: TextStyle(
                color: hintColor ?? AppColors.hintTextColor,
                fontSize: hintTextSize ?? 13),
            floatingLabelBehavior: FloatingLabelBehavior.always),
      ),
    );
  }
}
