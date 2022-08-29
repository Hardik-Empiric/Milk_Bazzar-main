import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:milk_bazzar/modules/Customer/language/controller/LacaleString.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/login_models/loginModels.dart';
import '../../../../routes/app_routes.dart';
import '../../login/screens/login_screen.dart';

class SplashController extends GetxController {
  Future<void> changePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // var name = await FirebaseFirestore.instance
    //     .collection('customers')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get();


    (prefs.getBool("Gujarati") == true)
        ? Get.updateLocale(const Locale('gu', 'IN'))
        : (prefs.getBool("Hindi") == true)
            ? Get.updateLocale(const Locale('hi', 'IN'))
            : Get.updateLocale(const Locale('en', 'US'));

    List mer = [];

    var merchants =
        await FirebaseFirestore.instance.collection('merchants').get();

    merchants.docs.forEach((element) {
      mer.add(element.id.toString());
    });


    int hour = DateTime.now().hour;
    print("hour : ${DateTime.now().hour}");

    var wish;

    if(hour > 4 && hour < 12)
      {
        wish = LocaleString().goodMorning.tr;
      }
    else if(hour >= 12 && hour < 17)
      {
        wish = LocaleString().goodAfternoon.tr;
      }
    else if(hour >= 17 && hour < 22)
      {
        wish = LocaleString().goodEvening.tr;
      }
    else
      {
        wish = LocaleString().goodNight.tr;
      }

    print(wish);

    Timer(const Duration(seconds: 2), () {
      print(LoginModels.phone);
      prefs.getBool("Login") ?? false
          ? (mer.contains(FirebaseAuth.instance.currentUser!.uid.toString()))
              ? Get.offAllNamed(AppRoutes.home)
              : Get.offAllNamed(AppRoutes.welcome,arguments: wish)
          : Get.offAll(const LoginScreen());
    });
  }
}
