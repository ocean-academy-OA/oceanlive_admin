import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:ocean_live/screens/admin/Details.dart';
import 'package:ocean_live/screens/admin/course/add_course.dart';
import 'package:ocean_live/screens/admin/course/edit_course.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

final _firestore = FirebaseFirestore.instance;

class ViewCourse extends StatefulWidget {
  String trainername;
  String course;
  String img;
  String mode;
  String rate;
  String desc;
  String batchid;
  static String deleteCourse;
  static String deleteSyllabus;

  ViewCourse({
    this.course,
    this.mode,
    this.desc,
    this.img,
    this.rate,
    this.batchid,
    this.trainername,
  });
  @override
  _ViewCourseState createState() => _ViewCourseState();
}

class _ViewCourseState extends State<ViewCourse> {
  var pdfLink;
  String filename;
  Uint8List uploadfile;
  List key = [];
  var collection;
  // void getMessage() async {
  //   collection = await _firestore.collection('online').doc().get();
  //   var collection2 = await _firestore
  //       .collection('online')
  //       .doc("python")
  //       .collection("syllabus")
  //       .get();
  //   collection = collection.data();
  //   print(collection);
  //   for (var courses1 in collection.docs) {
  //     print(courses1.data());
  //   }
  //   for (var courses in collection2.docs) {
  //     print(courses.data());
  //   }
  // }

  IconData iconData;
  bool isVisible = false;

  _ViewCourseState();

  void chapterKey() async {
    await for (var snapshot in _firestore
        .collection('course')
        .doc("Flask")
        .collection("syllabus")
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        key = message.data()["chapter"];
        print(key);

        // setState(() {
        //   StudentDb.paymentId = message.documentID;
        // });
        // print("${StudentDb.paymentId}studentjjjjjjjjjjjjjjjjjjjjjjj");
      }
    }
  }

  void courseId() async {
    await for (var snapshot in _firestore
        .collection('course')
        .where("coursename", isEqualTo: widget.course)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        ViewCourse.deleteCourse = message.documentID;
        print("${ViewCourse.deleteCourse}llllllllll");
        print("${widget.course}jjjjjjjjjjjjj");
        syllabusId();
      }
    }
  }

  void syllabusId() async {
    await for (var snapshot in _firestore
        .collection('course')
        .doc(ViewCourse.deleteCourse)
        .collection("syllabus")
        .where("coursename", isEqualTo: widget.course)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        ViewCourse.deleteSyllabus = message.documentID;
        print("${ViewCourse.deleteSyllabus}syllbbbbbbbbb");
        print("${widget.course}jjjjjjjjjjjjj");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chapterKey();
    courseId();

    // getMessage();
    // var sample = _firestore.collection("online").get();
    // print(sample.d);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: pagePadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              courseHeading(context),
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.course}",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff002C47)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Course Description",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${widget.desc}",
                          style:
                              TextStyle(fontSize: 23, color: Color(0xff707070)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Syllabus",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('course')
                              // .doc(widget.course)
                              .doc(widget.batchid)
                              .collection('syllabus')
                              .snapshots(),
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Loading.....");
                            } else {
                              final messages = snapshot.data.docs;
                              List<CourseDetails> courseDetails = [];

                              //List<String> subjects = [];
                              String messageContent;

                              for (var message in messages) {
                                List<Widget> chapterWidget = [];
                                // if (message.data()['coursename'] == widget.course) {
                                final messageSender =
                                    message.data()[widget.course];
                                final messageImage = message.data()[widget.img];
                                final messageCoursedescription =
                                    message.data()[widget.desc];
                                final messageTopic = message.data()['section'];
                                for (var i = 0;
                                    i < message.data()["chapter"].length;
                                    i++) {
                                  messageContent = message.data()["chapter"][i];
                                  chapterWidget.add(
                                    Text(
                                      "${messageContent}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff555454)),
                                    ),
                                  );
                                  print(messageContent);
                                }

                                final details = CourseDetails(
                                  coursename: messageSender,
                                  image: messageImage,
                                  description: messageCoursedescription,
                                  topic: messageTopic,
                                  chapterWidget: chapterWidget,
                                );

                                courseDetails.add(details);

                                print("test$messages");

                                // }

                              }

                              return Column(
                                children: courseDetails,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            aCustomButtom(
                                text: "Edit Details",
                                iconSize: 25,
                                fontSize: 20,
                                iconData: FontAwesomeIcons.edit,
                                buttonClick: () {
                                  Provider.of<Routing>(context, listen: false)
                                      .updateRouting(
                                          widget: EditCourse(
                                    course: widget.course,
                                    courseImage: widget.img,
                                    batchid: widget.batchid,
                                    rate: widget.rate,
                                    description: widget.desc,
                                    trainername: widget.trainername,
                                  ));
                                }),
                            SizedBox(width: 20),
                            aCustomButtom(
                                text: "Delete Course",
                                iconSize: 25,
                                fontSize: 20,
                                iconData: FontAwesomeIcons.trashAlt,
                                buttonClick: () {
                                  displayDialog(
                                      name: DeleteDetails(
                                        coursename: widget.course,
                                      ),
                                      context: context);
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(
                            image: NetworkImage("${widget.img}"),
                            width: 500,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: 500,
                          decoration: BoxDecoration(
                            color: Color(0xfff2f3f5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          padding: EdgeInsets.all(30),
                          child: Table(
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Uploaded On",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "23/08/2020",
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xff555454)),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Mode of teaching",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "${widget.mode}",
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xff555454)),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Course Fee",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "${widget.rate}",
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xff555454)),
                                  ),
                                )
                              ])
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            aCustomButtom(
                                text: "Upload Syllabus",
                                iconSize: 25,
                                fontSize: 20,
                                iconData: FontAwesomeIcons.edit,
                                buttonClick: () async {
                                  FilePickerResult result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    uploadfile = result.files.single.bytes;
                                    setState(() {
                                      filename =
                                          basename(result.files.single.name);
                                    });
                                    print(filename);
                                  } else {
                                    print('pick pdf');
                                  }
                                  ///////
                                  Future uploadPic(BuildContext context) async {
                                    Reference firebaseStorageRef =
                                        FirebaseStorage.instance
                                            .ref()
                                            .child("Syllabus")
                                            .child(filename);
                                    UploadTask uploadTask =
                                        firebaseStorageRef.putData(uploadfile);
                                    TaskSnapshot taskSnapshot =
                                        await uploadTask.whenComplete(() {
                                      setState(() {
                                        print("Profile Picture uploaded");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Syllabus Picture Uploaded')));
                                        uploadTask.snapshot.ref
                                            .getDownloadURL()
                                            .then((value) {
                                          setState(() {
                                            pdfLink = value;
                                          });

                                          print(pdfLink);
                                          _firestore
                                              .collection("Syllabus")
                                              .add({
                                            "pdflink": pdfLink,
                                          });
                                        });
                                      });
                                    });
                                  }

                                  uploadPic(context);
                                }),
                            SizedBox(width: 20),
                            aCustomButtom(
                                text: "Delete Syllabus",
                                iconSize: 25,
                                fontSize: 20,
                                iconData: FontAwesomeIcons.trashAlt,
                                buttonClick: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetails extends StatefulWidget {
  String coursename;
  String image;
  String topic;
  List<Widget> chapterWidget;

  String rate;
  String description;
  CourseDetails(
      {this.coursename,
      this.image,
      this.topic,
      this.chapterWidget,
      this.description,
      this.rate});

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color(0xfff2f3f5),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: Color(0xff27292A), width: 2)),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.topic}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff555454)),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Icon(isVisible
                    ? FontAwesomeIcons.caretUp
                    : FontAwesomeIcons.caretDown),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Visibility(
          visible: isVisible,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(color: Color(0xff707070))),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.chapterWidget,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
