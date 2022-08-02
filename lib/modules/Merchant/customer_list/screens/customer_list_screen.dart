import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';
import 'package:milk_bazzar/utils/app_constants.dart';

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
                  Expanded(child: Searching(),flex: 9,),
                  Expanded(child: AddPerson(),flex: 2,),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(10, (index) => const Contacts()).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
