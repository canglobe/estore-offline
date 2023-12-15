import 'package:estore/views/sold/sold.dart';
import 'package:flutter/material.dart';

import 'package:estore/main.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/products.dart';
import 'package:estore/views/customers/customers.dart';

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
    // const Calculator(),
    const SoldScreen(),
  ];

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
          // ---------------------------------------------------------------------------- Calculator
          // IconButton(
          //   onPressed: () async {
          //     // await localdb.delete('overallHistory');
          //     // var his = await localdb.get('overallHistory');
          //     // print(his);

          //     // String c = customTime();
          //     // String da =
          //     //     '${c.substring(0, 4)}-${c.substring(5, 7)}-${c.substring(8, 10)}';

          //     // print(da);
          //     await localdb.clear();
          //     // Navigator.of(context)
          //     //     .push(MaterialPageRoute(builder: (context) => Calculator()));
          //   },
          //   icon: const Icon(Icons.calculate_outlined),
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
        destinations: const <Widget>[
          // ---------------------------------------------------------------------------- Customers
          NavigationDestination(
            selectedIcon: Icon(
              Icons.group,
              color: secondryColor,
              size: 23,
            ),
            icon: Icon(
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
            icon: Icon(
              Icons.category_outlined,
              size: 23,
            ),
            label: 'Products',
          ),

          // ---------------------------------------------------------------------------- Calculator
          NavigationDestination(
            selectedIcon: Icon(
              Icons.sell_rounded,
              color: secondryColor,
              size: 23,
            ),
            icon: Icon(
              Icons.sell_outlined,
              size: 23,
            ),
            label: 'Solded',
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
