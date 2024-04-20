import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  late String id;
  late String name;

  List<String> nombresList = [];
  List<String> idList = [];

  void forceNotifyListeners() {
    super.notifyListeners();
  }
}
