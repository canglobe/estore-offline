import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:estore/main.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/products.dart';
import 'package:estore/views/customers/customers.dart';
import 'package:estore/views/calculator/calculator_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentPageIndex = 1;
  bool? isDark;

  // final fb = FB();

  List<Widget> pages = <Widget>[
    const CustomersScreen(),
    const ProductScreen(),
    const Calculator(),
  ];

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          closeIconColor: Colors.white,
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Text('I think your internet was not connected!'),
          duration: Duration(seconds: 9),
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  onDestinationSelected(index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 0,
        leading: Image.asset(
          'assets/brand/brand_logo.png',
        ),
        actions: [
          // ---------------------------------------------------------------------------- Cloud Upload
          // IconButton(
          //   onPressed: () async {
          //     checkUserConnection();
          //     setState(() {});
          //   },
          //   icon: const Icon(Icons.cloud_upload_outlined),
          //   tooltip: 'Cloud Upload',
          // ),
          // ---------------------------------------------------------------------------- Mode Change
          IconButton(
            onPressed: () async {
              var mode = localdb.get('darkMode');

              Ept1App.of(context)
                  .changeTheme(mode = mode == true ? false : true);
              setState(() {
                isDark = !mode;
              });
            },
            icon: Icon(isDark != true
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            tooltip: 'Mode',
          ),
          // ---------------------------------------------------------------------------- End of Actions
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          onDestinationSelected(index);
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          // ---------------------------------------------------------------------------- Customers
          NavigationDestination(
            selectedIcon: Icon(
              Icons.group,
              color: secondryColor,
              size: 23,
            ),
            icon: const Icon(
              Icons.group_outlined,
              size: 23,
            ),
            label: 'Customers',
          ),

          // ---------------------------------------------------------------------------- products
          NavigationDestination(
            selectedIcon: Icon(
              Icons.category_rounded,
              color: secondryColor,
              size: 23,
            ),
            icon: const Icon(
              Icons.category_outlined,
              size: 23,
            ),
            label: 'Products',
          ),

          // ---------------------------------------------------------------------------- Calculator
          NavigationDestination(
            selectedIcon: Icon(
              Icons.calculate_rounded,
              color: secondryColor,
              size: 23,
            ),
            icon: const Icon(
              Icons.calculate_outlined,
              size: 23,
            ),
            label: 'Calculator',
          ),
          // ---------------------------------------------------------------------------- End of NavigationBar
        ],
      ),
      body: pages[currentPageIndex],
    );
  }

  _showDialog(status) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: status != 'completed'
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Uploading..'),
                      CircularProgressIndicator(),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Uploaded successful'),
                    ],
                  ),
          );
        });
  }
}
