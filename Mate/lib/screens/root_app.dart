import 'package:bankingapp/screens/budget_page.dart';
import 'package:bankingapp/screens/create_budge_page.dart';
import 'package:bankingapp/screens/daily_page.dart';
import 'package:bankingapp/screens/profile_page.dart';
import 'package:bankingapp/screens/stats_page.dart';
import 'package:bankingapp/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  List<Widget> pages = [BudgetPage(), CreatBudgetPage()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              selectedTab(1);
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
            backgroundColor: primary
            //params
            ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
