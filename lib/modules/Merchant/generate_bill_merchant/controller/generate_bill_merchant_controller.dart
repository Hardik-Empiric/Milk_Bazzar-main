import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

var date = DateTime.now();

var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
var CMTD = firstDayNextMonth.difference(firstDayThisMonth).inDays;

class GenerateBillController extends GetxController {

  RxInt currentMonthsTotalDays = CMTD.obs;

  RxBool isLoading = true.obs;

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
  // BillDetails(date: 'DATE', morning: "MORNING", evening: "EVENING"),

];

List<BillDetails> billDetails2 = <BillDetails>[
  // BillDetails(date: 'DATE', morning: "MORNING", evening: "EVENING"),
  // BillDetails(date: '17', morning: '-', evening: '-'),
  // BillDetails(date: '18', morning: '-', evening: '-'),
  // BillDetails(date: '19', morning: '-', evening: '-'),
  // BillDetails(date: '20', morning: '-', evening: '-'),
  // BillDetails(date: '21', morning: '-', evening: '-'),
  // BillDetails(date: '22', morning: '-', evening: '-'),
  // BillDetails(date: '23', morning: '-', evening: '-'),
  // BillDetails(date: '24', morning: '-', evening: '-'),
  // BillDetails(date: '25', morning: '-', evening: '-'),
  // BillDetails(date: '26', morning: '-', evening: '-'),
  // BillDetails(date: '27', morning: '-', evening: '-'),
  // BillDetails(date: '28', morning: '-', evening: '-'),
  // BillDetails(date: '29', morning: '-', evening: '-'),
  // BillDetails(date: '30', morning: '-', evening: '-'),
  // BillDetails(date: '31', morning: '-', evening: '-'),
  // BillDetails(date: '-', morning: '-', evening: '-'),
];


