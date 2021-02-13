import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

const title = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
InputDecoration customDecor({title, contentPadding = 25}) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(contentPadding),
    isDense: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1, color: Colors.black54)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(width: 1, color: Colors.blueAccent),
    ),
    labelText: title,
    labelStyle: TextStyle(
        color: Color(0xff7E7E7E), fontSize: 19, fontWeight: FontWeight.w600),
  );
}

DateTime pickedDate = DateTime.now();

_pickDate(context) async {
  DateTime date = await showDatePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 5),
    lastDate: DateTime(DateTime.now().year + 5),
    initialDate: pickedDate,
  );
  if (date != null) pickedDate = date;
}

InputDecoration customIconDecor({title, contentPadding = 25, icon, context}) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(contentPadding),
    isDense: true,
    suffixIcon: IconButton(
      icon: icon,
      onPressed: () => _pickDate(context),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1, color: Colors.black54)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(width: 1, color: Colors.blueAccent),
    ),
    labelText: title,
    labelStyle: TextStyle(
      color: Colors.black,
      //color: Color(0xff7E7E7E), fontSize: 19, fontWeight: FontWeight.w600
    ),
  );
}

class ParticularSubject extends StatefulWidget {
  static String dropdownValue = "Enter Course Name";
  static String subjectid;
  static String des = "";
  static List sub = [];

  @override
  _ParticularSubjectState createState() => _ParticularSubjectState();
}

class _ParticularSubjectState extends State<ParticularSubject> {
  void subjectNotify(String subject) async {
    print('----------------------------------------');
    print(ParticularSubject.dropdownValue);
    await for (var snapshot in _firestore
        .collection('course')
        .where("coursename", isEqualTo: subject)
        .snapshots(includeMetadataChanges: true)) {
      print('============================================');
      for (var message in snapshot.docs) {
        var students = await _firestore.collection('new users').get();
        for (var i in students.docs) {
          var batchlist = i.data()['batchid'];
          for (var j in batchlist) {
            print(j);
            if (message.data()['batchid'] == j) {
              _firestore
                  .collection('new users')
                  .doc(i.data()['Phone Number'])
                  .collection('Subject Notification')
                  .doc(j)
                  .update({});
              print('${i.data()['Phone Number']} jjjjjjjjjjj');
            }
          }
        }
      }
    }
    print('----------------------------------------');
  }

  List<DropdownMenuItem<String>> subNotifyList = [
    DropdownMenuItem(
      child: Text(
        'Enter Course Name',
        style: TextStyle(color: Colors.black),
      ),
      value: 'Enter Course Name',
    )
  ];
  subNotify() async {
    var users = await _firestore.collection('course').get();

    for (var courses in users.docs) {
      print(courses.data()['coursename']);

      DropdownMenuItem<String> dropList = DropdownMenuItem(
        child: Text(
          '${courses.data()['coursename']}',
          style: TextStyle(color: Colors.black),
        ),
        value: courses.data()['coursename'],
      );
      subNotifyList.add(dropList);
    }
  }

  bool isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    subNotify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.black, width: 1.0)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: ParticularSubject.dropdownValue,
              icon: Icon(FontAwesomeIcons.angleDown),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              onChanged: (String newValue) {
                setState(() {
                  ParticularSubject.dropdownValue = newValue;
                });
                // subjectNotify(ParticularSubject.dropdownValue);
              },
              items: subNotifyList,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            Focus(
              onFocusChange: (hasFocus) {
                if ((!hasFocus) && (ParticularSubject.des.isEmpty)) {
                  print("Blur event");
                  setState(() {
                    isVisible = true;
                  });
                }
              },
              child: TextField(
                onChanged: (val) {
                  ParticularSubject.des = val;
                },
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.bottom,
                minLines: 8,
                maxLines: 50,
                keyboardType: TextInputType.multiline,
                decoration: customDecor(title: ""),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isVisible = false;
                });
              },
              child: Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Add Description",
                    style: TextStyle(fontSize: 16, fontFamily: "Segoe UI"),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ParticularStudent extends StatefulWidget {
  static String dropdownValue = "Enter Student Name";
  static String des = "";
  static String studentid;
  @override
  _ParticularStudentState createState() => _ParticularStudentState();
}

class _ParticularStudentState extends State<ParticularStudent> {
  List<DropdownMenuItem<String>> userNotifyList = [
    DropdownMenuItem(
      child: Text(
        'Enter Student Name',
        style: TextStyle(color: Colors.black),
      ),
      value: 'Enter Student Name',
    )
  ];

  studentNotify(String name) async {
    print("${ParticularStudent.dropdownValue}dropdownnnnnnnnnnn");
    print("${name}name");
    await for (var snapshot in _firestore
        .collection('new users')
        .where("First Name", isEqualTo: name.trim())
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        print("priya");
        //print(message.documentID);
        setState(() {
          ParticularStudent.studentid = message.documentID;
        });
      }
      print("${ParticularStudent.studentid}studentlathahhahahahha");
    }
  }

  userNotify() async {
    var users = await _firestore.collection('new users').get();
    print(users.docs);
    for (var courses in users.docs) {
      print(courses.data()['First Name']);

      DropdownMenuItem<String> dropList = DropdownMenuItem(
        child: Text(
          '${courses.data()['First Name']} ',
          style: TextStyle(color: Colors.black),
        ),
        value: '${courses.data()['First Name']} ',
      );
      userNotifyList.add(dropList);
    }
  }

  bool isVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNotify();
  }

  @override
  Widget build(BuildContext context) {
    print("Checking ${ParticularStudent.dropdownValue}");
    //print("${ParticularStudent.studentid}studentjjjjjjjjjjjjjjjjjjjjjjj");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.black, width: 1.0)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: ParticularStudent.dropdownValue,
              icon: Icon(FontAwesomeIcons.angleDown),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              onChanged: (newValue) {
                setState(() {
                  ParticularStudent.dropdownValue = newValue;
                  print("jayallllllllllllll");
                  print(
                      "${ParticularStudent.dropdownValue}studentjjjjjjjjjjjjjjjjjjjjjjj");
                  studentNotify(newValue);
                  print("jayallllllllllllll");
                });

                print("latha");
              },
              items: userNotifyList,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            Focus(
              onFocusChange: (hasFocus) {
                if ((!hasFocus) && (ParticularStudent.des.isEmpty)) {
                  print("Blur event");
                  setState(() {
                    isVisible = true;
                  });
                }
              },
              child: TextField(
                onChanged: (val) {
                  ParticularStudent.des = val;
                },
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.bottom,
                minLines: 8,
                maxLines: 50,
                keyboardType: TextInputType.multiline,
                decoration: customDecor(title: ""),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isVisible = false;
                });
              },
              child: Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Add Description",
                    style: TextStyle(fontSize: 16, fontFamily: "Segoe UI"),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class All extends StatefulWidget {
  static String des = "";
  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: customDecor(title: "Enter subject"),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            Focus(
              onFocusChange: (hasFocus) {
                if ((!hasFocus) && (All.des.isEmpty)) {
                  print("Blur event");
                  setState(() {
                    isVisible = true;
                  });
                }
              },
              child: TextField(
                onChanged: (val) {
                  All.des = val;
                },
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.bottom,
                minLines: 8,
                maxLines: 50,
                keyboardType: TextInputType.multiline,
                decoration: customDecor(title: ""),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isVisible = false;
                });
              },
              child: Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Add Description",
                    style: TextStyle(fontSize: 16, fontFamily: "Segoe UI"),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class SendNotifications extends StatefulWidget {
  static List<bool> isSelected;
  @override
  _SendNotificationsState createState() => _SendNotificationsState();
}

class _SendNotificationsState extends State<SendNotifications> {
  Widget customWidget;
  String docid;
  List store = [];

  // static  String dropownValue;
  //

  void allNotify() async {
    await for (var snapshot in _firestore
        .collection('new users')
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        docid = message.documentID;
        store.add(docid);
        print("${docid}allllllllllllllllllllll");
        print(store);
      }
    }
  }

  void subjectNotify(String subject) async {
    print('----------------------------------------');
    print(ParticularSubject.dropdownValue);
    await for (var snapshot in _firestore
        .collection('course')
        .where("coursename", isEqualTo: subject)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        var students = await _firestore.collection('new users').get();
        for (var i in students.docs) {
          var batchlist = i.data()['batchid'];
          for (var j in batchlist) {
            print(j);
            if (message.data()['batchid'] == j) {
              _firestore
                  .collection('new users')
                  .doc(i.data()['Phone Number'])
                  .collection('Subject Notification')
                  .doc(j)
                  .set({'description': ParticularSubject.des});
            }
          }
        }
      }
      print('----------------------------------------');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    SendNotifications.isSelected = [true, false, false];
    customWidget = All();
    super.initState();
    //
    allNotify();
    //studentNotify();
  }

  @override
  Widget build(BuildContext context) {
    //print("${ParticularStudent.dropdownValue}nation");
    return Expanded(
      child: Container(
        padding: pagePadding,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
            ),
            ToggleButtons(
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Color(0xff0090E9),
              splashColor: Color(0xff0090E9),
              highlightColor: Color(0xff0090E9),
              borderColor: Color(0xFF707070),
              borderWidth: 1,
              selectedBorderColor: Colors.black,
              renderBorder: true,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              disabledColor: Colors.blueGrey,
              disabledBorderColor: Colors.blueGrey,
              focusColor: Colors.red,
              children: [
                titleWidget(text: "All"),
                titleWidget(text: "Particular Student"),
                titleWidget(text: "Particular Subject"),
              ],
              isSelected: SendNotifications.isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0;
                      i < SendNotifications.isSelected.length;
                      i++) {
                    if (i != index) {
                      SendNotifications.isSelected[i] = false;
                    }
                  }
                  SendNotifications.isSelected[index] =
                      !SendNotifications.isSelected[index];
                  setState(() {
                    if (index == 0) {
                      customWidget = All();
                    } else if (index == 1) {
                      ParticularSubject.dropdownValue = null;
                      customWidget = ParticularStudent();
                    } else if (index == 2) {
                      ParticularStudent.dropdownValue = null;
                      customWidget = ParticularSubject();
                    }
                  });
                  print(SendNotifications.isSelected);
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            customWidget,
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [UploadImage()],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aCustomButtom(
                    text: "Send Notification",
                    iconData: FontAwesomeIcons.bell,
                    buttonClick: () async {
                      //studentNotify();
                      print("${ParticularStudent.studentid}student");
                      print("${docid}  allusers");
                      print("${ParticularSubject.subjectid}subject");

                      allNotify();
                      void all() {
                        for (var variable in store) {
                          _firestore
                              .collection("new users")
                              .doc(variable)
                              .collection("notification")
                              .add({
                            "description": All.des,
                          });
                        }
                      }

                      void student() {
                        _firestore
                            .collection("new users")
                            .doc(ParticularStudent.studentid)
                            .collection("specificnotification")
                            .add({
                          "description": ParticularStudent.des,
                        });
                      }

                      SendNotifications.isSelected[0] == true
                          ? all()
                          : SendNotifications.isSelected[1] == true
                              ? student()
                              : subjectNotify(ParticularSubject.dropdownValue);
                    },
                    fontSize: 22,
                    iconSize: 19)
              ],
            )
          ],
        ),
      ),
    );
  }

  Container titleWidget({text}) {
    return Container(
      padding: text == "All"
          ? EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 80,
            )
          : EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
      child: Text(
        text,
        style: title,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class UploadImage extends StatelessWidget {
  final int size;
  UploadImage({this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Color(0xFF002C47), width: 1.0)),
      child: Text(
        "Choose image file to upload",
        style: TextStyle(
            color: Color(0xFF002C47),
            fontSize: size ?? 16,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
