import 'package:flutter/material.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:ocean_live/screens/admin/notification.dart';
import 'package:ocean_live/screens/admin/upcoming_batch.dart';
import 'package:ocean_live/screens/comment.dart';
import 'package:ocean_live/screens/admin/home.dart';
import 'package:ocean_live/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(OceanLive());
}

class OceanLive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Routing(),
      child: MaterialApp(
        home: Scaffold(body: Admin()),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.white),
      ),
    );
    // return MaterialApp(
    //   home: Home(),
    // );
  }
}
