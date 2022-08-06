import 'dart:async';
import 'dart:ui';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/login_models/loginModels.dart';
import '../../../../routes/app_routes.dart';
import '../../login/screens/login_screen.dart';

class SplashController extends GetxController {
  Future<void> changePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    (prefs.getBool("Gujarati") == true)
        ? Get.updateLocale(const Locale('gu', 'IN'))
        : (prefs.getBool("Hindi") == true)
            ? Get.updateLocale(const Locale('hi', 'IN'))
            : Get.updateLocale(const Locale('en', 'US'));

    Timer(const Duration(seconds: 2), () {
      print(LoginModels.phone);
      prefs.getBool("Login") ?? false
          ? (LoginModels.phone == 8460711716)
              ? Get.offAllNamed(AppRoutes.home)
              : Get.offAllNamed(AppRoutes.home)
          : Get.offAll(const LoginScreen());
    });
  }
}
