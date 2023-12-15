import 'package:estore/constants/constants.dart';
import 'package:estore/utils/size.dart';
import 'package:flutter/material.dart';

Widget customTile(
  context, {
  required String date,
  required String name,
  required String price,
  required String quantity,
}) {
  return SizedBox(
    height: screenSize(context, isHeight: true, percentage: 14),
    width: screenSize(context, percentage: 97),
    child: Card(
      // color: cardBgColor,
      color: const Color.fromRGBO(250, 253, 254, 1),
      elevation: 0.3,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    // color: Colors.black45,
                    color: Color.fromARGB(255, 0, 149, 173),
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  'Qty: $quantity',
                  style: const TextStyle(
                    // color: Colors.black45,
                    color: Color.fromARGB(255, 0, 149, 173),
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                name,
                style: const TextStyle(
                  color: textLightColor,
                  // color: secondryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 14,
                      color: Colors.black54,
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    ),
  );
}
