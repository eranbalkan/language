import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language/main.dart';
import 'package:language/theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: CustomTheme.areaBgColor,
            ),
            currentAccountPictureSize: const Size(90, 90),
            currentAccountPicture: const ClipOval(
              child: Image(image: AssetImage('assets/images/profile.png'), fit: BoxFit.cover),
            ),
            accountEmail: null,
            accountName: const Text("drawerHeaderText").tr(),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('homepage').tr(),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.pop(context);
                    navigatorKey.currentState?.pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: const Text('myLearning').tr(),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.pop(context);
                    navigatorKey.currentState?.pushNamed('learning');
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.w),
            child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey.shade600)),
          )
        ],
      ),
    );
  }
}
