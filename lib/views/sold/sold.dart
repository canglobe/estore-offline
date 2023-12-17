import 'package:estore/constants/constants.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class SoldScreen extends StatefulWidget {
  const SoldScreen({super.key});

  @override
  State<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: hiveDb.getOverallHistory(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            Map snap = snapshot.data;

            List keys = [];
            snap.forEach((key, value) {
              keys.add(key);
            });

            keys.sort((a, b) => a.compareTo(b));
            keys = keys.reversed.toList();

            return Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String key = keys[index];
                  key =
                      '${key.substring(8, 10)}-${key.substring(5, 7)}-${key.substring(0, 4)}';
                  return Column(
                    children: [
                      Stack(children: [
                        Text(
                          key.toString(),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Divider(
                          indent: screenSize(context,
                              isHeight: false, percentage: 30),
                          color: miniTextColor,
                        ),
                      ]),
                      ListOfSold(
                        keys: keys,
                        innerkeys: snap[keys[index]],
                      ),
                    ],
                  );
                },
                itemCount: snap.length,
              ),
            );
          } else {
            return const Center(
              child: Text('No Data'),
            );
          }
        });
  }
}

class ListOfSold extends StatefulWidget {
  final List keys;
  final List innerkeys;
  const ListOfSold({super.key, required this.keys, required this.innerkeys});

  @override
  State<ListOfSold> createState() => _ListOfSoldState();
}

class _ListOfSoldState extends State<ListOfSold> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9, right: 9),
      child: Column(
          children: List.generate(
        widget.innerkeys.length,
        (index) => customTile(context,
            date: widget.innerkeys[index]['product'].toString(),
            name: widget.innerkeys[index]['name'].toString(),
            price: widget.innerkeys[index]['price'].toString(),
            quantity: widget.innerkeys[index]['quantity'].toString()),
      )),
    );
  }
}
