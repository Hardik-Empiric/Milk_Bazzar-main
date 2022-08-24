import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milk_bazzar/modules/Merchant/add_customer/controller/add_customer_controller.dart';
import 'package:milk_bazzar/modules/Merchant/customer_list/controller/customer_list_controller.dart';
import 'package:milk_bazzar/modules/Merchant/home/controller/home_controller.dart';
import 'package:milk_bazzar/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../models/login_models/loginModels.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_functions/common_functions.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../Customer/language/controller/LacaleString.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final AddCustomerController addCustomerController =
      Get.put(AddCustomerController());
  final HomeController homeController = Get.put(HomeController());

  final ImagePicker _picker = ImagePicker();
  bool imgstatus = false;
  String img_path = "";

  final GlobalKey<FormState> _globalFromKey = GlobalKey<FormState>();

  late TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            AddCustomersDetails(),
          ],
        ),
      ),
    );
  }

  AddCustomersDetails() {
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
                  offset: const Offset(0, 0),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 0, left: 0, bottom: 20, top: 0),
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
                          text: LocaleString().addCustomer.tr,
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().addCustomerMsg.tr,
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    form(),
                    doneButton(),
                  ],
                ),
              ),
            ),
          ),
          closeButton(),
        ],
      ),
    );
  }

  form() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
      child: Form(
          key: _globalFromKey,
          child: Column(
            children: [
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return LocaleString().errorName.tr;
                  }
                  return null;
                },
                onSaved: (val) {
                  LoginModels.name = val!;
                },
                controller: fullNameController,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Graphik"),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    labelText: LocaleString().fullName.tr,
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Graphik"),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: AppColors.pendingAmountColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: AppColors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: AppColors.borderColor, width: 2),
                    ),
                    hintText: LocaleString().enterYourFullName.tr,
                    hintStyle: const TextStyle(
                      color: AppColors.hintTextColor,
                      fontSize: 12,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(
                                color: AppColors.borderColor, width: 2)),
                        child: countryCodePicker(context),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return LocaleString().errorPhone.tr;
                          }
                          return null;
                        },
                        onSaved: (val) {
                          LoginModels.phone = int.parse(val!);
                        },
                        enableInteractiveSelection: false,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        controller: phoneController,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Graphik"),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            labelText: LocaleString().phone.tr,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.pendingAmountColor,
                                  width: 2),
                            ),
                            labelStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Graphik"),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.borderColor, width: 2),
                            ),
                            hintText: LocaleString().phoneNumber.tr,
                            hintStyle: const TextStyle(
                              color: AppColors.hintTextColor,
                              fontSize: 13,
                            ),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return LocaleString().errorAddress.tr;
                  }
                  return null;
                },
                onSaved: (val) {
                  LoginModels.address = val;
                },
                maxLines: 5,
                controller: addressController,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Graphik"),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    labelText: LocaleString().address.tr,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: AppColors.pendingAmountColor, width: 2),
                    ),
                    labelStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Graphik"),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: AppColors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: AppColors.borderColor, width: 2),
                    ),
                    hintText: LocaleString().enterHomeAddress.tr,
                    hintStyle: const TextStyle(
                      color: AppColors.hintTextColor,
                      fontSize: 12,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ],
          )),
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

  doneButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.blue,
          fixedSize: Size(SizeData.width * 0.7, 45),
        ),
        onPressed: () async {



          if (_globalFromKey.currentState!.validate()) {
            _globalFromKey.currentState!.save();



            var cus =
                await FirebaseFirestore.instance.collection('customers').get();

            List customer = [];

            for (var docs in cus.docs) {
              customer.add(docs["number"]);
            }

            if (customer.contains(phoneController.text)) {
              var data = await FirebaseFirestore.instance
                  .collection('customers')
                  .where("number", isEqualTo: phoneController.text)
                  .get();
              var add = data.docs;
              add.forEach((element) async {
                var check = await FirebaseFirestore.instance
                    .collection('customers')
                    .doc(element.id.toString())
                    .get();
                if (check.data()!["merchant"].toString().isEmpty) {
                  var data = await FirebaseFirestore.instance
                      .collection('customers')
                      .doc("${element.id}")
                      .update({
                    'merchant':
                        FirebaseAuth.instance.currentUser!.uid.toString(),
                  });

                  contactLists.add(
                    ContactList(
                      fullName: fullNameController.text,
                      mobileNumber: phoneController.text,
                      address: addressController.text,
                    ),
                  );


                  log(Permission.contacts.request().isGranted.toString());
                  Contact contact = Contact();
                  contact.familyName = 'VishalBhai Thummar';
                  contact.phones = [Item(label: "mobile", value: '9974250661')];
                  contact.emails = [Item(label: "work", value: 'info@34.71.214.132')];
                  if (await Permission.contacts.request().isGranted) {
                    await ContactsService.addContact(contact);
                    log("Contact added successfully");
                  }

                  homeController.index.value = 0;

                  Get.offAllNamed(AppRoutes.home);
                } else {
                  var data = await FirebaseFirestore.instance
                      .collection("customers")
                      .where("number", isEqualTo: "${phoneController.text}")
                      .get();

                  var mer = await FirebaseFirestore.instance
                      .collection("merchants")
                      .get();

                  List merId = [];

                  mer.docs.forEach((element) {
                    merId.add(element.id.toString());
                  });

                  if (merId.contains("${data.docs[0]["merchant"]}")) {
                    Get.snackbar("Customer",
                        "customer has Already have an other Merchant...",
                        backgroundColor: AppColors.darkBlue,
                        colorText: AppColors.white);
                  } else {
                    var data = await FirebaseFirestore.instance
                        .collection('customers')
                        .doc("${element.id}")
                        .update({
                      'merchant':
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                    });

                    contactLists.add(
                      ContactList(
                        fullName: fullNameController.text,
                        mobileNumber: phoneController.text,
                        address: addressController.text,
                      ),
                    );

                    log(Permission.contacts.request().isGranted.toString());
                    Contact contact = Contact();
                    contact.familyName = '${fullNameController.text}';
                    contact.phones = [Item(label: "mobile", value: '${phoneController.text}')];
                    if (await Permission.contacts.request().isGranted) {
                      await ContactsService.addContact(contact);
                      log("Contact added successfully");
                    }

                    homeController.index.value = 0;

                    Get.offAllNamed(AppRoutes.home);
                  }
                }
              });
            } else {
              Get.snackbar("Customer", "No Found",
                  backgroundColor: AppColors.darkBlue,
                  colorText: AppColors.white);
            }
          }
        },
        child: GlobalText(
          text: LocaleString().addCustomer.tr,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
