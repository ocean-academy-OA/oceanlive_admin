import 'package:flutter/material.dart';
import 'package:ocean_live/screens/admin/course.dart';

class Routing extends ChangeNotifier {
  // Widget route = Details(text: "staff");
  Widget route = Course();

  void updateRouting({Widget widget}) {
    route = widget;
    notifyListeners();
  }
}
