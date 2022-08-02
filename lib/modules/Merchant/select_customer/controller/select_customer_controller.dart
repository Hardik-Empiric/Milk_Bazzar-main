import 'package:get/get.dart';

import '../../../Customer/language/controller/LacaleString.dart';

int currentY = DateTime.now().year;
int previousY = DateTime.now().year - 1;

class SelectCustomerController extends GetxController {

  RxString selectedValue = LocaleString().jan.tr.obs;

  RxBool isChecked = false.obs;

  RxString month = 'January'.obs;
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




final List<String> yearItems = [];
