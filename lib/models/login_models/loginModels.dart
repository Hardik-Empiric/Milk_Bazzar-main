import 'package:flutter/cupertino.dart';

class LoginModels {

  static String name = '';
  static int? phone;
  static String? address;
  static String imagePath = '';
  static bool? isChecked;
  static bool? yearChecked;
  static int? otp;
  static String? vid;

  static TextEditingController pinPutController = TextEditingController();
  static FocusNode pinPutFocusNode = FocusNode();

  static String? verificationId;
  static int? resendToken;


}