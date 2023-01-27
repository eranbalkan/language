import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MenuOrginizer {
  const MenuOrginizer();

  static List<Map<String, dynamic>> homePageMenu = [
    {"name": "mostCommon1000words".tr(), "keyword": "words1000"},
    {"name": "oxfordB2words".tr(), "keyword": "oxfordB2"},
    {"name": "oxfordC1words".tr(), "keyword": "oxfordC1"},
  ];
  static List<Color> homePageMenuColors = [Colors.red, Colors.yellow, Colors.green, Colors.orange, Colors.blue];
}
