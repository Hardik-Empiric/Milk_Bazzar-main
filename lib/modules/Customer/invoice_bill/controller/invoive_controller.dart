import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../language/controller/LacaleString.dart';

int currentY = DateTime.now().year;
int previousY = DateTime.now().year - 1;

int index = DateTime.now().month;

class InvoiceController extends GetxController {

  RxString selectedValue = rxmonthItems[DateTime.now().month - 1];

  RxBool isChecked = false.obs;

  RxString month = RxmonthItemsInENGLISH[DateTime.now().month - 1];
  RxInt currentYear = currentY.obs;
  RxInt previousYear = previousY.obs;

  RxBool isCurrentSelected = true.obs;
  RxBool isPreviousSelected = false.obs;
}

final List<String> monthItems = [
  LocaleString().jan.tr,
  LocaleString().feb.tr,
  LocaleString().mar.tr,
  LocaleString().apr.tr,
  LocaleString().may.tr,
  LocaleString().jun.tr,
  LocaleString().jul.tr,
  LocaleString().aug.tr,
  LocaleString().sep.tr,
  LocaleString().oct.tr,
  LocaleString().nov.tr,
  LocaleString().dec.tr,
];

final List<RxString> rxmonthItems = [
  LocaleString().jan.tr.obs,
  LocaleString().feb.tr.obs,
  LocaleString().mar.tr.obs,
  LocaleString().apr.tr.obs,
  LocaleString().may.tr.obs,
  LocaleString().jun.tr.obs,
  LocaleString().jul.tr.obs,
  LocaleString().aug.tr.obs,
  LocaleString().sep.tr.obs,
  LocaleString().oct.tr.obs,
  LocaleString().nov.tr.obs,
  LocaleString().dec.tr.obs,
];

final List<String> monthItemsInENGLISH = [
  "january",
  "february",
  "march",
  "april",
  "may",
  "june",
  "july",
  "august",
  "september",
  "october",
  "november",
  "december",
];



final List<RxString> RxmonthItemsInENGLISH = [
  "january".obs,
  "february".obs,
  "march".obs,
  "april".obs,
  "may".obs,
  "june".obs,
  "july".obs,
  "august".obs,
  "september".obs,
  "october".obs,
  "november".obs,
  "december".obs,
];

final List<String> yearItems = [];

class YearMonth {
  String year;
  String month;

  YearMonth({
    required this.year,
    required this.month,
  });
}
