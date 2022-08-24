import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:milk_bazzar/modules/Merchant/select_customer/controller/select_customer_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../controller/generate_bill_merchant_controller.dart';
import '../widgets/generate_bill_merchant_widget.dart';

class GenerateBillMerchantScreen extends StatefulWidget {
  const GenerateBillMerchantScreen({Key? key}) : super(key: key);

  @override
  State<GenerateBillMerchantScreen> createState() => _GenerateBillMerchantScreenState();
}

class _GenerateBillMerchantScreenState extends State<GenerateBillMerchantScreen> {

  DATA data = Get.arguments;

List months = [
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

  var currentYear = DateTime.now().year.toString();
  var currentMonth;

  GenerateBillController generateBillController =
  Get.put(GenerateBillController());
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMonth = monthItemsInENGLISH[DateTime.now().month - 1];
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        if(generateBillController.isLoading.value)
          {
            Fluttertoast.showToast(
              msg: "Bill is Generating...",
              toastLength: Toast.LENGTH_SHORT,
              webBgColor: "#e74c3c",
              textColor: AppColors.black,
              timeInSecForIosWeb: 3,
            );
          }
      return !generateBillController.isLoading.value;
      },
      child: Scaffold(
        backgroundColor: AppColors.blue,
        body: SafeArea(
          child: Container(
            height: SizeData.height,
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children:  [
                  Bill(data :data.uid,currentYear: data.year,currentMonth: data.month),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

