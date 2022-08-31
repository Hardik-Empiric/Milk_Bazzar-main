import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

var date = DateTime.now();

var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
var CMTD = firstDayNextMonth.difference(firstDayThisMonth).inDays;

class GenerateBillController extends GetxController {

  RxInt currentMonthsTotalDays = CMTD.obs;

  RxBool isLoading = true.obs;

  RxString customerName  = ''.obs;

}

class BillDetails {
  String date;
  String morning;
  String evening;
  double PPL;

  BillDetails({
    required this.date,
    required this.morning,
    required this.evening,
    required this.PPL,
  });
}



List<BillDetails> billDetails1 = <BillDetails>[

];

List<BillDetails> billDetails2 = <BillDetails>[
];


