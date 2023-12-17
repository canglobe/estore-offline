import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/ept1.dart';

late Box localdb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // initiate hive database
  localdb = await Hive.openBox('db');
  runApp(const Ept1App(title: 'Ept1'));
}

//