import 'package:estore/constants/constants.dart';
import 'package:estore/dummydata.dart';
import 'package:estore/utils/size.dart';
import 'package:flutter/material.dart';

class SoldScreen extends StatefulWidget {
  const SoldScreen({super.key});

  @override
  State<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen> {
  late List dates;
  @override
  void initState() {
    dates = solded.keys.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: hiveDb.getOverallHistory(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            Map snap = snapshot.data;
            print('snap: $snap');

            List keys = [];
            snap.forEach((key, value) {
              keys.add(key);
            });
            // keys = keys.reversed.toList();
            print(keys);

            return ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Stack(children: [
                      Text([keys[index]].toString()),
                      Divider(
                        indent: screenSize(context,
                            isHeight: false, percentage: 30),
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
    print('follow');
    print(widget.keys);
    print(widget.innerkeys);
    return SizedBox(
      height: widget.innerkeys.length * 100,
      child: ListView.builder(
          itemCount: widget.innerkeys.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ListTile(
                tileColor: Colors.amber,
                isThreeLine: true,
                title: Text(widget.innerkeys[index]['name'].toString()),
                subtitle: Text(widget.innerkeys[index]['price'].toString()),
                trailing: Text(widget.innerkeys[index]['quantity'].toString()),
              ),
            );
          }),
    );
  }
}
