import 'package:estore/constants/constants.dart';
import 'package:estore/main.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/views/base.dart';
import 'package:estore/widgets/custom_tile.dart';
import 'package:estore/widgets/widgets.dart';

import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String person;
  final bool ifsell;

  const CustomerDetailsScreen({
    super.key,
    required this.person,
    required this.ifsell,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  String selectedQuantity = '1';
  String err = '';
  List? products;
  String? selectedproduct;
  List<String> numbers = ['1', '2', '3', '4', '5'];
  bool? ifsell;

  getData() async {
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    quantityController.text = selectedQuantity;

    return personsHistory;
  }

  productsList() async {
    List productNames = [];
    Map productdetails = await hiveDb.getProductDetails();
    productdetails.forEach(
      (key, value) {
        productNames.add(key);
      },
    );
    priceController.text =
        await localdb.get('productDetails')[productNames[0]]['price'] ?? '';
    setState(() {
      products = productNames;
      selectedproduct = productNames.isNotEmpty ? productNames[0] : '';
    });
  }

  save() async {
    Map productHistory = await localdb.get('productHistory') ?? {};
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    String date = customTime();

    if (!productHistory.containsKey(selectedproduct)) {
      productHistory[selectedproduct] = {};
      productHistory[selectedproduct][date] = {
        'person': widget.person,
        'quantity': quantityController.text,
        'price': priceController.text,
      };
      await localdb.put('productHistory', productHistory);
    } else {
      productHistory[selectedproduct][date] = {
        'person': widget.person,
        'quantity': quantityController.text,
        'price': priceController.text,
      };
      await localdb.put('productHistory', productHistory);
    }

    if (!personsHistory.containsKey(widget.person)) {
      personsHistory[widget.person] = {};
      personsHistory[widget.person][date] = {
        'product': selectedproduct,
        'quantity': quantityController.text,
        'price': priceController.text,
      };
      await localdb.put('personsHistory', personsHistory);
    } else {
      personsHistory[widget.person][date] = {
        'product': selectedproduct,
        'quantity': quantityController.text,
        'price': priceController.text,
      };
      await localdb.put('personsHistory', personsHistory);
    }

    String dateOnly =
        '${date.substring(0, 4)}-${date.substring(5, 7)}-${date.substring(8, 10)}';
    Map overallHistory = await hiveDb.getOverallHistory();

    if (!overallHistory.containsKey(dateOnly)) {
      overallHistory[dateOnly] = [];
      overallHistory[dateOnly].add({
        'name': widget.person,
        'product': selectedproduct,
        'price': priceController.text,
        'quantity': quantityController.text,
      });
      await hiveDb.putOverallHistory(overallHistory);
    } else {
      overallHistory[dateOnly].add({
        'name': widget.person,
        'product': selectedproduct,
        'price': priceController.text,
        'quantity': quantityController.text,
      });
      await hiveDb.putOverallHistory(overallHistory);
    }

    Map productDetails = await localdb.get('productDetails') ?? {};
    var quantity = productDetails[selectedproduct]['quantity'];
    int qty = int.parse(quantity) - int.parse(quantityController.text);
    productDetails[selectedproduct]['quantity'] = qty.toString();
    await localdb.put('productDetails', productDetails);
  }

  deleteHistory(index, keys, snap) async {
    Map productdetails = await hiveDb.getProductDetails();
    Map productHistory = await localdb.get('productHistory') ?? {};

    Map personsHistory = await localdb.get('personsHistory') ?? {};
    Map history = personsHistory[widget.person];
    var product = history[keys[index]]['product'];

    bool avl = productdetails.containsKey(product);

    var quant = history[keys[index]]['quantity'];
    if (avl) {
      var qty = productdetails[product]['quantity'];

      var newqty = int.parse(qty) + int.parse(quant);
      productdetails[product]['quantity'] = newqty.toString();
    }
    Map historypr = productHistory[product];

    historypr.remove(keys[index]);
    history.remove(keys[index]);

    productHistory[product] = historypr;
    personsHistory[widget.person] = history;

    await localdb.put('productHistory', productHistory);
    await localdb.put('personsHistory', personsHistory);
    avl ? await hiveDb.putProductDetails(productdetails) : '';
    snap.remove(keys[index]);
  }

  @override
  void initState() {
    productsList();
    ifsell = widget.ifsell;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person),
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Are you sure you wish to delete this customer?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              List personsNames =
                                  await localdb.get('personsNames') ?? [];

                              personsNames.remove(widget.person);

                              await localdb.put('personsNames', personsNames);

                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (c) => false);
                            },
                            child: const Text(
                              "DELETE",
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            )),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("CANCEL"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          ifsell != true
              ? _sellHistory()
              : products!.isNotEmpty
                  ? _sell(context)
                  : _addProduct(),
        ],
      ),
      floatingActionButton: _fab(context),
    );
  }

  _sell(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   'Sell ',
        //   style: Theme.of(context).textTheme.headlineSmall,
        // ),
        // const Divider(),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          child: DropdownMenu(
            width: screenSize(context, isHeight: false, percentage: 95),
            initialSelection: products![0],
            label: Text(
              'Product Name',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            dropdownMenuEntries:
                products!.map<DropdownMenuEntry<String>>((value) {
              return DropdownMenuEntry<String>(
                value: value,
                label: value,
              );
            }).toList(),
            onSelected: (value) async {
              priceController.text = await localdb
                      .get('productDetails')[selectedproduct]['price'] ??
                  '';
              setState(() {
                selectedproduct = value as String?;
              });
            },
            textStyle: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        Padding(
          padding: const EdgeInsets.all(7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 1,
                child: DropdownMenu(
                  width: screenSize(context, isHeight: false, percentage: 43),
                  initialSelection: numbers[0],
                  label: const Text('Quantity'),
                  dropdownMenuEntries: numbers.map((e) {
                    return DropdownMenuEntry(value: e, label: e);
                  }).toList(),
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
        ),
        const SizedBox(
          height: 45,
        ),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            myButton(
                onPressed: () {
                  setState(() {
                    ifsell = false;
                  });
                },
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.labelLarge,
                )),
            myButton(
                onPressed: () {
                  save();
                  setState(() {
                    ifsell = false;
                  });
                },
                child: Text(
                  'Sell',
                  style: Theme.of(context).textTheme.labelLarge,
                )),
          ],
        ),
        const SizedBox(
          height: 45,
        ),
      ],
    );
  }

  _addProduct() {
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BaseScreen()));
          },
          child: const Text('First add any one of product')),
    );
  }

  _sellHistory() {
    return Expanded(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              snapshot.data.isNotEmpty &&
              snapshot.data[widget.person] != null) {
            List keys = [];
            Map snap = snapshot.data[widget.person];

            for (var x in snap.keys) {
              keys.add(x);
            }

            keys.sort();
            keys = keys.reversed.toList();

            return Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String key = keys[index];
                  key =
                      '${key.substring(8, 10)}-${key.substring(5, 7)}-${key.substring(2, 4)}';
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
                                  child: const Text("DELETE")),
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
                            name: snap[keys[index]]['product'],
                            price: snap[keys[index]]['price'].toString(),
                            quantity: snap[keys[index]]['quantity']),
                        // const Divider(),
                      ],
                    ),
                  );
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
                Text(
                  'Still Product Was Not Sell',
                  // style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ));
          }
        },
      ),
    );
  }

  _fab(context) {
    return ifsell != true
        ? FloatingActionButton.extended(
            onPressed: () async {
              setState(() {
                ifsell = true;
              });
            },
            label: Text(
              'Sell',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        : const Center();
  }

  // _sell(context) {
  //   return SingleChildScrollView(
  //     child: Card(
  //       elevation: 0,
  //       child: Padding(
  //         padding: const EdgeInsets.all(5),
  //         child: Column(
  //           children: [
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             RawAutocomplete<String>(
  //               optionsBuilder: (TextEditingValue textEditingValue) {
  //                 return products!.where((String option) {
  //                   return option.contains(textEditingValue.text.toLowerCase());
  //                 });
  //               },
  //               fieldViewBuilder: (
  //                 BuildContext context,
  //                 TextEditingController textEditingController,
  //                 FocusNode focusNode,
  //                 VoidCallback onFieldSubmitted,
  //               ) {
  //                 return TextFormField(
  //                   controller: textEditingController,
  //                   decoration: InputDecoration(
  //                     border: const OutlineInputBorder(),
  //                     labelText: 'Customer Name',
  //                     prefixIcon: Container(
  //                       padding: const EdgeInsets.all(15),
  //                       width: 18,
  //                       child: const Icon(Icons.person),
  //                     ),
  //                   ),
  //                   focusNode: focusNode,
  //                   onTapOutside: (event) {
  //                     FocusManager.instance.primaryFocus?.unfocus();
  //                   },
  //                   onFieldSubmitted: (String value) {
  //                     onFieldSubmitted();
  //                     nameController.text = textEditingController.text;
  //                   },
  //                   onChanged: (value) {
  //                     nameController.text = value;
  //                   },
  //                 );
  //               },
  //               optionsViewBuilder: (
  //                 BuildContext context,
  //                 AutocompleteOnSelected<String> onSelected,
  //                 Iterable<String> options,
  //               ) {
  //                 return Align(
  //                   alignment: Alignment.topLeft,
  //                   child: Material(
  //                     elevation: 4.0,
  //                     child: SizedBox(
  //                       height: 200.0,
  //                       child: ListView.builder(
  //                         padding: const EdgeInsets.all(8.0),
  //                         itemCount: options.length,
  //                         itemBuilder: (BuildContext context, int index) {
  //                           final String option = options.elementAt(index);
  //                           return GestureDetector(
  //                             onTap: () {
  //                               onSelected(option);
  //                               nameController.text = option;
  //                             },
  //                             child: ListTile(
  //                               title: Text(option),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             const SizedBox(
  //               height: 23,
  //             ),
  //             Row(
  //               children: [
  //                 Flexible(
  //                   flex: 1,
  //                   child: TextField(
  //                     controller: priceController,
  //                     decoration: const InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       labelText: 'Price',
  //                       prefixIcon: Icon(Icons.currency_rupee_rounded),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 5,
  //                 ),
  //                 Flexible(
  //                   flex: 1,
  //                   child: DropdownMenu(
  //                     width:
  //                         screenSize(context, isHeight: false, percentage: 43),
  //                     initialSelection: numbers[0],
  //                     label: const Text('Quantity'),
  //                     dropdownMenuEntries: numbers.map((e) {
  //                       return DropdownMenuEntry(value: e, label: e);
  //                     }).toList(),
  //                     onSelected: (value) {
  //                       setState(() {
  //                         selectedQuantity = value!;
  //                         quantityController.text = selectedQuantity;
  //                       });
  //                     },
  //                     textStyle: Theme.of(context).textTheme.displaySmall,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 23,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 myButton(
  //                     onPressed: () async {
  //                       setState(() {
  //                         widget.ifsell = false;
  //                       });
  //                     },
  //                     child: myText(
  //                       text: 'Back',
  //                       size: 20.0,
  //                     )),
  //                 myButton(
  //                     onPressed: () async {
  //                       if (nameController.text.isNotEmpty) {
  //                         save();
  //                       } else {}
  //                     },
  //                     child: myText(
  //                       text: 'Sell',
  //                       size: 20.0,
  //                     )),
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
