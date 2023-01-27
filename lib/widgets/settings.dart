import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:language/widgets/appbar.dart';
import 'package:language/widgets/drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(isSearchAvailable: false, title: "settings".tr()),
      body: Container(),
    );
  }
}
