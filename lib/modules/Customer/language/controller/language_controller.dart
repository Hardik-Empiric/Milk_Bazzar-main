import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LanguageController extends GetxController {


  RxInt i = 3.obs;

  RxBool isHindi = false.obs;
  RxBool isEnglish = true.obs;
  RxBool isGujarati = false.obs;

  RxString mySelectedLanguage = 'English'.obs;


}