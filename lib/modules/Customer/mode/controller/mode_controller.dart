import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:milk_bazzar/utils/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModesController extends GetxController {


  RxInt i = 2.obs;

  RxBool isDark = false.obs;
  RxBool isLight = true.obs;

  RxString mySelectedMode = AppTexts.lightMode.obs;



}



