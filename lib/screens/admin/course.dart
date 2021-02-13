import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/Details.dart';
import 'package:ocean_live/screens/admin/course/add_course.dart';
import 'package:ocean_live/screens/admin/course/view_course.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class Course extends StatefulWidget {
  static List studentid = [];
  @override
  _CourseState createState() => _CourseState();
}

// Row imageWidget() {
//   return Row(children: [
//     Expanded(
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(15.0),
//         child: Image(
//           image: NetworkImage("$image"),
//           fit: BoxFit.cover,
//         ),
//       ),
//     ),
//   ]);
// }

class _CourseState extends State<Course> {
  void subjectNotify() async {
    await for (var snapshot in _firestore
        .collection('student')
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        print(message.documentID);
        Course.studentid.add(message.documentID);
        print("${Course.studentid}listlistlistttttttttttttttt");
      }
    }
  }

  Map menuColor = {"Online": true, "Offline": false};
  bool menu;
  Color color = Color(0xFF0091D2);
  Widget contentWidget;
  final List<String> elements = [
    "Zero",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "A Million Billion Trillion",
    "A much, much longer text that will still fit"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subjectNotify();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    tab(text: "Online", iconData: FontAwesomeIcons.laptopCode),
                    SizedBox(
                      width: 40,
                    ),
                    tab(text: "Offline", iconData: FontAwesomeIcons.book),
                  ],
                ),
                aCustomButtom(
                    text: "Add new Course",
                    iconData: FontAwesomeIcons.plusCircle,
                    buttonClick: () {
                      contentWidget = AddCourse();
                      Provider.of<Routing>(context, listen: false)
                          .updateRouting(widget: contentWidget);
                    }),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            searchWidget(text: "course"),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: displayCourse(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container displayCourse() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          menuColor['Online']
              ? StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('course').snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading.....");
                    } else {
                      final messages = snapshot.data.docs;
                      List<CourseContent> courseContent = [];

                      for (var message in messages) {
                        final messageImage = message.data()['img'];
                        final messageBatchid = message.data()['batchid'];
                        final messageCourse = message.data()['coursename'];
                        final messagedescription =
                            message.data()['coursedescription'];
                        final courseMode = message.data()['mode'];
                        final courseRate = message.data()['rate'];
                        final coursetrainer = message.data()['trainername'];

                        final course = CourseContent(
                          image: messageImage,
                          coursename: messageCourse,
                          coursedescription: messagedescription,
                          mode: courseMode,
                          rate: courseRate,
                          batchid: messageBatchid,
                          trainername: coursetrainer,
                        );
                        // Text('$messageText from $messageSender');
                        courseContent.add(course);
                      }
                      return Wrap(
                        spacing: 30.0,
                        runSpacing: 30.0,
                        children: courseContent,
                      );
                    }
                  },
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('offline_course').snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading.....");
                    } else {
                      final messages = snapshot.data.docs;
                      List<CourseContent> courseContent = [];

                      for (var message in messages) {
                        final messageImage = message.data()['img'];
                        final messageCourse = message.data()['coursename'];
                        final messagedescription =
                            message.data()['coursedescription'];
                        final courseMode = message.data()['mode'];
                        final courseRate = message.data()['rate'];
                        final course = CourseContent(
                          image: messageImage,
                          coursename: messageCourse,
                          coursedescription: messagedescription,
                          mode: courseMode,
                          rate: courseRate,
                        );
                        // Text('$messageText from $messageSender');
                        courseContent.add(course);
                      }
                      return Wrap(
                        spacing: 30.0,
                        runSpacing: 30.0,
                        children: courseContent,
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }

  Column tab({text, iconData}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: menuColor[text]
                  ? BorderSide(color: color, width: 5)
                  : BorderSide(color: Colors.white),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                menuColor.updateAll((key, value) => menuColor[key] = false);
                menuColor[text] = true;
                menu = menuColor[text];
                print(" $menu $text");
              });
            },
            child: Row(
              children: [
                Container(
                    width: 32,
                    child: Icon(iconData,
                        size: 25,
                        color: menuColor[text] ? color : Color(0xFFB4B4B4))),
                SizedBox(
                  width: 5,
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 16,
                      color: menuColor[text] ? color : Color(0xFFB4B4B4)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

@override
Widget aCustomButtom(
    {text, iconData, fontSize = 20, iconSize = 27, buttonClick}) {
  return RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    onPressed: buttonClick,
    color: Color(0xff0090E9),
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: iconSize,
          ),
          SizedBox(
            width: 5,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 10, top: 15, bottom: 15),
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          ),
        ],
      ),
    ),
  );
}

@override
Widget aSuccessButton(
    {text, iconData, fontSize = 18, iconSize = 23, buttonClick}) {
  return RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    onPressed: buttonClick,
    color: Color(0xFF13C206),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: fontSize),
          ),
          SizedBox(
            width: 8,
          ),
          Icon(
            iconData,
            color: Colors.white,
            size: iconSize,
          ),
        ],
      ),
    ),
  );
}

class CourseContent extends StatefulWidget {
  final String image;
  final String coursename;
  final String coursedescription;
  final String mode;
  final String rate;
  final String batchid;
  final String trainername;
  CourseContent(
      {this.coursename,
      this.image,
      this.coursedescription,
      this.trainername,
      this.mode,
      this.batchid,
      this.rate});

  @override
  _CourseContentState createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Provider.of<Routing>(context, listen: false).updateRouting(
                  widget: ViewCourse(
                course: widget.coursename,
                img: widget.image,
                desc: widget.coursedescription,
                mode: widget.mode,
                rate: widget.rate,
                batchid: widget.batchid,
                trainername: widget.trainername,
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                image: NetworkImage("${widget.image}"),
                width: 500.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "${widget.coursename}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}
