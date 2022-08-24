import 'package:get/get.dart';

import '../../../Customer/language/controller/LacaleString.dart';

int currentY = DateTime.now().year;
int previousY = DateTime.now().year - 1;

class SelectCustomerController extends GetxController {

  RxString selectedValue = LocaleString().jan.tr.obs;

  RxInt index = 0.obs;

  RxBool isChecked = false.obs;

  RxString month = 'january'.obs;
  RxInt currentYear = currentY.obs;
  RxInt previousYear = previousY.obs;

  RxBool isCurrentSelected = true.obs;
  RxBool isPreviousSelected = false.obs;

  RxString customerName = ''.obs;
  RxString customerUID = ''.obs;

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
