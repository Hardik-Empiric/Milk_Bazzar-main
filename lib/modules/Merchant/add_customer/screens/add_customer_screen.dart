
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/app_constants.dart';
import '../widgets/add_customer_widget.dart';


class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {

  per() async {
    log('start');
    await Permission.contacts.request();
    log('end');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    per();
  }

  @override
  Widget build(BuildContext context) {
    SizeData(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// BackLayer
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: AppColors.blue,
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  color:  Theme.of(context).backgroundColor,
                ),
              ),
            ],
          ),

          /// FrontLayer
          const AddCustomer(),
        ],
      ),
    );
  }
}
