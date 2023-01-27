import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language/main.dart';
import 'package:language/theme.dart';
import 'package:language/widgets/custom_search_delegate.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  bool isSearchAvailable;
  CustomAppBar({required this.isSearchAvailable, this.title, Key? key})
      // ignore: prefer_const_constructors
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomTheme.areaBgColor,
      title: Center(
        child: Text(
          widget.title ?? "",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15.w),
          child: widget.isSearchAvailable
              ? GestureDetector(
                  onTap: () => _showSearchPage(),
                  child: const Icon(
                    Icons.search,
                  ),
                )
              : PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Text("settings".tr()),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      navigatorKey.currentState?.pushNamed('settings');
                    }
                  },
                ),
        ),
      ],
    );
  }

  _showSearchPage() {
    showSearch(context: context, delegate: CustomSearchDelegate());
  }
}
