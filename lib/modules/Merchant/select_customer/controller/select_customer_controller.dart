import 'package:get/get.dart';

import '../../../Customer/language/controller/LacaleString.dart';

int currentY = DateTime.now().year;
int previousY = DateTime.now().year - 1;

class SelectCustomerController extends GetxController {

RxString selectedValue = rxmonthItems[DateTime.now().month - 1];


  RxInt index = 0.obs;

  RxBool isChecked = false.obs;

  RxString month = RxmonthItemsInENGLISH[DateTime.now().month - 1];

  RxInt currentYear = currentY.obs;
  RxInt previousYear = previousY.obs;

  RxBool isCurrentSelected = true.obs;
  RxBool isPreviousSelected = false.obs;

  RxString customerName = ''.obs;
  RxString customerUID = ''.obs;

}

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




final List<String> yearItems = [];

class DATA {

  String year;
  String month;
  var uid;

  DATA({
    required this.month,
    required this.year,
    required this.uid,
});

}

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
