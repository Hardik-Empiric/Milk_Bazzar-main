import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../widgets/generate_bill_merchant_widget.dart';

class GenerateBillMerchantScreen extends StatefulWidget {
  const GenerateBillMerchantScreen({Key? key}) : super(key: key);

  @override
  State<GenerateBillMerchantScreen> createState() => _GenerateBillMerchantScreenState();
}

class _GenerateBillMerchantScreenState extends State<GenerateBillMerchantScreen> {

  var data = Get.arguments;

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

  var currentYear = DateTime.now().year.toString();
  var currentMonth;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMonth = months[DateTime.now().month - 1];
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                Bill(data :data,currentYear: currentYear,currentMonth: currentMonth),
                SendBillButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
