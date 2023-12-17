import 'package:estore/main.dart';

// Object for hive database
HiveDB hiveDb = HiveDB();

class HiveDB {
  // Theme mode
  Future<bool> getThemeMode() async {
    bool mode = await localdb.get('darkMode') ?? false;
    return mode;
  }

  putThemeMode(data) async {
    await localdb.put('darkMode', data);
  }

  // Products
  getProductNames() async {
    List data = await localdb.get('productNames') ?? [];

    return data;
  }

  putProductNames(data) async {
    await localdb.put('productNames', data);
  }

  getProductHistory() async {
    Map data = await localdb.get('productHistory') ?? {};
    return data;
  }

  putProductHistory(data) async {
    await localdb.put('productHistory', data);
  }

  getProductDetails() async {
    Map data = await localdb.get('productDetails') ?? {};
    return data;
  }

  putProductDetails(data) async {
    await localdb.put('productDetails', data);
  }

  // customers
  getPersonsHistory() async {
    Map data = await localdb.get('customersHistory') ?? {};
    return data;
  }

  putPersonsHistory(data) async {
    await localdb.put('customersHistory', data);
  }

  getPersonsNames() async {
    List data = await localdb.get('customers') ?? [];

    return data;
  }

  putPersonsNames(data) async {
    await localdb.put('customers', data);
  }

  // Overall history
  getOverallHistory() async {
    Map data = await localdb.get('overallHistory') ?? {};
    return data;
  }

  putOverallHistory(data) async {
    await localdb.put('overallHistory', data);
  }
  // ------------------------------------------------------
}
