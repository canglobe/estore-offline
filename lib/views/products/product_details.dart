// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:estore/constants/constants.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/main.dart';
import 'package:estore/model/overall_history_model.dart';
import 'package:estore/views/products/product_update.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/widgets/custom_tile.dart';
import 'package:estore/widgets/my_widgets.dart';

import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;
  final bool image;
  final String price;
  final String quantity;
  final String productname;
  bool ifsell;

  ProductDetailPage({
    super.key,
    required this.index,
    required this.image,
    required this.quantity,
    required this.productname,
    required this.price,
    required this.ifsell,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  List? persons;
  List<String> names = [];
  String selectedQuantity = '1';
  var numbers = ['1', '2', '3', '4', '5'];

  getData() async {
    var productHistory = await hiveDb.getProductHistory();
    return productHistory[widget.productname];
  }

  getQuantity(productname) async {
    Map productDetails = await hiveDb.getProductDetails();
    String quantity = productDetails[productname]['quantity'];
    return quantity;
  }

  getNames() async {
    List<String> namess = [];
    List customers = await hiveDb.getPersonsNames();
    quantityController.text = selectedQuantity;
    priceController.text =
        await localdb.get('productDetails')[widget.productname]['price'] ?? '';

    for (var element in customers) {
      namess.add(element);
    }
    setState(() {
      persons = customers;
      names = namess;
    });
  }

  @override
  void initState() {
    super.initState();
    getNames();
  }

  save() async {
    // Date
    String date = customTime();
    String dateOnly =
        '${date.substring(0, 4)}-${date.substring(5, 7)}-${date.substring(8, 10)}';

    var customerName = nameController.text;
    var productName = widget.productname;
    var soldPrice = priceController.text;
    var soldQuantity = quantityController.text;

    // get hivedb data's
    Map productHistory = await hiveDb.getProductHistory();
    Map personsHistory = await hiveDb.getPersonsHistory();
    Map productDetails = await hiveDb.getProductDetails();
    List customers = await hiveDb.getPersonsNames();

    if (!customers.contains(customerName)) {
      customers.add(customerName);
      await hiveDb.putPersonsNames(customers);
    } else {
      // nothing do here
    }

    if (!productHistory.containsKey(productName)) {
      productHistory[productName] = {};
      productHistory[productName][date] = {
        'customer': customerName,
        'quantity': soldQuantity,
        'price': soldPrice,
      };
      await hiveDb.putProductHistory(productHistory);
    } else {
      productHistory[productName][date] = {
        'customer': customerName,
        'quantity': soldQuantity,
        'price': soldPrice,
      };

      await hiveDb.putProductHistory(productHistory);
    }

    if (!personsHistory.containsKey(customerName)) {
      personsHistory[customerName] = {};
      personsHistory[customerName][date] = {
        'product': widget.productname,
        'quantity': quantityController.text,
        'price': priceController.text,
      };
      await hiveDb.putPersonsHistory(personsHistory);
    } else {
      personsHistory[customerName][date] = {
        'product': productName,
        'quantity': soldQuantity,
        'price': soldPrice,
      };
      await hiveDb.putPersonsHistory(personsHistory);
    }

    var quantity = productDetails[widget.productname]['quantity'];
    int qty = int.parse(quantity) - int.parse(quantityController.text);
    productDetails[widget.productname]['quantity'] = qty.toString();
    await hiveDb.putProductDetails(productDetails);

    Map overallHistory = await hiveDb.getOverallHistory();

    if (!overallHistory.containsKey(dateOnly)) {
      overallHistory[dateOnly] = [];
      overallHistory[dateOnly].add(
        OverallHistoryModel(
                customer: nameController.text,
                product: widget.productname,
                price: priceController.text,
                quantity: quantityController.text)
            .toMap(),
      );
      await hiveDb.putOverallHistory(overallHistory);
    } else {
      overallHistory[dateOnly].add(
        OverallHistoryModel(
          customer: nameController.text,
          product: widget.productname,
          price: priceController.text,
          quantity: quantityController.text,
        ).toMap(),
      );
      await hiveDb.putOverallHistory(overallHistory);
    }

    setState(() {
      widget.ifsell = false;
    });
  }

  deleteHistory(index, keys, snap) async {
    Map productHistory = await hiveDb.getProductHistory();
    var personsHistory = await hiveDb.getPersonsHistory();
    var productdetails = await hiveDb.getProductDetails();

    Map history = productHistory[widget.productname];
    var customer = history[keys[index]]['customer'];
    var quant = history[keys[index]]['quantity'];

    var qty = productdetails[widget.productname]['quantity'];

    var newqty = int.parse(qty) + int.parse(quant);
    productdetails[widget.productname]['quantity'] = newqty.toString();

    Map history1 = personsHistory[customer];
    history1.remove(keys[index]);
    history.remove(keys[index]);
    personsHistory[customer] = history1;
    productHistory[widget.productname] = history;
    await hiveDb.putPersonsHistory(productHistory);
    await hiveDb.putPersonsHistory(personsHistory);
    await hiveDb.putProductDetails(productdetails);
    snap.remove(keys[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          title: Text(
            widget.productname,
          ),
          actions: [
            !widget.ifsell
                ? IconButton(
                    onPressed: () async {
                      var refresh =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductUpdate(
                                    productname: widget.productname,
                                    price: widget.price,
                                    quantity: widget.quantity,
                                    image: widget.image,
                                  )));

                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.edit_document,
                      color: Colors.white,
                    ),
                    tooltip: 'Update',
                  )
                : const Center(),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 3,
                child: widget.ifsell != true ? _sellHistory() : _sell(context)),
          ],
        ),
        floatingActionButton: _fab(context));
  }

  _sellHistory() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 500,
            child: Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder(
                    future: getQuantity(widget.productname),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return snapshot.hasData
                          ? Text(
                              'Current Stock: ${snapshot.data.toString()}',
                              style: Theme.of(context).textTheme.displayLarge,
                            )
                          : const SizedBox();
                    }),
              ],
            ),
          ),
        ),
        const Divider(),
        _history(),
      ],
    );
  }

  _history() {
    return Expanded(
      flex: 9,
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List keys = [];
            Map snap = snapshot.data;

            // snap.forEach((key, value) {
            //   keys.contains(key) ? print(key) : keys.add(key);
            // });

            for (String x in snap.keys) {
              keys.add(x);
              if (keys.contains(x)) {
                //
              } else {
                keys.add(x);
              }
            }
            keys.sort();
            keys = keys.reversed.toList();
            return Padding(
              padding: const EdgeInsets.only(left: 9, right: 9),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String key = keys[index];
                  key =
                      '${key.substring(8, 10)}-${key.substring(5, 7)}-${key.substring(0, 4)}';

                  return Dismissible(
                      key: ValueKey(keys[index]),
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      "DELETE",
                                      style: TextStyle(color: Colors.redAccent),
                                    )),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        deleteHistory(index, keys, snap);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          customTile(context,
                              date: ' $key',
                              name: snap[keys[index]]['customer'],
                              price: snap[keys[index]]['price'].toString(),
                              quantity: snap[keys[index]]['quantity']),
                        ],
                      ));
                },
                itemCount: keys.length,
              ),
            );
          } else {
            return const Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info),
                SizedBox(
                  width: 3,
                ),
                Text('Still Product Was Not Sell'),
              ],
            ));
          }
        },
      ),
    );
  }

  _fab(context) {
    return widget.ifsell != true
        ? FloatingActionButton.extended(
            onPressed: () async {
              quantityController.text = selectedQuantity;
              priceController.text = await localdb
                      .get('productDetails')[widget.productname]['price'] ??
                  '';

              setState(() {
                widget.ifsell = true;
              });
            },
            label: Text(
              'Sell',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          )
        : const Center();
  }

  _sell(context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              RawAutocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return names.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Customer Name',
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(15),
                        width: 18,
                        child: const Icon(Icons.person),
                      ),
                    ),
                    focusNode: focusNode,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                      nameController.text = textEditingController.text;
                    },
                    onChanged: (value) {
                      nameController.text = value;
                    },
                  );
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                                nameController.text = option;
                              },
                              child: ListTile(
                                title: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.currency_rupee_rounded),
                      ),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 1,
                    child: DropdownMenu(
                      width:
                          screenSize(context, isHeight: false, percentage: 43),
                      initialSelection: numbers[0],
                      label: const Text('Quantity'),
                      dropdownMenuEntries: numbers.map((e) {
                        return DropdownMenuEntry(value: e, label: e);
                      }).toList(),
                      leadingIcon: const Icon(Icons.keyboard),
                      onSelected: (value) {
                        setState(() {
                          selectedQuantity = value!;
                          quantityController.text = selectedQuantity;
                        });
                      },
                      textStyle: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myButton(
                      onPressed: () async {
                        setState(() {
                          widget.ifsell = false;
                        });
                      },
                      child: myText(
                        text: 'Back',
                        size: 20.0,
                      )),
                  myButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty) {
                          save();
                        } else {}
                      },
                      child: myText(
                        text: 'Sell',
                        size: 20.0,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
