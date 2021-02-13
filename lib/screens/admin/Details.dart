import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/batch_schedule.dart';
import 'package:ocean_live/screens/admin/batch_syllabus.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ocean_live/screens/admin/course/add_course.dart';
import 'package:ocean_live/screens/admin/course/view_course.dart';
import 'package:ocean_live/screens/admin/upcoming_batch.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'notification/send_notification.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
int flag = 0;

class Details extends StatelessWidget {
  List<String> heading = [];
  List<Widget> head = [];
  Details({
    @required this.text,
  }) {
    heading.clear();
    if (text.toLowerCase() == "staff") {
      head.add(HeadingWidget(
        text: "Photo",
      ));
      head.add(HeadingWidget(
        text: "Staff Name",
      ));
      head.add(HeadingWidget(
        text: "Mobile Number",
      ));
      head.add(HeadingWidget(
        text: "Email Id",
      ));
      head.add(HeadingWidget(
        text: "DOB",
      ));
      head.add(HeadingWidget(
        text: "DOJ",
      ));
      head.add(HeadingWidget(
        text: "Address",
      ));
      head.add(HeadingWidget(
        text: "Qualification",
      ));
      head.add(HeadingWidget(
        text: "",
      ));
    } else if (text.toLowerCase() == "student") {
      head.add(HeadingWidget(
        text: "Photo",
      ));
      head.add(HeadingWidget(
        text: "Student Name",
      ));
      head.add(HeadingWidget(
        text: "Mobile Number",
      ));
      head.add(HeadingWidget(
        text: "Email Id",
      ));
      head.add(HeadingWidget(
        text: "DOB",
      ));
      head.add(HeadingWidget(
        text: "Course",
      ));
      head.add(HeadingWidget(
        text: "Address",
      ));
      head.add(HeadingWidget(
        text: "Qualification",
      ));
      head.add(HeadingWidget(
        text: "",
      ));
    } else {
      head.add(HeadingWidget(
        text: "Student Name",
      ));
      head.add(HeadingWidget(
        text: "Total Amount",
      ));
      head.add(HeadingWidget(
        text: "Amount Paid",
      ));
      head.add(HeadingWidget(
        text: "Due Amount",
      ));
      head.add(HeadingWidget(
        text: "Paid Date",
      ));
      head.add(HeadingWidget(
        text: "Next Payment Date",
      ));
      head.add(HeadingWidget(
        text: "Payment Mode",
      ));
      head.add(HeadingWidget(
        text: "Payment Mode",
        isvisible: false,
      ));
    }
  }

  final String text;

  @override
  Widget build(BuildContext context) {
    flag = (text.toLowerCase() == "staff")
        ? 1
        : (text.toLowerCase() == "student")
            ? 2
            : 3;

    return
        //
        BatchSchedule();
    Expanded(
      flex: 6,
      child: Padding(
        padding: pagePadding,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  searchWidget(text: text),
                  SizedBox(
                    width: 200.0,
                  ),
                  aCustomButtom(
                      text: "Upload new",
                      iconData: FontAwesomeIcons.plusCircle,
                      buttonClick: () {
                        displayDialog(
                            name: flag == 1
                                ? UpdateStaffDetails()
                                : flag == 2
                                    ? UpdateStudentDetails()
                                    : UpdatePayment(),
                            context: context);
                      }),
                ],
              ),
              Table(
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFDFDFDF), width: 1),
                      ),
                    ),
                    children: head,
                  ),
                ],
              ),
              TableWidget(
                title: heading,
              ),
            ],
          ),
        ),
      ),
    );

    BatchSyllebus();
  }
}

Container searchWidget({String text}) {
  if (!text.startsWith("c")) {
    text += " Details";
  }
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    width: 907,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xFFF2F3F5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Search ${text[0].toUpperCase() + text.substring(1).toLowerCase()}",
          style: TextStyle(
              color: Color(0xFF555454),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        Row(
          children: [
            DropDownWidget(),
            SizedBox(
              width: 25,
            ),
            Icon(FontAwesomeIcons.search),
          ],
        ),
      ],
    ),
  );
}

class DropDownWidget extends StatefulWidget {
  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String dropdownValue = 'Search By';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      width: 200,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(FontAwesomeIcons.angleDown),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: Color(0XFF555454),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Search By', 'Course', 'Name', 'Date']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                width: 150,
                child: Text(
                  value,
                  style: TextStyle(
                      fontWeight: value == "Search By"
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

Widget dynamicSizeButton({text, onPress}) {
  return SizedBox(
    child: RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      color: Color(0xFF0090E9),
    ),
  );
}

Widget button({text, onPress, fontSize = 20, paddingSize = 10, width = 130}) {
  return SizedBox(
    width: width,
    child: RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPress,
      child: Padding(
        padding: EdgeInsets.all(paddingSize),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
      color: Color(0xFF0090E9),
    ),
  );
}

Widget outlinebutton(
    {text, onPress, fontSize = 20, paddingSize = 10, width = 130}) {
  return SizedBox(
    width: width,
    child: RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.blue, width: 4),
      ),
      onPressed: onPress,
      child: Padding(
        padding: EdgeInsets.all(paddingSize),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    ),
  );
}

class DeleteDetails extends StatefulWidget {
  DeleteDetails(
      {this.trainername,
      this.email,
      this.address,
      this.dateofbirth,
      this.dateofjoining,
      this.mobilenumber,
      this.qualification,
      this.trainerImage,
      this.studentImage,
      this.studentname,
      this.coursename});
  String trainername;
  String address;
  String mobilenumber;
  String email;
  String qualification;
  String dateofbirth;
  String dateofjoining;
  String trainerImage;
  String studentImage;
  String studentname;
  String coursename;
  @override
  _DeleteDetailsState createState() => _DeleteDetailsState();
}

class _DeleteDetailsState extends State<DeleteDetails> {
  String deleteStaff;
  String deleteStudent;

  String deleteSubpay;
  void messageStream() async {
    await for (var snapshot in _firestore
        .collection('staff')
        .where("trainerimage", isEqualTo: widget.trainerImage)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        deleteStaff = message.documentID;
        print(deleteStaff);
      }
    }
  }

  void studentId() async {
    await for (var snapshot in _firestore
        .collection('student')
        .where("studentimage", isEqualTo: widget.coursename)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        deleteStudent = message.documentID;
        print(deleteStudent);
      }
    }
  }

  String deletePayment;
  void payId() async {
    await for (var snapshot in _firestore
        .collection('student')
        .where("studentname", isEqualTo: widget.studentname)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        deletePayment = message.documentID;
        print("${deletePayment}ppppppppppppppp");
        print("${widget.studentname}nnnnnnnnnnnnn");

        await for (var variable in _firestore
            .collection('student')
            .doc(deletePayment)
            .collection("payment")
            .snapshots(includeMetadataChanges: true)) {
          for (var message in variable.docs) {
            print(message.documentID);
            deleteSubpay = message.documentID;
            print("${deleteSubpay}deleteeee");
            print("jaya");
          }
        }
      }
    }
  }

  // void subcourseId() async {
  //   await for (var snapshot in _firestore
  //       .collection('student')
  //       .doc(deletePayment)
  //       .collection("payment")
  //       .snapshots(includeMetadataChanges: true)) {
  //     for (var message in snapshot.docs) {
  //       print(message.documentID);
  //       deleteSubpay = message.documentID;
  //       print("${deleteSubpay}deleteeee");
  //       print("${deleteCourse}deleteeee");
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // messageStream();
    // studentId();
    payId();

    // courseId();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.trashAlt,
            size: 90,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Are you Sure want to delete this ?",
            style: TextStyle(fontSize: 30, color: Color(0xFF464646)),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              button(
                  text: "No",
                  onPress: () {
                    print("deleted");
                    print("deleted${ViewCourse.deleteCourse}");

                    Navigator.pop(context);
                  }),
              SizedBox(
                width: 10,
              ),
              outlinebutton(
                  text: "Yes",
                  onPress: () {
                    studentId();

                    flag == 1
                        ? setState(() {
                            Navigator.pop(this.context);
                            setState(() {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(content: Text('Staff Deleted')));
                            });
                            _firestore
                                .collection("staff")
                                .doc(deleteStaff)
                                .delete();
                          })
                        : flag == 2
                            ? setState(() {
                                Navigator.pop(this.context);
                                setState(() {
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(SnackBar(
                                          content: Text('student  Deleted')));
                                  print(deleteStaff);
                                });
                                _firestore
                                    .collection("student")
                                    .doc(deleteStudent)
                                    .delete();
                              })
                            : flag == 3
                                ? setState(() {
                                    Navigator.pop(this.context);
                                    setState(() {
                                      print("Profile Picture uploaded");
                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('payment Deleted')));
                                    });
                                    _firestore
                                        .collection("student")
                                        .doc(deletePayment)
                                        .collection("payment")
                                        .doc(deleteSubpay)
                                        .delete();
                                  })
                                : setState(() {
                                    Navigator.pop(this.context);
                                    setState(() {
                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(SnackBar(
                                              content: Text('course Deleted')));
                                    });
                                    _firestore
                                        .collection("course")
                                        .doc(ViewCourse.deleteCourse)
                                        .delete();
                                    _firestore
                                        .collection("course")
                                        .doc(ViewCourse.deleteCourse)
                                        .collection("syllabus")
                                        .doc(ViewCourse.deleteSyllabus)
                                        .delete();
                                  });

                    print(" course Deleted");
                    print(ViewCourse.deleteCourse);
                    print("${deleteSubpay}deleteeee");
                    print("${deletePayment}deleteeee");
                  })
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateStudentDetails extends StatefulWidget {
  @override
  _UpdateStudentDetailsState createState() => _UpdateStudentDetailsState();
}

class _UpdateStudentDetailsState extends State<UpdateStudentDetails> {
  var studentId = 0;
  var studentLink;
  String filename;
  Uint8List uploadfile;

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController courseEnrool = TextEditingController();
  TextEditingController qual = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController college = TextEditingController();
  TextEditingController expreience = TextEditingController();
  TextEditingController designation = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Add Student Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                closeIcon(context),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      "${studentLink}",
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: GestureDetector(
                      child: UploadImage(
                        size: 12,
                      ),
                      onTap: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          uploadfile = result.files.single.bytes;
                          setState(() {
                            filename = basename(result.files.single.name);
                          });
                          print(filename);
                        } else {
                          print('pick imafe');
                        }
                        ///////
                        Future uploadPic(BuildContext context) async {
                          Reference firebaseStorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child("student")
                              .child(filename);
                          UploadTask uploadTask =
                              firebaseStorageRef.putData(uploadfile);
                          TaskSnapshot taskSnapshot =
                              await uploadTask.whenComplete(() {
                            setState(() {
                              print("Profile Picture uploaded");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Staff Picture Uploaded')));
                              uploadTask.snapshot.ref
                                  .getDownloadURL()
                                  .then((value) {
                                setState(() {
                                  studentLink = value;
                                });

                                print(studentLink);
                              });
                            });
                          });
                        }

                        uploadPic(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heading(text: "Name"),
                    TextField(
                      controller: name,
                      decoration: customDecor(),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Mobile Number"),
              ),
              Expanded(
                child: _heading(text: "Email Id"),
              ),
              Expanded(
                child: _heading(text: "DOB"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: mobile,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: email,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: dob,
                  decoration: customIconDecor(
                      icon: Icon(FontAwesomeIcons.calendarAlt),
                      context: context),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Address"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                  child: TextField(
                controller: address,
                decoration: customDecor(),
              )),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Courses Enrolled"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                  child: TextField(
                controller: courseEnrool,
                decoration: customDecor(),
              )),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Occupation"),
              ),
              Expanded(
                child: _heading(text: "College/Institution"),
              ),
              Expanded(
                child: _heading(text: "Qualification"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: occupation,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: college,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: qual,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Working Experience"),
              ),
              Expanded(
                child: _heading(text: "Designation"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: expreience,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: designation,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dynamicSizeButton(
                  text: "Save Details",
                  onPress: () {
                    _firestore.collection("student").add({
                      "studentname": name.text,
                      "address": address.text,
                      "mobileNumber": mobile.text,
                      "email": email.text,
                      "qualification": qual.text,
                      "dateofbirth": dob.text,
                      "courseenrool": courseEnrool.text,
                      "studentimage": studentLink,
                      "occupation": occupation.text,
                      "university": college.text,
                      "experience": expreience.text,
                      "designation": designation.text,
                    });
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

Text _heading({text}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 18, color: Color(0xFF555454), fontWeight: FontWeight.w600),
  );
}

class UpdateStaffDetails extends StatefulWidget {
  @override
  _UpdateStaffDetailsState createState() => _UpdateStaffDetailsState();
}

class _UpdateStaffDetailsState extends State<UpdateStaffDetails> {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController qual = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController doj = TextEditingController();
  TextEditingController addr = TextEditingController();

  bool isName = false, isMobile = false, isEmail = false;
  var id = 0;
  var staffLink;
  String filename;
  Uint8List uploadfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Edit Staff Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 50,
                ),
                closeIcon(context),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Name"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _heading(text: "Mobile Number"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[A-Za-z ]{1,32}"))
                      ],
                      decoration: customDecor(),
                    ),
                    toggleError(isName),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]{1,10}'))
                      ],
                      controller: mobile,
                      decoration: customDecor(),
                    ),
                    toggleError(isMobile)
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Email Id"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _heading(text: "Qualification"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: email,
                      decoration: customDecor(),
                    ),
                    toggleError(isEmail)
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: qual,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "DOB"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _heading(text: "DOJ"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: dob,
                  decoration: customIconDecor(
                      icon: Icon(FontAwesomeIcons.calendarAlt),
                      context: context),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: doj,
                    decoration: customIconDecor(
                        icon: Icon(FontAwesomeIcons.calendarAlt),
                        context: context),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                flex: 2,
                child: _heading(text: "Address"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: TextField(
                      controller: addr,
                      decoration: customDecor(),
                    ),
                  )),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "${staffLink}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: GestureDetector(
                        child: UploadImage(
                          size: 12,
                        ),
                        onTap: () async {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            uploadfile = result.files.single.bytes;
                            setState(() {
                              filename = basename(result.files.single.name);
                            });
                            print(filename);
                          } else {
                            print('pick imafe');
                          }
                          ///////
                          Future uploadPic(BuildContext context) async {
                            Reference firebaseStorageRef = FirebaseStorage
                                .instance
                                .ref()
                                .child("Staff")
                                .child(filename);
                            UploadTask uploadTask =
                                firebaseStorageRef.putData(uploadfile);
                            TaskSnapshot taskSnapshot =
                                await uploadTask.whenComplete(() {
                              setState(() {
                                print("Profile Picture uploaded");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Staff Picture Uploaded')));
                                uploadTask.snapshot.ref
                                    .getDownloadURL()
                                    .then((value) {
                                  setState(() {
                                    staffLink = value;
                                  });

                                  print(staffLink);
                                });
                              });
                            });
                          }

                          uploadPic(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                  child: Visibility(
                    child: Text("welcome"),
                    visible: false,
                  ),
                  flex: 2),
              SizedBox(
                width: 50,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dynamicSizeButton(
                  text: "Save Details",
                  onPress: () {
                    setState(() {});
                    _firestore.collection("staff").add({
                      "trainername": name.text,
                      "address": addr.text,
                      "mobileNumber": mobile.text,
                      "email": email.text,
                      "qualification": qual.text,
                      "dateofbirth": dob.text,
                      "dateofjoin": doj.text,
                      "trainerimage": staffLink,
                    });
                    setState(() {
                      isName = name.text.isEmpty;
                      isMobile = mobile.text.isEmpty;
                      isEmail = email.text.isEmpty;
                    });
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdatePayment extends StatefulWidget {
  @override
  _UpdatePaymentState createState() => _UpdatePaymentState();
}

class _UpdatePaymentState extends State<UpdatePayment> {
  TextEditingController name = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController paid = TextEditingController();
  TextEditingController due = TextEditingController();
  TextEditingController paidDate = TextEditingController();
  TextEditingController nextDate = TextEditingController();
  TextEditingController mode = TextEditingController();
  bool isTotal = false,
      isPaid = false,
      isDue = false,
      isDate = false,
      isNextDate = false,
      isMode = false,
      isName = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: closeIcon(context),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: name,
                          decoration: customDecor(),
                          style: TextStyle(fontSize: 20),
                        ),
                        toggleError(isName)
                      ]),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Total Amount",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: total,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: customDecor(),
                          style: TextStyle(fontSize: 20),
                        ),
                        toggleError(isTotal)
                      ]),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Amount Paid",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: paid,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: customDecor(),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isPaid),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Due Amount",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: due,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: customDecor(),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isDue),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Paid Date",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: paidDate,
                        readOnly: false,
                        decoration: customIconDecor(
                            icon: Icon(FontAwesomeIcons.calendarAlt),
                            context: context),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isDate)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Next Payment Date",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nextDate,
                        readOnly: false,
                        decoration: customIconDecor(
                            icon: Icon(FontAwesomeIcons.calendarAlt),
                            context: context),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isNextDate)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Payment Mode",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: mode,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z ]{1,32}"))
                        ],
                        decoration: customDecor(),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isMode)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dynamicSizeButton(
                    text: "Save Details",
                    onPress: () {
                      _firestore
                          .collection("student")
                          .doc(StudentDb.paymentId)
                          .collection("payment")
                          .add({
                        "name": name.text,
                        "totalAmount": total.text,
                        "amountPaid": paid.text,
                        "dueAmount": due.text,
                        "paidDate": paidDate.text,
                        "nextPayment": nextDate.text,
                        "payMode": mode.text,
                      });
                      Navigator.pop(context);
                      setState(() {
                        isTotal = total.text.isEmpty;
                        print(isTotal);
                        isPaid = paid.text.isEmpty;
                        isDue = due.text.isEmpty;
                        isDate = paidDate.text.isEmpty;
                        isNextDate = nextDate.text.isEmpty;
                        isMode = mode.text.isEmpty;
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Visibility toggleError(isVisible) {
  return Visibility(
    visible: isVisible,
    child: Text(
      "Value Can't Be Empty ",
      style: TextStyle(color: Colors.red),
    ),
  );
}

class ViewPayment extends StatelessWidget {
  String student;
  String amountPaid;
  String totalAmount;
  String dueAmount;
  String paidDate;
  String nextDate;
  String payMode;
  ViewPayment(
      {this.nextDate,
      this.paidDate,
      this.amountPaid,
      this.dueAmount,
      this.payMode,
      this.student,
      this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              closeIcon(context),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Table(
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 80),
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 160),
                        child: Text(
                          "${student}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 80),
                        child: Text(
                          "Total Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 160),
                        child: Text(
                          "${totalAmount}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 80),
                        child: Text(
                          "Amount Paid",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 160),
                        child: Text(
                          "${amountPaid}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 80),
                        child: Text(
                          "Due Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 160),
                        child: Text(
                          "${dueAmount}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 80),
                        child: Text(
                          "Paid Date",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 160),
                        child: Text(
                          "${paidDate}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 80),
                        child: Text(
                          "Next Payment Date",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 160),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${nextDate}", style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      )
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 80),
                        child: Text(
                          "Payment Mode",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 160),
                        child: Text(
                          "${payMode}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ViewStaffDetails extends StatelessWidget {
  ViewStaffDetails(
      {this.trainername,
      this.email,
      this.address,
      this.dateofbirth,
      this.courseenrool,
      this.mobilenumber,
      this.qualification,
      this.trainerImage});
  String trainername;
  String address;
  String mobilenumber;
  String email;
  String qualification;
  String dateofbirth;
  String courseenrool;
  String trainerImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              closeIcon(context),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    "${trainerImage}",
                    width: 180,
                    height: 180,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Table(
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${trainername}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "DOB",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${dateofbirth}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "DOJ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${courseenrool}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${mobilenumber}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Email Id",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${email}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Address",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${address}", style: TextStyle(fontSize: 20)),
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Qualification",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${qualification}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ViewStudentDetails extends StatelessWidget {
  ViewStudentDetails(
      {this.studentName,
      this.email,
      this.address,
      this.dateofbirth,
      this.courseEnrool,
      this.mobilenumber,
      this.qualification,
      this.studentImage,
      this.occupation,
      this.college,
      this.experience,
      this.designation});
  String studentName;
  String address;
  String mobilenumber;
  String email;
  String qualification;
  String dateofbirth;
  String courseEnrool;
  String studentImage;
  String occupation;
  String college;
  String experience;
  String designation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              closeIcon(context),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Table(
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${studentName}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "DOB",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${dateofbirth}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${mobilenumber}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Email Id",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${email}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Address",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${address}", style: TextStyle(fontSize: 20)),
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Courses Enrolled",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${courseEnrool}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "College/Institution",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${college}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Occupation",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${occupation}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Qualification",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${qualification}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          "Working Experience (If any)",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${experience}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    "${studentImage}",
                    width: 180,
                    height: 180,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

InkWell closeIcon(BuildContext context) {
  return InkWell(
    customBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    onTap: () {
      Navigator.of(context).pop();
    },
    child: Icon(
      FontAwesomeIcons.times,
      color: Color(0xFFFF0000),
      size: 30,
    ),
  );
}

class TableWidget extends StatefulWidget {
  final List<String> title;
  TableWidget({this.title});
  static List<Widget> heading = [];
  @override
  _TableWidgetState createState() => _TableWidgetState();
}

Future<void> displayDialog({name, context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Container(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(child: name),
          actions: <Widget>[
            // TextButton(
            //   child: Text('Approve'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        ),
      );
    },
  );
}

class _TableWidgetState extends State<TableWidget> {
  // List studentid = [];
  // void subjectNotify() async {
  //   await for (var snapshot in _firestore
  //       .collection('student')
  //       .snapshots(includeMetadataChanges: true)) {
  //     for (var message in snapshot.docs) {
  //       print(message.documentID);
  //       studentid.add(message.documentID);
  //       print("${studentid}listlistlistttttttttttttttt");
  //     }
  //   }
  // }

  Widget paymentDb() {
    StreamBuilder paymentList;
    print("${Course.studentid}");

    for (var variable in Course.studentid) {
      print("${variable} variableeeeeeeeeeeeeee");
      print("${variable} thamizh");

      paymentList = StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('student')
            .doc(variable)
            .collection("payment")
            .snapshots(),
        // ignore: missing_return

        builder: (context, snapshot) {
          print("${variable} jaya");
          if (!snapshot.hasData) {
            return Text("Loading.....");
          } else {
            print("${variable} thhhhhhhhhhhhhhhhh");
            final messages = snapshot.data.docs;
            List<PaymentDb> payment = [];
            for (var message in messages) {
              final name = message.data()['name'];
              print("${name}name");
              final totalAmount = message.data()['totalamount'];
              print("${totalAmount}totalAmount");
              final amountPaid = message.data()['amountpaid'];
              print("${amountPaid}amountPaid");
              final dueAmount = message.data()['dueamount'];
              print("${dueAmount}dueAmount");
              final paidDate = message.data()['paiddate'];
              print("${paidDate}paidDate");
              final nextPayment = message.data()['nextpaymentdate'];
              print("${nextPayment}nextPayment");
              final paymentMode = message.data()['paymentmode'];

              final paymentData = PaymentDb(
                student: name,
                totalAmount: totalAmount,
                amountPaid: amountPaid,
                dueAmount: dueAmount,
                paidDate: paidDate,
                nextDate: nextPayment,
                payMode: paymentMode,
              );
              // Text('$messageText from $messageSender');
              payment.add(paymentData);
            }
            return Column(
              children: payment,
            );
          }
        },
      );
    }
    return paymentList;
  }

  Widget subjectDb() {
    var subject = StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('staff').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading.....");
        } else {
          final messages = snapshot.data.docs;
          List<StaffDb> staff = [];
          for (var message in messages) {
            final trainerName = message.data()['trainername'];
            final trainerImage = message.data()['trainerimage'];
            final qualification = message.data()['qualification'];
            final dateofbirth = message.data()['dateofbirth'];
            final dateofjoining = message.data()['dateofjoin'];
            final email = message.data()['email'];
            final mobileNumber = message.data()['mobileNumber'];
            final address = message.data()['mobileNumber'];
            final staffData = StaffDb(
              trainername: trainerName,
              qualification: qualification,
              dateofbirth: dateofbirth,
              dateofjoining: dateofjoining,
              email: email,
              mobilenumber: mobileNumber,
              trainerImage: trainerImage,
              address: address,
            );
            // Text('$messageText from $messageSender');
            staff.add(staffData);
          }
          return Column(
            //alignment: WrapAlignment.start,
            children: staff,
          );
        }
      },
    );
    return subject;
  }

  Widget studentDb() {
    var student = StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('new users').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading.....");
        } else {
          final messages = snapshot.data.docs;
          List<StudentDb> student = [];
          for (var message in messages) {
            final studentName = message.data()['First Name'];
            final studentImage = message.data()['Profile Picture'];
            final qualification = message.data()['qualification'];
            final dateofbirth = message.data()['dateofbirth'];
            final courseEnrool = message.data()['courseenrool'];
            final email = message.data()['E Mail'];
            final mobileNumber = message.data()['Phone Number'];
            final gender = message.data()['Gender'];
            final occupation = message.data()['occupation'];
            final college = message.data()['university'];
            final experience = message.data()['experience'];
            final designation = message.data()['designation'];
            final studentData = StudentDb(
              studentName: studentName,
              qualification: qualification,
              dateofbirth: dateofbirth,
              courseEnrool: courseEnrool,
              email: email,
              mobilenumber: mobileNumber,
              studentImage: studentImage,
              address: gender,
              college: college,
              designation: designation,
              experience: experience,
              occupation: occupation,
            );
            // Text('$messageText from $messageSender');
            student.add(studentData);
          }
          return Column(
            //alignment: WrapAlignment.start,
            children: student,
          );
        }
      },
    );
    return student;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //subjectNotify();
  }

  @override
  Widget build(BuildContext context) {
    TableWidget.heading.clear();
    for (String i in widget.title) {
      TableWidget.heading.add(HeadingWidget(
        text: i,
      ));
    }
    TableWidget.heading.add(Visibility(
      child: CellWidget(
        text: "sample",
        isBold: true,
      ),
      visible: false,
    ));
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Table(
        border: TableBorder(
          bottom: BorderSide(color: Color(0xFFDFDFDF), width: 1),
        ),
        children: [
          TableRow(
            children: [
              flag == 1
                  ? subjectDb()
                  : flag == 2
                      ? studentDb()
                      : paymentDb(),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentDb extends StatefulWidget {
  static String pay;
  static String amount;
  static String total;
  static String due;
  static String paid;
  static String next;
  static String paym;

  String student;
  String amountPaid;
  String totalAmount;
  String dueAmount;
  String paidDate;
  String nextDate;
  String payMode;
  PaymentDb(
      {this.nextDate,
      this.paidDate,
      this.amountPaid,
      this.dueAmount,
      this.payMode,
      this.student,
      this.totalAmount});

  @override
  _PaymentDbState createState() => _PaymentDbState();
}

class _PaymentDbState extends State<PaymentDb> {
  // void PayId() async {
  //   print("${StudentDb.paymentId}dropdownnnnnnnnnnn");
  //   await for (var snapshot in _firestore
  //       .collection('student')
  //       .where("studentimage", isEqualTo: widget.studentImage)
  //       .snapshots(includeMetadataChanges: true)) {
  //     for (var message in snapshot.docs) {
  //       //print(message.documentID);
  //       setState(() {
  //         StudentDb.paymentId = message.documentID;
  //       });
  //       print("${StudentDb.paymentId}studentjjjjjjjjjjjjjjjjjjjjjjj");
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFDFDFDF), width: 1),
            ),
          ),
          children: [
            CellWidget(
              text: "${widget.student}",
            ),
            CellWidget(text: "${widget.totalAmount}"),
            CellWidget(text: "${widget.amountPaid}"),
            CellWidget(text: "${widget.dueAmount}"),
            CellWidget(text: "${widget.paidDate}"),
            CellWidget(text: "${widget.nextDate}"),
            CellWidget(text: "${widget.payMode}"),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      displayDialog(
                          name: flag == 1
                              ? ViewStaffDetails()
                              : flag == 2
                                  ? ViewStudentDetails()
                                  : ViewPayment(
                                      student: widget.student,
                                      totalAmount: widget.totalAmount,
                                      amountPaid: widget.amountPaid,
                                      dueAmount: widget.dueAmount,
                                      paidDate: widget.paidDate,
                                      payMode: widget.payMode,
                                      nextDate: widget.nextDate,
                                    ),
                          context: context);
                    },
                    child: Icon(FontAwesomeIcons.elementor, size: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        displayDialog(
                            name: flag == 1
                                ? EditStaffDetails()
                                : flag == 2
                                    ? EditStudent()
                                    : EditPay(
                                        student: widget.student,
                                        totalAmount: widget.totalAmount,
                                        amountPaid: widget.amountPaid,
                                        dueAmount: widget.dueAmount,
                                        paidDate: widget.paidDate,
                                        payMode: widget.payMode,
                                        nextDate: widget.nextDate,
                                      ),
                            context: context);
                      },
                      child: Icon(FontAwesomeIcons.pencilAlt, size: 15)),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      displayDialog(
                          name: DeleteDetails(
                            studentname: widget.student,
                          ),
                          context: context);
                    },
                    child: Icon(FontAwesomeIcons.trashAlt, size: 15),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class StaffDb extends StatefulWidget {
  StaffDb(
      {this.trainername,
      this.email,
      this.address,
      this.dateofbirth,
      this.dateofjoining,
      this.mobilenumber,
      this.qualification,
      this.trainerImage});
  String trainername;
  String address;
  String mobilenumber;
  String email;
  String qualification;
  String dateofbirth;
  String dateofjoining;
  String trainerImage;
  @override
  _StaffDbState createState() => _StaffDbState();
}

class _StaffDbState extends State<StaffDb> {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFDFDFDF), width: 1),
            ),
          ),
          children: [
            Container(
              padding: EdgeInsets.all(7),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: NetworkImage("${widget.trainerImage}"),
                  width: 46,
                  fit: BoxFit.fill,
                  height: 40,
                ),
              ),
            ),
            CellWidget(
              text: "${widget.trainername}",
            ),
            CellWidget(text: "${widget.mobilenumber}"),
            CellWidget(text: "${widget.email}"),
            CellWidget(text: "${widget.dateofbirth}"),
            CellWidget(text: "${widget.dateofjoining}"),
            CellWidget(text: "${widget.address}"),
            CellWidget(text: "${widget.qualification}"),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      displayDialog(
                          name: flag == 1
                              ? ViewStaffDetails(
                                  trainerImage: widget.trainerImage,
                                  trainername: widget.trainername,
                                  qualification: widget.qualification,
                                  mobilenumber: widget.mobilenumber,
                                  email: widget.email,
                                  address: widget.address,
                                  dateofbirth: widget.dateofbirth,
                                  courseenrool: widget.dateofjoining,
                                )
                              : flag == 2
                                  ? ViewStudentDetails()
                                  : ViewPayment(),
                          context: context);
                    },
                    child: Icon(FontAwesomeIcons.elementor, size: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        displayDialog(
                            name: flag == 1
                                ? EditStaffDetails(
                                    trainerImage: widget.trainerImage,
                                    trainername: widget.trainername,
                                    qualification: widget.qualification,
                                    mobilenumber: widget.mobilenumber,
                                    email: widget.email,
                                    address: widget.address,
                                    dateofbirth: widget.dateofbirth,
                                    dateofjoining: widget.dateofjoining,
                                  )
                                : flag == 2
                                    ? UpdateStudentDetails()
                                    : EditPay(),
                            context: context);
                      },
                      child: Icon(FontAwesomeIcons.pencilAlt, size: 15)),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      displayDialog(
                          name: DeleteDetails(
                            trainerImage: widget.trainerImage,
                            trainername: widget.trainername,
                            qualification: widget.qualification,
                            mobilenumber: widget.mobilenumber,
                            email: widget.email,
                            address: widget.address,
                            dateofbirth: widget.dateofbirth,
                            dateofjoining: widget.dateofjoining,
                          ),
                          context: context);
                    },
                    child: Icon(FontAwesomeIcons.trashAlt, size: 15),
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    width: 50,
                    child: RaisedButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Provider.of<Routing>(context, listen: false)
                            .updateRouting(widget: BatchSchedule());
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class StudentDb extends StatefulWidget {
  static String paymentId;
  static String specificsub;
  StudentDb(
      {this.studentName,
      this.email,
      this.address,
      this.dateofbirth,
      this.courseEnrool,
      this.mobilenumber,
      this.qualification,
      this.studentImage,
      this.designation,
      this.college,
      this.occupation,
      this.experience});
  String studentName;
  String address;
  String mobilenumber;
  String email;
  String qualification;
  String dateofbirth;
  String courseEnrool;
  String studentImage;
  String occupation;
  String college;
  String experience;
  String designation;
  @override
  _StudentDbState createState() => _StudentDbState();
}

class _StudentDbState extends State<StudentDb> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StudentDb.specificsub = widget.courseEnrool;
    print(StudentDb().courseEnrool);
    //studentPayId();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFDFDFDF), width: 1),
            ),
          ),
          children: [
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: NetworkImage("${widget.studentImage}"),
                  width: 46,
                  fit: BoxFit.fill,
                  height: 40,
                ),
              ),
            ),
            CellWidget(
              text: "${widget.studentName}",
            ),
            CellWidget(text: "${widget.mobilenumber}"),
            CellWidget(text: "${widget.email}"),
            CellWidget(text: "${widget.dateofbirth}"),
            CellWidget(text: "${widget.courseEnrool}"),
            CellWidget(text: "${widget.address}"),
            CellWidget(text: "${widget.qualification}"),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      displayDialog(
                          name: flag == 1
                              ? ViewStaffDetails()
                              : flag == 2
                                  ? ViewStudentDetails(
                                      studentImage: widget.studentImage,
                                      studentName: widget.studentName,
                                      qualification: widget.qualification,
                                      mobilenumber: widget.mobilenumber,
                                      email: widget.email,
                                      address: widget.address,
                                      dateofbirth: widget.dateofbirth,
                                      courseEnrool: widget.courseEnrool,
                                      designation: widget.designation,
                                      experience: widget.experience,
                                      occupation: widget.occupation,
                                      college: widget.college,
                                    )
                                  : ViewPayment(),
                          context: context);
                    },
                    child: Icon(FontAwesomeIcons.elementor, size: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        displayDialog(
                            name: flag == 1
                                ? EditStaffDetails()
                                : flag == 2
                                    ? EditStudent(
                                        studentName: widget.studentName,
                                        studentImage: widget.studentImage,
                                        qualification: widget.qualification,
                                        mobilenumber: widget.mobilenumber,
                                        email: widget.email,
                                        address: widget.address,
                                        dateofbirth: widget.dateofbirth,
                                        courseEnrool: widget.courseEnrool,
                                        college: widget.college,
                                        experience: widget.experience,
                                        designation: widget.designation,
                                        occupation: widget.occupation,
                                      )
                                    : EditPay(),
                            context: context);
                      },
                      child: Icon(FontAwesomeIcons.pencilAlt, size: 15)),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      displayDialog(
                          name: DeleteDetails(
                            trainerImage: widget.studentImage,
                            trainername: widget.studentName,
                            qualification: widget.qualification,
                            mobilenumber: widget.mobilenumber,
                            email: widget.email,
                            address: widget.address,
                            dateofbirth: widget.dateofbirth,
                            dateofjoining: widget.courseEnrool,
                          ),
                          context: context);
                    },
                    child: Icon(FontAwesomeIcons.trashAlt, size: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      //studentPayId();
                      displayDialog(
                          name: ViewPayment(
                              // student: widget.student,
                              // totalAmount: widget.totalAmount,
                              // amountPaid: widget.amountPaid,
                              // dueAmount: widget.dueAmount,
                              // paidDate: widget.paidDate,
                              // payMode: widget.payMode,
                              // nextDate: widget.nextDate,
                              ),
                          context: context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class HeadingWidget extends StatelessWidget {
  final String text;
  final bool isvisible;
  HeadingWidget({this.text, this.isvisible = true});
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isvisible,
      child: TableCell(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class CellWidget extends StatelessWidget {
  final String text;
  final bool isBold;

  CellWidget({this.text, this.isBold = true});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: Color(0xff555454),
              fontSize: 16),
        ),
      ),
    );
  }
}

class EditStaffDetails extends StatefulWidget {
  EditStaffDetails(
      {this.trainername,
      this.email,
      this.address,
      this.dateofbirth,
      this.dateofjoining,
      this.mobilenumber,
      this.qualification,
      this.trainerImage});
  String trainername;
  String address;
  String mobilenumber;
  String email;
  String qualification;
  String dateofbirth;
  String dateofjoining;
  String trainerImage;
  @override
  _EditStaffDetailsState createState() => _EditStaffDetailsState();
}

class _EditStaffDetailsState extends State<EditStaffDetails> {
  String editStaff;

  void editstaff() async {
    await for (var snapshot in _firestore
        .collection('staff')
        .where("email", isEqualTo: widget.email)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        editStaff = message.documentID;
        print("${editStaff}latha");
      }
    }
  }

  TextEditingController name;

  TextEditingController mobile;
  TextEditingController email;
  TextEditingController qual;
  TextEditingController dob;
  TextEditingController doj;
  TextEditingController addr;

  bool isName = false, isMobile = false, isEmail = false;
  var id = 0;
  var staffLink;
  String filename;
  Uint8List uploadfile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobile = TextEditingController(text: widget.mobilenumber);
    name = TextEditingController(text: widget.trainername);
    doj = TextEditingController(text: widget.dateofjoining);
    dob = TextEditingController(text: widget.dateofbirth);
    addr = TextEditingController(text: widget.address);
    email = TextEditingController(text: widget.email);
    qual = TextEditingController(text: widget.qualification);
    editstaff();

    print("${staffLink},jjjjjjjjjjjjjjjjjjjjj");
    print("${widget.trainerImage}tttttttttttttt");
    //specificArea();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Edit Staff Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 50,
                ),
                closeIcon(context),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Name"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _heading(text: "Mobile Number"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[A-Za-z ]{1,32}"))
                      ],
                      decoration: customDecor(),
                    ),
                    toggleError(isName),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]{1,10}'))
                      ],
                      controller: mobile,
                      decoration: customDecor(),
                    ),
                    toggleError(isMobile)
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Email Id"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _heading(text: "Qualification"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: email,
                      decoration: customDecor(),
                    ),
                    toggleError(isEmail)
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: qual,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "DOB"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _heading(text: "DOJ"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: dob,
                  decoration: customIconDecor(
                      icon: Icon(FontAwesomeIcons.calendarAlt),
                      context: context),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: doj,
                    decoration: customIconDecor(
                        icon: Icon(FontAwesomeIcons.calendarAlt),
                        context: context),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                flex: 2,
                child: _heading(text: "Address"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: TextField(
                      controller: addr,
                      decoration: customDecor(),
                    ),
                  )),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "${widget.trainerImage}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: GestureDetector(
                        child: UploadImage(
                          size: 12,
                        ),
                        onTap: () async {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            uploadfile = result.files.single.bytes;
                            setState(() {
                              filename = basename(result.files.single.name);
                              uploadPic(context);
                            });
                            print(filename);
                          } else {
                            print('pick imafe');
                          }
                          ///////
                          setState(() {
                            uploadPic(context);
                          });

                          // setState(() {
                          //   isComplete = true;
                          // });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                  child: Visibility(
                    child: Text("welcome"),
                    visible: false,
                  ),
                  flex: 2),
              SizedBox(
                width: 50,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dynamicSizeButton(
                  text: "Save Details",
                  onPress: () {
                    print("${staffLink},sssssssssssssssss");
                    print("${widget.trainerImage}mmmmmmmmmmmmmmmmm");
                    setState(() {
                      _firestore.collection("staff").doc(editStaff).set({
                        "trainername": name.text,
                        "address": addr.text,
                        "mobileNumber": mobile.text,
                        "email": email.text,
                        "qualification": qual.text,
                        "dateofbirth": dob.text,
                        "dateofjoin": doj.text,
                        "trainerimage": staffLink
                      });
                    });
                    //editstaff();
                    print("${editStaff}lathaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

                    setState(() {
                      isName = name.text.isEmpty;
                      isMobile = mobile.text.isEmpty;
                      isEmail = email.text.isEmpty;
                    });
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Future uploadPic(BuildContext context) async {
    // String fileName = basename(_image.path);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("Staff").child(filename);
    UploadTask uploadTask = firebaseStorageRef.putData(uploadfile);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => setState(() {
              print("Profile Picture uploaded");
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Staff Picture Uploaded')));
              uploadTask.snapshot.ref.getDownloadURL().then((value) {
                setState(() {
                  staffLink = value;
                });
                setState(() {
                  widget.trainerImage = staffLink;
                });
                //print(getCourseLink);
              });
            }));
  }
}

class EditStudent extends StatefulWidget {
  EditStudent(
      {this.studentName,
      this.email,
      this.address,
      this.dateofbirth,
      this.courseEnrool,
      this.mobilenumber,
      this.qualification,
      this.studentImage,
      this.occupation,
      this.college,
      this.experience,
      this.designation});
  String studentName;
  String address;
  String mobilenumber;
  String email;
  String qualification;
  String dateofbirth;
  String courseEnrool;
  String studentImage;
  String occupation;
  String college;
  String experience;
  String designation;

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  TextEditingController name;
  TextEditingController address;
  TextEditingController mobile;
  TextEditingController email;
  TextEditingController courseEnrool;
  TextEditingController qual;
  TextEditingController dob;
  TextEditingController occupation;
  TextEditingController college;
  TextEditingController expreience;
  TextEditingController designation;

  bool isName = false, isMobile = false, isEmail = false;
  var id = 0;
  var studentLink;
  String filename;
  Uint8List uploadfile;
  String editStudent;
  @override
  void editstudent() async {
    await for (var snapshot in _firestore
        .collection('student')
        .where("email", isEqualTo: email.text)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        editStudent = message.documentID;
        print("${editStudent}latha");
      }
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    mobile = TextEditingController(text: widget.mobilenumber);
    name = TextEditingController(text: widget.studentName);
    courseEnrool = TextEditingController(text: widget.courseEnrool);
    dob = TextEditingController(text: widget.dateofbirth);
    address = TextEditingController(text: widget.address);
    email = TextEditingController(text: widget.email);
    qual = TextEditingController(text: widget.qualification);
    designation = TextEditingController(text: widget.designation);
    expreience = TextEditingController(text: widget.experience);
    college = TextEditingController(text: widget.college);
    occupation = TextEditingController(text: widget.occupation);
    studentLink = widget.studentImage;

    editstudent();
    print("${studentLink}llllllllllll");
    print("${widget.studentImage}ttttttttttttt");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Edit Student Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                closeIcon(context),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "${widget.studentImage}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: GestureDetector(
                        child: UploadImage(
                          size: 12,
                        ),
                        onTap: () async {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            uploadfile = result.files.single.bytes;
                            setState(() {
                              filename = basename(result.files.single.name);
                            });
                            print(filename);
                          } else {
                            print('pick imafe');
                          }
                          ///////

                          // setState(() {
                          //   isComplete = true;
                          // });

                          setState(() {
                            uploadPic(context);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heading(text: "Name"),
                    TextField(
                      controller: name,
                      decoration: customDecor(),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Mobile Number"),
              ),
              Expanded(
                child: _heading(text: "Email Id"),
              ),
              Expanded(
                child: _heading(text: "DOB"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: mobile,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: email,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: dob,
                  decoration: customIconDecor(
                      icon: Icon(FontAwesomeIcons.calendarAlt),
                      context: context),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Address"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                  child: TextField(
                controller: address,
                decoration: customDecor(),
              )),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Courses Enrolled"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                  child: TextField(
                controller: courseEnrool,
                decoration: customDecor(),
              )),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Occupation"),
              ),
              Expanded(
                child: _heading(text: "College/Institution"),
              ),
              Expanded(
                child: _heading(text: "Qualification"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: occupation,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: college,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: qual,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: _heading(text: "Working Experience"),
              ),
              Expanded(
                child: _heading(text: "Designation"),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  controller: expreience,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: designation,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dynamicSizeButton(
                  text: "Save Details",
                  onPress: () {
                    //editstudent();
                    print("${editStudent}jayaaa");
                    print("${studentLink}imagesssssssssss");
                    print("${widget.studentImage}hhhhhhhhhhhhhhh");
                    _firestore.collection("student").doc(editStudent).set({
                      "studentname": name.text,
                      "address": address.text,
                      "mobileNumber": mobile.text,
                      "email": email.text,
                      "qualification": qual.text,
                      "dateofbirth": dob.text,
                      "courseenrool": courseEnrool.text,
                      "studentimage": studentLink,
                      "occupation": occupation.text,
                      "university": college.text,
                      "experience": expreience.text,
                      "designation": designation.text,
                    });
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Future uploadPic(BuildContext context) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("Student").child(filename);
    UploadTask uploadTask = firebaseStorageRef.putData(uploadfile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      setState(() {
        print("Profile Picture uploaded");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('student Picture Uploaded')));
        uploadTask.snapshot.ref.getDownloadURL().then((value) {
          setState(() {
            studentLink = value;
          });
          setState(() {
            widget.studentImage = studentLink;
          });

          print(studentLink);
        });
      });
    });
  }
}

class EditPay extends StatefulWidget {
  String student;
  String amountPaid;
  String totalAmount;
  String dueAmount;
  String paidDate;
  String nextDate;
  String payMode;
  EditPay(
      {this.nextDate,
      this.paidDate,
      this.amountPaid,
      this.dueAmount,
      this.payMode,
      this.student,
      this.totalAmount});
  @override
  _EditPayState createState() => _EditPayState();
}

class _EditPayState extends State<EditPay> {
  String editPayment;
  String subPayment;

  void paymentid() async {
    await for (var snapshot in _firestore
        .collection('student')
        .doc(editPayment)
        .collection("payment")
        .where("name", isEqualTo: name.text)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        subPayment = message.documentID;
        print("${subPayment}jayaaaa");
      }
    }
  }

  void studentpaymentid() async {
    await for (var snapshot in _firestore
        .collection('student')
        .where("studentname", isEqualTo: widget.student)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        editPayment = message.documentID;
        print("${editPayment}latha");
      }
      paymentid();
    }
  }

  TextEditingController name;
  TextEditingController total;
  TextEditingController paid;
  TextEditingController due;
  TextEditingController paidDate;
  TextEditingController nextDate;
  TextEditingController mode;
  bool isTotal = false,
      isPaid = false,
      isDue = false,
      isDate = false,
      isNextDate = false,
      isMode = false,
      isName = false;
  var paymentEditId = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    studentpaymentid();
    name = TextEditingController(text: widget.student);
    total = TextEditingController(text: widget.totalAmount);
    paid = TextEditingController(text: widget.amountPaid);
    due = TextEditingController(text: widget.dueAmount);
    paidDate = TextEditingController(text: widget.paidDate);
    nextDate = TextEditingController(text: widget.nextDate);
    mode = TextEditingController(text: widget.payMode);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: closeIcon(context),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Total Amount",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: total,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: customDecor(),
                          style: TextStyle(fontSize: 20),
                        ),
                        toggleError(isTotal)
                      ]),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Amount Paid",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: paid,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: customDecor(),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isPaid),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Due Amount",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: due,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: customDecor(),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isDue),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Paid Date",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: paidDate,
                        readOnly: true,
                        decoration: customIconDecor(
                            icon: Icon(FontAwesomeIcons.calendarAlt),
                            context: context),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isDate)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Next Payment Date",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nextDate,
                        readOnly: true,
                        decoration: customIconDecor(
                            icon: Icon(FontAwesomeIcons.calendarAlt),
                            context: context),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isNextDate)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "Payment Mode",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: mode,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z ]{1,32}"))
                        ],
                        decoration: customDecor(),
                        style: TextStyle(fontSize: 20),
                      ),
                      toggleError(isMode)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dynamicSizeButton(
                    text: "Save Details",
                    onPress: () {
                      _firestore
                          .collection("student")
                          .doc(editPayment)
                          .collection("payment")
                          .doc(subPayment)
                          .set({
                        "name": name.text,
                        "totalamount": total.text,
                        "amountpaid": paid.text,
                        "dueamount": due.text,
                        "paiddate": paidDate.text,
                        "nextpaymentdate": nextDate.text,
                        "paymentmode": mode.text,
                      });
                      Navigator.pop(context);
                      // setState(() {
                      //   isTotal = total.text.isEmpty;
                      //   print(isTotal);
                      //   isPaid = paid.text.isEmpty;
                      //   isDue = due.text.isEmpty;
                      //   isDate = paidDate.text.isEmpty;
                      //   isNextDate = nextDate.text.isEmpty;
                      //   isMode = mode.text.isEmpty;
                      // });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TileView extends StatelessWidget {
  String text;
  TileView({this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300.0,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5.0)),
          child: ListTile(
            title: Text("List item index"),
            onTap: () {
              print("student");
            },
          ),
        ),
      ],
    );
  }
}
