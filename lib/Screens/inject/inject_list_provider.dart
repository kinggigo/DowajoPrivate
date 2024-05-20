import 'package:dowajo/components/models/injectModel.dart';
import 'package:dowajo/database/inject_database.dart';
import 'package:flutter/material.dart';

class InjectListProvider extends ChangeNotifier {
  List<InjectModel> _injects = [];

  List<InjectModel> get injects => _injects;

  void addInject(InjectModel inject) async {
    try {
      _injects = [..._injects, inject];
      await InjectDatabaseHelper.instance.insert(inject);
      notifyListeners();
    } catch (e) {
      print('Error in addInject: $e');
    }
  }

  void getInjectList() async {
    try {
      _injects = await InjectDatabaseHelper.instance.getAllInjects();
      notifyListeners();
    } catch (e) {
      print('Error in getInjectList: $e');
    }
  }
}
