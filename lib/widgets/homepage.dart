import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:language/widgets/appbar.dart';
import 'package:language/widgets/drawer.dart';
import 'package:language/widgets/flashcards.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(isSearchAvailable: false),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text("clickAgain".tr()),
        ),
        child: const FlashCards(),
      ),
    );
  }
}
