import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milk_bazzar/modules/Customer/customer_list/screens/customer_list_screen.dart';
import 'package:milk_bazzar/modules/Customer/settings/screens/settings_screen.dart';
import 'package:milk_bazzar/modules/Merchant/sell_milk/screens/sell_milk_screen.dart';
import 'package:milk_bazzar/utils/app_constants.dart';
import 'package:milk_bazzar/utils/common_widget/global_text.dart';

import '../../../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int index = 0;

  List pages = [
    CustomerListScreen(),
    Center(child: Text('2nd Page'),),
    Center(child: Text('3rd Page'),),
    SellMilkScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: pages[index],
      bottomNavigationBar: Container(
        width: SizeData.width,
        height: SizeData.height * 0.075,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue,
              blurRadius: 15,
              offset: Offset(1, 8),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navigatorIconButtons(iconName: 'home', i: 0),
              navigatorIconButtons(iconName: 'monthYear',i: 1),
              navigatorIconButtons(iconName: 'billCate',i: 2),
              navigatorIconButtons(iconName: 'sellMilk',i: 3),
              navigatorIconButtons(iconName: 'setting',i: 4),
            ],
          ),
        ),
      ),
    );
  }

  navigatorIconButtons({required String iconName, required int i}) {
    return SizedBox(
      width: SizeData.width * 0.11,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: (index == i) ? true : false,
            child: Container(
              height: SizeData.height * 0.006,
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = i;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/icons/$iconName.png',
                color: (index == i) ? AppColors.darkBlue : Theme.of(context).primaryColor,
                scale: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
