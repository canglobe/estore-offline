import 'package:estore/hive/hivebox.dart';
import 'package:flutter/material.dart';

String imagePath =
    "/storage/emulated/0/Android/data/com.quantec.estore_offline/files/images/";

const List imgurl = [
  'https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg?w=2000',
  'https://img.freepik.com/free-photo/green-field-tree-blue-skygreat-as-backgroundweb-banner-generative-ai_1258-158251.jpg?w=2000',
  'https://img.freepik.com/premium-photo/suspension-bridge-travel-nature-scenery-building_1417-264.jpg?w=2000',
  'https://img.freepik.com/free-vector/copy-space-bokeh-spring-lights-background_52683-55649.jpg?w=2000',
  'https://img.freepik.com/premium-vector/river-forest-mountains-sunrise-vector-landscape-beautiful-nature-hills-trees-morning_500415-28.jpg?w=2000'
];
Map data = {};

List<String> prnames = <String>[
  'product 1',
  'product 2',
  'product 3',
  'product 4',
  'product 5',
];

List<String> cunames = <String>[
  '',
  'person 1',
  'person 2',
  'person 3',
  'person 4',
  'person 5',
];

TextStyle mystyle(double size,
    {bool bold = false, Color color = Colors.black}) {
  return TextStyle(
      fontSize: size,
      fontWeight: bold != true ? FontWeight.normal : FontWeight.bold,
      color: color);
}

// Main Colors
const primaryColor = Color.fromARGB(255, 0, 189, 213);
const secondryColor = Color.fromARGB(255, 33, 150, 243);
const bgColor = Color.fromARGB(255, 239, 250, 252);
const txtColor = Color.fromARGB(255, 33, 33, 33);
const whitecolor = Colors.white;

// Text Colors Light Theme
const textLightColor = Color.fromARGB(255, 33, 33, 33);
const subTextColor = Color.fromARGB(255, 55, 55, 55);
const miniTextColor = Color.fromARGB(255, 77, 77, 77);

// Text Colors Dark Theme
const textDarkColor = Color.fromARGB(255, 247, 245, 245);

// Additional Color Pallete
const greenColor = Color(0xff8ad979);
const skyblueColor = Color(0xff5bcfc9);
const orangeColor = Color(0xfffa9f43);

// Object for hive database
HiveDB hiveDb = HiveDB();
