import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:milk_bazzar/modules/Merchant/customer_list/screens/customer_list_screen.dart';
import '../../../Customer/settings/screens/settings_screen.dart';
import '../../select_customer/screens/select_customer_screen.dart';
import '../../sell_milk/screens/sell_milk_screen.dart';

class HomeController extends GetxController {

    RxInt index = 0.obs;




}

List pages = [
  CustomerListScreen(),
  SelectCustomerScreen(),
  Center(child: Text('3rd Page'),),
  SellMilkScreen(),
  SettingsScreen(),
];

