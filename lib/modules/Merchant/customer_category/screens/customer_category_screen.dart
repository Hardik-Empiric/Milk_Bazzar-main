
import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';

import '../../../../utils/app_constants.dart';
import '../widgets/customer_category_widget.dart';


class CustomerCategoryScreen extends StatefulWidget {
  const CustomerCategoryScreen({Key? key}) : super(key: key);

  @override
  State<CustomerCategoryScreen> createState() => _CustomerCategoryScreenState();
}

class _CustomerCategoryScreenState extends State<CustomerCategoryScreen> {

  @override
  Widget build(BuildContext context) {
    SizeData(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// BackLayer
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: AppColors.blue,
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ],
          ),

          /// FrontLayer
          const CustomerCategory(),
        ],
      ),
    );
  }
}
