import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:milk_bazzar/modules/Customer/language/controller/LacaleString.dart';
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
      padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15,left: 15),
      child: TextField(
        textAlign: TextAlign.center,
        cursorHeight: 20,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5),
          suffixIcon:  Icon(Icons.mic, color: Theme.of(context).primaryColor),
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

          prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColor),
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

class _AddPersonState extends State<AddPerson> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17, bottom: 17,right: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.blue),
        ),

        child: Transform.scale(
          scale: 0.6,
          child: Image.asset('assets/images/RC.png'),
        ),
      ),
    );
  }
}

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.generateBill);
          },
          child: ListTile(
            leading: const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1603384699007-50799748fc45?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fG1lbnN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"),
            ),
            title: GlobalText(
              text: LocaleString().ronald.tr,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
            subtitle: Row(
              children: [
                GlobalText(
                  text: LocaleString().ronaldMonth.tr,
                  color: AppColors.textColor3,
                  fontWeight: FontWeight.w400,
                ),
                GlobalText(
                  text: LocaleString().ronaldAmount.tr,
                  color: AppColors.orange,
                  fontWeight: FontWeight.w500,
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
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.black,
      ),
    );
  }
}
