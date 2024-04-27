import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  late String id;
  late String name;
  late int seed;

  List<String> nombresList = [];
  List<String> idList = [];
  Map<String, Map<String, dynamic>> players = {};

  void forceNotifyListeners() {
    super.notifyListeners();
  }
}
