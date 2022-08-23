import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/modules/Merchant/home/controller/home_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../controller/customer_category_controller.dart';

class CustomerCategory extends StatefulWidget {
  const CustomerCategory({Key? key}) : super(key: key);

  @override
  State<CustomerCategory> createState() => _CustomerCategoryState();
}

class _CustomerCategoryState extends State<CustomerCategory> {
  final CustomerCategoryController customerCategoryController =
      Get.put(CustomerCategoryController());
  final HomeController homeController = Get.put(HomeController());

  var totalCustomer = [];

  var paddingBillCustomer = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            CustomerCategoryDetails(),
          ],
        ),
      ),
    );
  }

  CustomerCategoryDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  offset: Offset(0, 0),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 0, left: 0, bottom: 15, top: 0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: appLogo(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: GlobalText(
                          color: Theme.of(context).primaryColor,
                          text: LocaleString().selectCustomer.tr,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().customerCategory.tr,
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){


                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Stack(
                          alignment: Alignment(-0.9, -0.95),
                          children: [
                            Container(
                              height: SizeData.height * 0.06,
                              width: SizeData.width * 0.8,
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 15, top: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppColors.borderColor, width: 2)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GlobalText(
                                      text:
                                      "${LocaleString().totalText.tr} ${totalCustomer.length} ${LocaleString().customer.tr}",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: AppColors.darkGrey,
                                    ),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: AppColors.borderColor,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.blue,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Theme.of(context).backgroundColor,
                              padding: EdgeInsets.all(4),
                              child: GlobalText(
                                text: LocaleString().pendingAmount.tr,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        homeController.index.value = 0;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Stack(
                          alignment: Alignment(-0.9, -0.95),
                          children: [
                            Container(
                              height: SizeData.height * 0.06,
                              width: SizeData.width * 0.8,
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 15, top: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppColors.borderColor, width: 2)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GlobalText(
                                      text:
                                          "${LocaleString().totalText.tr} ${totalCustomer.length} ${LocaleString().customer.tr}",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: AppColors.darkGrey,
                                    ),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: AppColors.borderColor,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.blue,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Theme.of(context).backgroundColor,
                              padding: EdgeInsets.all(4),
                              child: GlobalText(
                                text: LocaleString().allCustomerBill.tr,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  closeButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withOpacity(0.5),
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Icon(
                Icons.close_rounded,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            )),
      ),
    );
  }

  paddingBilCus({required Alignment alignment, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Stack(
        alignment: Alignment(-0.9, -0.95),
        children: [
          Container(
            height: SizeData.height * 0.06,
            width: SizeData.width * 0.8,
            margin:
                const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.borderColor, width: 2)),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("customers")
                      .where("merchant",
                          isEqualTo:
                              FirebaseAuth.instance.currentUser!.uid.toString())
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                    if (snapshots.hasData) {
                      totalCustomer = snapshots.data!.docs;

                      return DropdownButtonFormField2(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        isExpanded: true,
                        hint: GlobalText(
                          text:
                              "${LocaleString().totalText.tr} ${totalCustomer.length} ${LocaleString().customer.tr}",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                        icon: CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.borderColor,
                          child: Icon(
                            icon,
                            color: AppColors.blue,
                            size: 20,
                          ),
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        items: totalCustomer.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["name"].toString(),
                            child: Text(
                              item["name"].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select customer.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when changing the item if you want.
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.all(4),
            child: GlobalText(
              text: LocaleString().pendingAmount.tr,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  totalCus({required Alignment alignment, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Stack(
        alignment: Alignment(-0.9, -0.95),
        children: [
          Container(
            height: SizeData.height * 0.06,
            width: SizeData.width * 0.8,
            margin:
                const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.borderColor, width: 2)),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("customers")
                      .where("merchant",
                          isEqualTo:
                              FirebaseAuth.instance.currentUser!.uid.toString())
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                    if (snapshots.hasData) {
                      totalCustomer = snapshots.data!.docs;

                      return DropdownButtonFormField2(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        isExpanded: true,
                        hint: GlobalText(
                          text:
                              "${LocaleString().totalText.tr} ${totalCustomer.length} ${LocaleString().customer.tr}",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                        icon: CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.borderColor,
                          child: Icon(
                            icon,
                            color: AppColors.blue,
                            size: 20,
                          ),
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        items: totalCustomer.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["name"].toString(),
                            child: Text(
                              item["name"].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select customer.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when changing the item if you want.
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.all(4),
            child: GlobalText(
              text: LocaleString().allCustomerBill.tr,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  doneButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.blue,
          fixedSize: Size(SizeData.width * 0.7, 45),
        ),
        onPressed: () {},
        child: GlobalText(
          text: AppTexts.done,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
