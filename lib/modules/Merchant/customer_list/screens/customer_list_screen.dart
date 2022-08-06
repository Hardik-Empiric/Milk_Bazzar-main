import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:milk_bazzar/utils/app_colors.dart';
import 'package:milk_bazzar/utils/app_constants.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/common_widget/global_text.dart';
import '../../../Customer/language/controller/LacaleString.dart';
import '../../home/controller/home_controller.dart';
import '../controller/customer_list_controller.dart';
import '../widgets/customer_list_widget.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  Expanded(
                    child: Searching(),
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
                child: (contactLists.isNotEmpty)
                    ? ListView.builder(
                        itemCount: contactLists.length,
                        itemBuilder: (context, i) {
                          print(contactLists.length);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.generateBill);
                                },
                                child: ListTile(
                                  trailing: Obx(
                                    () => Visibility(
                                      visible: customerListController
                                          .isRemoveOn.value,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: AppColors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            contactLists
                                                .remove(contactLists[i]);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  leading: const CircleAvatar(
                                    radius: 22,
                                    backgroundImage: NetworkImage(
                                        "https://images.unsplash.com/photo-1603384699007-50799748fc45?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fG1lbnN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"),
                                  ),
                                  title: GlobalText(
                                    text: contactLists[i].fullName,
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
                        },
                      )
                    : Center(
                        child: GlobalText(
                          text:
                              "No Any Customer\nClick + Button to Add Customer",
                          textAlign: TextAlign.center,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
              ),
            )
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
