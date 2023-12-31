import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:estore/utils/size.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/product_plus.dart';
import 'package:estore/views/products/product_details.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool ifintialloading = true;
  String? prname;
  List? products;
  bool? reFresh;
  Map? ldbs;
  bool showFab = true;

  getData() async {
    Map productDetails = await HiveDB().getProductDetails();
    return productDetails;
  }

// UI Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              showFab = false;
            } else if (direction == ScrollDirection.forward) {
              showFab = true;
            }
          });
          return true;
        },
        child: Column(
          children: [
            _subTitle(),
            const Divider(),
            _productsList(),
          ],
        ),
      ),
      floatingActionButton: _fab(),
    );
  }

  _subTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Products',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }

  _productsList() {
    return Expanded(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List products = [];

            Map snap = snapshot.data;

            for (var key in snap.keys) {
              products.add(key);
            }

            products.sort();
            return Container(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(2),
                    child: GestureDetector(
                      onTap: () {
                        screenRoute(context, index, snap, products, false);
                      },
                      child: SizedBox(
                        height: screenSize(context,
                            isHeight: true, percentage: 16.5),
                        child: Card(
                          elevation: 0.3,
                          color: cardBgColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Image Show--------------------------
                                SizedBox(
                                  width: screenSize(context,
                                      isHeight: false, percentage: 50),
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)),
                                      child: snap[products[index]]['image'] !=
                                              false
                                          ? Image.file(
                                              File(
                                                  '${imagePath + products[index]}.png'),
                                              fit: BoxFit.fill,
                                            )
                                          : Container(
                                              color: primaryColor,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Text(
                                                      products[index]
                                                          .toString()
                                                          .toUpperCase(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            )),
                                ),
                                //---------------------------------------------------------
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Stock',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              ),
                                              Text(
                                                snap[products[index]]
                                                        ['quantity']
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    // Theme.of(context)
                                                    //     .textTheme
                                                    //     .headlineLarge,
                                                    TextStyle(
                                                        color: textLightColor,
                                                        fontSize: snap[products[
                                                                            index]]
                                                                        [
                                                                        'quantity']
                                                                    .toString()
                                                                    .length >
                                                                4
                                                            ? 18
                                                            : 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    screenRoute(context, index,
                                                        snap, products, true);
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                    color: textLightColor,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      )
                                    ],
                                  ),
                                ),
                                //---------------------
                              ]),
                        ),
                      ),
                    ),
                  ),
                  itemCount: products.length,
                ));
          } else {
            return const Center();
          }
        },
      ),
    );
  }

  _fab() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: showFab ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showFab ? 1 : 0,
        child: FloatingActionButton.extended(
          onPressed: () => navigationTo(context),
          label: const Icon(Icons.add),
        ),
      ),
    );
  }

  screenRoute(
    BuildContext context,
    int index,
    Map<dynamic, dynamic> snap,
    List<dynamic> products,
    bool ifsell,
  ) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ProductDetailPage(
                  index: index,
                  price: snap[products[index]]['price'],
                  image: snap[products[index]]['image'],
                  quantity: snap[products[index]]['quantity'],
                  productname: products[index],
                  ifsell: ifsell,
                )))
        .then((value) {
      setState(() {});
    });
  }

  navigationTo(context) async {
    var refresh = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewProduct()));
    setState(() {
      reFresh = refresh;
    });
  }

  navigationToSplash() {
    Navigator.pushNamed(context, '/');
  }
}
