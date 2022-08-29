import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../Customer/language/controller/LacaleString.dart';

int currentY = DateTime.now().year;
int previousY = DateTime.now().year - 1;

class SellMilkController extends GetxController {

  RxString selectedValue = LocaleString().jan.tr.obs;

  RxBool isChecked = false.obs;

  RxString month = 'January'.obs;
  RxString morningSession = 'Morning'.obs;
  RxString eveningSession = 'Evening'.obs;



  RxBool isMorningSelected = true.obs;
  RxBool isEveningSelected = false.obs;

  RxDouble liter = 0.5.obs;

  Rx<String> duration = "07:00 AM".obs;

  RxString customerName = ''.obs;


}

class AddMilk {

  String date;
  String month;
  String year;
  String time;
  String customerName;
  String session;
  String liter;

  AddMilk({
    required this.date,
    required this.month,
    required this.year,
    required this.time,
    required this.customerName,
    required this.session,
    required this.liter,

});

}


List<AddMilk> addMilks = <AddMilk>[



];