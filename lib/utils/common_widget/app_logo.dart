import 'package:flutter/material.dart';
import 'package:milk_bazzar/utils/app_colors.dart';

import '../app_constants.dart';
import '../app_images.dart';


appLogo() {

  return Container(
    decoration:  BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          offset:  Offset(0, 4),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Image.asset(
      AppImages.appLogo,
      height: 125,
      width: 125,
    ),
  );
}