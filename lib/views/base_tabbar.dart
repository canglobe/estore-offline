// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/views/sold/sold.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/products.dart';
import 'package:estore/views/customers/customers.dart';

import 'ept1.dart';

class BaseTapBar extends StatefulWidget {
  const BaseTapBar({super.key});

  @override
  State<BaseTapBar> createState() => _BaseTapBarState();
}

class _BaseTapBarState extends State<BaseTapBar> with TickerProviderStateMixin {
  late final TabController _tabController;
  bool? isDarkMode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 90,
          leading: Image.asset(
            'assets/brand/brand_logo.png',
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(
                  Icons.group,
                  color: bgColor,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.category,
                  color: bgColor,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.sell,
                  color: bgColor,
                ),
              ),
            ],
          ),
          actions: [
            // ---------------------------------------------------------------------------- Calculator
            // IconButton(
            //   onPressed: () async {
            //     //
            //     await localdb.clear();
            //     setState(() {});
            //   },
            //   icon: const Icon(Icons.calculate_outlined),
            //   tooltip: 'Cloud Upload',
            // ),
            // ---------------------------------------------------------------------------- Theme mode change
            IconButton(
              onPressed: () async {
                var mode = await hiveDb.getThemeMode();
                Ept1App.of(context).changeTheme(mode != true ? true : false);
                setState(() => isDarkMode = !mode);
              },
              icon: Icon(isDarkMode != true
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              tooltip: 'Theme Mode',
            ),
            // ---------------------------------------------------------------------------- End of actions.
          ]),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          CustomersScreen(),
          ProductScreen(),
          SoldScreen(),
        ],
      ),
    );
  }
}
