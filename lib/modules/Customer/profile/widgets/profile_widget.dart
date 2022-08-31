import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String urlDownload = "";
  UploadTask? uploadTask;
  bool loading = true;

  final GlobalKey<FormState> _globalFromKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController prizePerLiterController = TextEditingController();

  var allData;
  String profile_image_path = '';

  var data;
  var user;

  bool isMerchant = Get.arguments;

  List allCusName = [];

  getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getBool("isMerchant"));

    if (isMerchant) {

      var data = await FirebaseFirestore.instance
          .collection('merchants')
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .get();
      fullNameController.text = data.data()!['name'];
      phoneController.text = data.data()!['number'].toString().replaceAll('+91', "");
      addressController.text = data.data()!['add'];
      prizePerLiterController.text = data.data()!["price_per_liter"].toString();
      setState(() {
        urlDownload = data.data()!['image'];
      });


    } else {
      var data = await FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .get();
      fullNameController.text = data.data()!['name'];
      phoneController.text = data.data()!['number'].toString().replaceAll('+91', "");
      addressController.text = data.data()!['add'];
      setState(() {
        urlDownload = data.data()!['image'];
      });
    }
    var cc = await FirebaseFirestore.instance
        .collection('customers')
        .get();

    var mm = await FirebaseFirestore.instance
        .collection('merchants')
        .get();

    cc.docs.forEach((element) {
      if(element.data()["name"].toString().toLowerCase() != fullNameController.text.toLowerCase())
      {
        allCusName.add(element.data()["name"].toString().toLowerCase());
      }
    });

    mm.docs.forEach((element) {
      if(element.data()["name"].toString().toLowerCase() != fullNameController.text.toLowerCase())
      {
        allCusName.add(element.data()["name"].toString().toLowerCase());
      }
    });

    allCusName.forEach((element) {
      log(element);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
    Timer(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

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
                          await _picker.pickImage(source: ImageSource.gallery);

                      setState(() {
                        img_path = photo!.path;
                        loading = true;
                      });

                      File tmpFile = File(img_path);

                      final String downloadPath =
                          await ExternalPath.getExternalStoragePublicDirectory(
                              ExternalPath.DIRECTORY_DOWNLOADS);
                      final String fileName = basename(img_path);
                      final String fileExtension = extension(img_path);

                      tmpFile = await tmpFile.copy('$downloadPath/$fileName');

                      print(">>>>>>>>>>>>>>>>>>>>>>>>>");
                      print(tmpFile.path);
                      print(">>>>>>>>>>>>>>>>>>>>>>>>>");

                      setState(() {
                        profile_image_path = tmpFile.path;
                      });

                      final profilePictureName =
                          FirebaseAuth.instance.currentUser!.uid.toString();
                      final path = 'file/${profilePictureName}.jpg';
                      final file = File(photo!.path);

                      final ref = FirebaseStorage.instance.ref().child(path);
                      setState(() {
                        uploadTask = ref.putFile(file);
                      });

                      final snapshot = await uploadTask!.whenComplete(() {});

                      urlDownload = await snapshot.ref.getDownloadURL();
                      log('Download Link : $urlDownload');

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      log(prefs.getBool("isMerchant").toString());

                      if (prefs.getBool("isMerchant") == false) {
                        user = FirebaseFirestore.instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'image': "$urlDownload",
                        });

                        data = await FirebaseFirestore.instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                      } else {
                        user = FirebaseFirestore.instance
                            .collection('merchants')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'image': "$urlDownload",
                        });

                        data = await FirebaseFirestore.instance
                            .collection('merchants')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                      }

                      setState(() {
                        urlDownload = data.data()!['image'];
                        print(urlDownload);
                        loading = false;
                      });
                    },
                    child: urlDownload.isNotEmpty
                        ? Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            child: Visibility(
                              child: Transform.scale(
                                scale: 0.7,
                                child: CircularProgressIndicator(
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              visible: loading,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blue,
                              image: DecorationImage(
                                image: NetworkImage(urlDownload),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
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
                  if(allCusName.contains(val.toLowerCase()))
                    {
                      return "name is already exist";
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
                      flex: 5,
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
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 12,
                      child: TextFormField(
                        readOnly: true,
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
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Visibility(
                  visible: isMerchant,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 65),
                    child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return LocaleString().errorPrizePerLiter.tr;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: prizePerLiterController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Graphik"),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          labelText: LocaleString().rupeesPerLiter.tr,
                          labelStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 20,
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
                          // prefix: GlobalText(text: "₹",color: AppColors.hintTextColor,fontSize: 25),
                          prefixText: "₹",
                          prefixStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                          hintText: LocaleString().enterYourRupees.tr,
                          hintStyle: const TextStyle(
                            color: AppColors.hintTextColor,
                            fontSize: 13,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  ),
                ),
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

  Widget buildProcess() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            double progress = data.bytesTransferred / data.totalBytes;
            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blue,
                image: DecorationImage(
                  image: NetworkImage(urlDownload),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            return Container(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(color: AppColors.white),
            );
          }
        },
      );

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

            SharedPreferences prefs = await SharedPreferences.getInstance();

            if (prefs.getBool("isMerchant") == false) {
              var user = FirebaseFirestore.instance
                  .collection('customers')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                'name': "${LoginModels.name}",
                'number': "${LoginModels.phone}",
                'add': "${LoginModels.address}",
                'type': "customer",
                'image': "$urlDownload",
              });
            } else {
              var user = FirebaseFirestore.instance
                  .collection('merchants')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                'name': "${LoginModels.name}",
                'number': "${LoginModels.phone}",
                'add': "${LoginModels.address}",
                'type': "merchant",
                'image': "$urlDownload",
                'price_per_liter': double.parse(prizePerLiterController.text),
              });
            }
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
