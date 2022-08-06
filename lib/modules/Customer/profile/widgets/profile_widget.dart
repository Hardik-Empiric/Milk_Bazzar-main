import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/login_models/loginModels.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_functions/common_functions.dart';
import '../../../../utils/common_widget/app_logo.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../language/controller/LacaleString.dart';
import '../controller/profile_controller.dart';
import 'package:dotted_border/dotted_border.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController profileController = Get.put(ProfileController());

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
            profilesDetails(),
          ],
        ),
      ),
    );
  }

  profilesDetails() {
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
              boxShadow:  [
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
                          text: LocaleString().updateProfile.tr,
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlobalText(
                        text: LocaleString().profileMsg.tr,
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    editImage,
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

  Widget get editImage {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10, left: 50, right: 50),
      child: DottedBorder(
        color: AppColors.blue,
        borderType: BorderType.RRect,
        radius: const Radius.circular(5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            height: SizeData.height * 0.16,
            decoration: BoxDecoration(
              color: AppColors.suffixContainerColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 0, left: 60, right: 60, bottom: 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);

                      if (photo != null) {
                        img_path = photo.path;
                        imgstatus = true;
                      } else {
                        imgstatus = false;
                      }
                      setState(() {});
                    },
                    child: imgstatus ? Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                          image: DecorationImage(
                            image: FileImage(File(img_path)),
                            fit: BoxFit.cover,
                          )),
                    ) : Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                      ),
                      child: const Icon(Icons.camera),
                    ),
                  ),
                  GlobalText(
                      text: LocaleString().editImage.tr,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ],
              ),
            ),
          ),
        ),
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
                    labelStyle:  TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Graphik"),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: AppColors.pendingAmountColor,
                          width: 2),
                    ),
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
                      flex: 5,
                      child: Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(
                                color: AppColors.borderColor,
                                width: 2)),
                        child: countryCodePicker(context),
                      ),
                    ),
                    Expanded(flex: 1,child: Container(),),
                    Expanded(
                      flex: 12,
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10)
                        ],
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
                                  color: AppColors
                                      .pendingAmountColor,
                                  width: 2),
                            ),
                            labelStyle:  TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Graphik"),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.blue,
                                  width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.borderColor,
                                  width: 2),
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
                style:  TextStyle(
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
                          color: AppColors.pendingAmountColor,
                          width: 2),
                    ),
                    labelStyle:  TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 18,
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

            LoginModels.name = fullNameController.text;
            LoginModels.phone = int.parse(phoneController.text);
            LoginModels.address = addressController.text;
          }
        },
        child: GlobalText(
          text: LocaleString().updateProfile.tr,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
