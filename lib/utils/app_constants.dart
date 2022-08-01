

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SizeData {

  static double width = 0;
  static double height = 0;


  SizeData(BuildContext context){

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

  }

}

bool? isE;
bool? isG;
bool? isH;


bool isDark = false;

