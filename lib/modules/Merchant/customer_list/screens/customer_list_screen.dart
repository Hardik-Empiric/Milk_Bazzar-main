import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:milk_bazzar/utils/app_colors.dart';
import 'package:milk_bazzar/utils/app_constants.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../../home/controller/home_controller.dart';
import '../../select_customer/controller/select_customer_controller.dart';
import '../controller/customer_list_controller.dart';
import '../widgets/customer_list_widget.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  CustomerListController customerListController =
      Get.put(CustomerListController());

  final HomeController homeController = Get.put(HomeController());

  var newData = [];
  var customerData = [];



  String searchResult = "";

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

  var currentYear = DateTime.now().year.toString();
  var currentMonth;
  var currentMontInAllLanguage;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMonth = monthItemsInENGLISH[DateTime.now().month - 1];
    currentMontInAllLanguage = monthItems[DateTime.now().month - 1];
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: SizeData.height * 0.09,
              color: Theme.of(context).backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchResult = value;
                          });
                        },
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        textAlign: TextAlign.center,
                        cursorHeight: 20,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 5),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.mic,
                                color: Theme.of(context).primaryColor),
                          ),
                          hintText: LocaleString().searchCus.tr,
                          hintStyle: const TextStyle(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(Icons.search_rounded,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    flex: 11,
                  ),
                  Expanded(
                    child: AddPerson(),
                    flex: 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("customers")
                      .where("merchant",
                          isEqualTo:
                              FirebaseAuth.instance.currentUser!.uid.toString())
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                    if (snapshots.hasData) {
                      customerData = snapshots.data!.docs;

                      newData = customerData;

                      if (newData.length == 0) {
                        return Center(
                          child: GlobalText(
                            text: LocaleString().noCustomer.tr,
                            textAlign: TextAlign.center,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        );
                      } else {
                        return ListView.builder(
                                itemCount: newData.length,
                                itemBuilder: (context, i) {
                                  final singleData = newData[i];

                                  return (singleData["name"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchResult.toLowerCase()))
                                      ? Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoutes
                                                        .generateBillMerchant,
                                                    arguments: DATA(
                                                      uid: singleData['uid'],
                                                      month: currentMonth,
                                                      year: currentYear,
                                                    ));
                                              },
                                              child: ListTile(
                                                trailing: Obx(
                                                  () => Visibility(
                                                    visible:
                                                        customerListController
                                                            .isRemoveOn.value,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: AppColors.red,
                                                      ),
                                                      onPressed: () {
                                                        Get.defaultDialog(
                                                          onCancel: () {
                                                            Get.back();
                                                          },
                                                          onConfirm: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'customers')
                                                                .doc(singleData[
                                                                        "uid"]
                                                                    .toString())
                                                                .delete();
                                                            Get.back();
                                                          },
                                                          title: LocaleString()
                                                              .areYouSure
                                                              .tr,
                                                          backgroundColor:
                                                              AppColors.white,
                                                          titleStyle: TextStyle(
                                                              color: AppColors
                                                                  .darkBlue),
                                                          middleTextStyle:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          textConfirm:
                                                              LocaleString()
                                                                  .yes
                                                                  .tr,
                                                          textCancel:
                                                              LocaleString()
                                                                  .no
                                                                  .tr,
                                                          cancelTextColor:
                                                              Colors.black,
                                                          confirmTextColor:
                                                              Colors.white,
                                                          buttonColor:
                                                              AppColors.blue,
                                                          barrierDismissible:
                                                              false,
                                                          radius: 50,
                                                          content: Text(
                                                              LocaleString()
                                                                  .wantToDelete
                                                                  .tr),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                leading: CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: (singleData[
                                                              "image"]
                                                          .toString()
                                                          .isNotEmpty)
                                                      ? NetworkImage(
                                                          singleData["image"])
                                                      : null,
                                                ),
                                                title: GlobalText(
                                                  text: singleData["name"],
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                ),
                                                subtitle: Row(
                                                  children: [
                                                    GlobalText(
                                                      text:
                                                          "$currentMontInAllLanguage${LocaleString().ronaldMonth.tr}",
                                                      color:
                                                          AppColors.textColor3,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    StreamBuilder(
                                                      stream: FirebaseFirestore.instance
                                                          .collection("customers")
                                                          .doc("${singleData["uid"]}")
                                                          .collection("milk_data")
                                                          .doc(currentYear)
                                                          .collection(currentMonth)
                                                          .doc("total_price")
                                                          .snapshots(),
                                                      builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshots) {

                                                        if(snapshots.hasData)
                                                          {
                                                            var data = snapshots.data!.data()?["prize"];
                                                            return GlobalText(
                                                                  text: (data == null) ? "${0.0}" : '${data}',
                                                                  color: AppColors.orange,
                                                                  fontWeight: FontWeight.w500,
                                                                );
                                                          }
                                                        else
                                                          {
                                                            return Container();
                                                          }

                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 0.5,
                                              indent: 25,
                                              endIndent: 25,
                                              color: AppColors.borderColor,
                                            ),
                                          ],
                                        )
                                      : Visibility(
                                          child: Container(),
                                          visible: false,
                                        );
                                },
                              );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addCustomer);
        },
        backgroundColor: Theme.of(context).backgroundColor,
        child: Image.asset('assets/icons/addContact.png', scale: 17),
      ),
    );
  }

}
