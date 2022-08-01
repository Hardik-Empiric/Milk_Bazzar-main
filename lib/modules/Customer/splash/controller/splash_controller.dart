import 'dart:async';
import 'dart:ui';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:milk_bazzar/modules/Merchant/home/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/screens/login_screen.dart';
import '../../welcome_screen/screens/welcome_screen.dart';

class SplashController extends GetxController{

  Future<void> changePage() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();


    (prefs.getBool("Gujarati") == true)
        ? Get.updateLocale(const Locale('gu', 'IN'))
        : (prefs.getBool("Hindi") == true)
        ? Get.updateLocale(const Locale('hi', 'IN'))
        : Get.updateLocale(const Locale('en', 'US'));

    Timer(const Duration(seconds: 2), () {
      prefs.getBool("Login")??false ? Get.offAll(const HomeScreen()) : Get.offAll(const LoginScreen());
    });

  }

}