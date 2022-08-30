import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:milk_bazzar/modules/Customer/language/controller/LacaleString.dart';
import 'package:milk_bazzar/modules/Merchant/customer_list/controller/customer_list_controller.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import 'package:milk_bazzar/utils/common_widget/global_text.dart';

import '../../../../utils/app_colors.dart';

class Searching extends StatefulWidget {
  const Searching({Key? key}) : super(key: key);

  @override
  State<Searching> createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 15),
      child: TextField(
        textAlign: TextAlign.center,
        cursorHeight: 20,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5),
          suffixIcon: IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.mic, color: Theme.of(context).primaryColor),
          ),
          hintText: LocaleString().searchCus.tr,
          hintStyle: const TextStyle(
            color: AppColors.darkGrey,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(13),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(13),
          ),
          prefixIcon:
              Icon(Icons.search_rounded, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}

class AddPerson extends StatefulWidget {
  const AddPerson({Key? key}) : super(key: key);

  @override
  State<AddPerson> createState() => _AddPersonState();
}

CustomerListController customerListController =
    Get.put(CustomerListController());

class _AddPersonState extends State<AddPerson> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17, bottom: 17, right: 15),
      child: GestureDetector(
        onTap: () {
          customerListController.isRemoveOn.value =
              !customerListController.isRemoveOn.value;
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.blue),
          ),
          child: Obx(
            () => Transform.scale(
              scale: 0.6,
              child: Image.asset(
                'assets/images/RC.png',
                color: (customerListController.isRemoveOn.value)
                    ? AppColors.darkGrey
                    : AppColors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Back extends StatefulWidget {
  const Back({Key? key}) : super(key: key);

  @override
  State<Back> createState() => _BackState();
}

class _BackState extends State<Back> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.black,
        ),
      ),
    );
  }
}
