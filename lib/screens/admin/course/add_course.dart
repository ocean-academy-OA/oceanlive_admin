import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/notification/send_notification.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../constants.dart';
import '../Details.dart';
import '../course.dart';
import 'package:path/path.dart';

final _firestore = FirebaseFirestore.instance;

List<String> data = [];
List<String> subject = [];

class AddCourse extends StatefulWidget {
  static String autoId;
  static String generatedid;
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  String getLink;
  var pdfLink;

  Map checkbox = {"online": true, "offline": false};
  bool isVisible = true;
  bool isRuppe = false;
  bool isTrainer = false;
  String des = "";
  bool isComplete = false,
      isOnline = false,
      isOffline = false,
      isFinish = false;
  Image image;
  Map chapter = {};
  List section = [];
  int count = 0;
  Uint8List uploadfile;
  String filename;
  String sectionvalue;
  String chaptervalue;
  TextEditingController rupees = TextEditingController();
  TextEditingController trainer = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController duration = TextEditingController(text: "90");
  String trainerID;

  String contentType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data.add("");
    data.add("");
  }

  var syllabusCount;
  List syllabusFormat = [];
  // syllabusId() async {
  //   print("------------------------------------");
  //   await for (var snapshot in _firestore
  //       .collection('course')
  //       .doc(trainerID)
  //       .collection("syllabus")
  //       .snapshots(includeMetadataChanges: true)) {
  //     for (var message in snapshot.docs) {
  //       syllabusCount = message.data()['section'];
  //       print("${syllabusCount}syllabuscount");
  //       syllabusFormat.add(syllabusCount);
  //     }
  //     print("${syllabusFormat.length}lengthlast");
  //     print("${syllabusFormat}size");
  //   }
  // }

  String selectDate = 'select Date';
  Future<DateTime> _selectDateTime(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
  }

  var selectedTime;
  String selectTime = 'Select time';
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime =
        localizations.formatTimeOfDay(picked, alwaysUse24HourFormat: false);
    if (formattedTime != null) {
      selectedTime = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 80, top: 20, bottom: 20, right: 200),
        child: Column(
          children: [
            courseHeading(context),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Course name",
                    style: aCourseStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: customDecor(title: "Enter course name"),
                    controller: name,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Description",
                    style: aCourseStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Focus(
                        onFocusChange: (hasFocus) {
                          if ((!hasFocus) && (des.isEmpty)) {
                            print("Blur event");
                            setState(() {
                              isVisible = true;
                            });
                          }
                        },
                        child: TextField(
                          controller: desc,
                          onChanged: (val) {
                            des = val;
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
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Provide required description for course",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Mode of Teaching",
                        style: aCourseStyle,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isOnline) {
                              isOnline = true;
                              isOffline = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(isOnline
                                ? FontAwesomeIcons.dotCircle
                                : FontAwesomeIcons.circle),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Online",
                              style: aCourseStyle,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isOffline) {
                              isOffline = true;
                              isOnline = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(isOffline
                                ? FontAwesomeIcons.dotCircle
                                : FontAwesomeIcons.circle),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Offline",
                              style: aCourseStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          aCustomButtom(
                              text: "Rate",
                              iconData: FontAwesomeIcons.rupeeSign,
                              buttonClick: () {
                                setState(() {
                                  isRuppe = isRuppe == true ? false : true;
                                });
                              }),
                          Visibility(
                            visible: isRuppe,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              width: 150.0,
                              height: 55.0,
                              child: TextField(
                                decoration: customDecor(title: "Enter rate"),
                                controller: rupees,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 80.0,
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: isTrainer,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              width: 300.0,
                              height: 55.0,
                              child: TextField(
                                decoration:
                                    customDecor(title: "Enter trainer name"),
                                controller: trainer,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          aCustomButtom(
                              text: "Trainer Name",
                              iconData: Icons.person,
                              buttonClick: () {
                                setState(() {
                                  isTrainer = isTrainer == true ? false : true;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          aCustomButtom(
                            text: "Select Date",
                            iconData: FontAwesomeIcons.calendarAlt,
                            buttonClick: () async {
                              final selectedDate =
                                  await _selectDateTime(context);
                              print(selectedDate);
                              setState(() {
                                selectDate =
                                    DateFormat("dd-MM-y").format(selectedDate);
                              });
                              print('${selectDate}');
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              selectDate,
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'Gilroy'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          aCustomButtom(
                            text: "Select time",
                            iconData: FontAwesomeIcons.clock,
                            buttonClick: () async {
                              await _selectTime(context);
                              setState(() {
                                selectTime = selectedTime.toString();
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(selectTime,
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Gilroy')),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          isComplete
                              ? aSuccessButton(
                                  text: "Completed",
                                  iconData: FontAwesomeIcons.check,
                                  buttonClick: () {})
                              : aCustomButtom(
                                  text: "Upload Image",
                                  iconData: FontAwesomeIcons.plus,
                                  buttonClick: () async {
                                    FilePickerResult result =
                                        await FilePicker.platform.pickFiles();

                                    if (result != null) {
                                      uploadfile = result.files.single.bytes;

                                      filename =
                                          basename(result.files.single.name);
                                      print(filename);
                                      setState(() {
                                        isComplete = true;
                                        uploadPic(context);
                                      });
                                    } else {
                                      // User canceled the picker
                                    }
                                    var id = await _firestore
                                        .collection('batch_id')
                                        .doc("batch_counts")
                                        .get();
                                    var totalFromDB = id.data()["total"];
                                    int totalCount = totalFromDB + 1;
                                    int availableCount = totalFromDB + 1;
                                    if (totalCount <= 9) {
                                      print(
                                          'ocn${trainer.text[0]}${trainer.text[trainer.text.length - 1]}0${totalCount}');
                                      trainerID =
                                          'ocn${trainer.text[0]}${trainer.text[trainer.text.length - 1]}0${totalCount}'
                                              .toUpperCase();
                                    } else {
                                      print(
                                          'ocn${trainer.text[0]}${trainer.text[trainer.text.length - 1]}${totalCount}');
                                      trainerID =
                                          'ocn${trainer.text[0]}${trainer.text[trainer.text.length - 1]}${totalCount}'
                                              .toUpperCase();
                                    }
                                    _firestore
                                        .collection('batch_id')
                                        .doc("batch_counts")
                                        .update({
                                      "total": totalCount,
                                      "available": availableCount
                                    });
                                  }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isOnline
                      ? Column(
                          children: [
                            Text(
                              "Add Syllabus Details",
                              style: aCourseStyle,
                            ),

                            // Add Listview
                            sectionMainWidget(),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  child: aCustomButtom(
                                      text: "Add new Section",
                                      iconData: FontAwesomeIcons.plus,
                                      buttonClick: () {
                                        setState(() {
                                          chapter[count] = [''];
                                          count++;
                                          print(" chapter${chapter}");
                                          print("======================");
                                          print("+++++++++++++++++++++++++");
                                        });
                                      },
                                      fontSize: 23,
                                      iconSize: 32),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        )
                      : isOffline
                          ? Column(
                              children: [
                                Text(
                                  "Add Syllabus Details",
                                  style: aCourseStyle,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: isFinish
                                          ? aSuccessButton(
                                              text: "Completed",
                                              iconData: FontAwesomeIcons.check,
                                              buttonClick: () {})
                                          : aCustomButtom(
                                              text: "upload Syllabus",
                                              iconData: FontAwesomeIcons.plus,
                                              buttonClick: () async {
                                                FilePickerResult result =
                                                    await FilePicker.platform
                                                        .pickFiles();
                                                if (result != null) {
                                                  uploadfile =
                                                      result.files.single.bytes;
                                                  setState(() {
                                                    filename = basename(result
                                                        .files.single.name);
                                                  });
                                                  print(filename);
                                                  setState(() {
                                                    isFinish = true;
                                                    uploadSyllabus(context);
                                                  });
                                                } else {
                                                  print('pick pdf');
                                                }
                                                ///////
                                              },
                                              fontSize: 23,
                                              iconSize: 32),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            )
                          : Column(),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          button(
                              text: "Submit Details",
                              onPress: () async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Course()),
                                // );

                                if (name.text.isEmpty) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          'Please enter the course name')));
                                } else if (desc.text.isEmpty) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          'Please enter the course description')));
                                } else if (!isOnline && !isOffline) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          'Please choose any one in mode of teaching')));
                                } else if (!isComplete) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          Text('Please upload course image')));
                                } else if (rupees.text.isEmpty) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          Text('Please upload course image')));
                                } else {
                                  isOnline
                                      ? _firestore
                                          .collection("course")
                                          .doc(trainerID)
                                          .set({
                                          "coursename": name.text,
                                          "coursedescription": desc.text,
                                          "mode":
                                              isOnline ? "Online" : "Offline",
                                          "img": getLink,
                                          "rate": rupees.text,
                                          "trainername": trainer.text,
                                          'batchid': trainerID,
                                          'duration': duration.text,
                                          "date": selectDate,
                                          "time": selectedTime,
                                        })
                                      : _firestore
                                          .collection("offline_course")
                                          .doc(trainerID)
                                          .set({
                                          "coursename": name.text,
                                          "description": desc.text,
                                          "mode":
                                              isOnline ? "Online" : "Offline",
                                          "rate": rupees.text,
                                          "trainername": trainer.text,
                                          "img": getLink,
                                          'duration': duration.text,
                                          'pdflink': pdfLink

                                          ///TODO onchange
                                        });
                                  //TODO purchase
                                  // await trainerAutoId(name.text, trainer.text);
                                  print("section $sectionvalue");
                                  print(" chapter${chaptervalue}");

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Saved successfully')));
                                }
                                print("${trainerID}kkkkkkkkkkkkkkkk");
                              },
                              fontSize: 25,
                              paddingSize: 15,
                              width: 300),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadPic(BuildContext context) async {
    // String fileName = basename(_image.path);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("course").child(filename);
    UploadTask uploadTask = firebaseStorageRef.putData(uploadfile);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => setState(() {
              print("Profile Picture uploaded");
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Profile Picture Uploaded')));
              uploadTask.snapshot.ref.getDownloadURL().then((value) {
                setState(() {
                  getLink = value;
                });
                print(getLink);
              });
            }));
  }

  Future uploadSyllabus(BuildContext context) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("Syllabus").child(filename);
    UploadTask uploadTask = firebaseStorageRef.putData(uploadfile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      setState(() {
        print("Syllabus uploaded");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Syllabus  Uploaded')));
        uploadTask.snapshot.ref.getDownloadURL().then((value) {
          setState(() {
            pdfLink = value;
          });

          print(pdfLink);
        });
      });
    });
  }

  Widget chapterMainWidget(key) {
    print("cmw $key");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chapter[key].length,
      itemBuilder: (context, index) {
        return ListTile(
          title: chapterSubWidget(context, index, key),
        );
      },
    );
  }

  Widget sectionMainWidget() {
    print("Key size ${chapter.keys.length}");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chapter.keys.length,
      itemBuilder: (context, key) {
        return ListTile(
          title: sectionSubWidget(key),
        );
      },
    );
  }

  Widget sectionSubWidget(key) {
    print("Sub $key");
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              border: Border.all(color: Color(0xFFB3B3B3), width: 2)),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    outlinebutton(
                        text: "Discard",
                        onPress: () {},
                        fontSize: 25,
                        paddingSize: 15,
                        width: 200),
                    SizedBox(
                      width: 30,
                    ),
                    button(
                        text: "Save",
                        onPress: () async {
                          var syllabusList = await _firestore
                              .collection('course')
                              .doc(trainerID)
                              .collection("syllabus")
                              .get();
                          _firestore
                              .collection("course")
                              .doc(trainerID)
                              .collection('syllabus')
                              .doc(
                                  "${syllabusList.docs.length} ${sectionvalue}")
                              .set({
                            "section": sectionvalue,
                            "chapter": FieldValue.arrayUnion(subject),
                            "flag": false
                          });

                          setState(() {
                            subject = [];
                          });
                        },
                        fontSize: 25,
                        paddingSize: 15,
                        width: 200),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                onChanged: (value) {
                  //print(value);
                  sectionvalue = value;
                  //print(sectionvalue);
                },
                decoration: customDecor(title: "Enter Section name"),
              ),
              // Column(
              //   children: customWidget,
              // ),
              Container(
                child: chapterMainWidget(key),
                padding: EdgeInsets.symmetric(horizontal: 40),
              ),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                Container(
                  padding: EdgeInsets.only(left: 50),
                  child: aCustomButtom(
                      text: "Add new chapter",
                      iconData: FontAwesomeIcons.plus,
                      buttonClick: () {
                        setState(() {
                          List n = chapter[key];
                          n.add("");
                          chapter[key] = n;
                        });
                        setState(() {
                          setState(() {
                            subject.add(chaptervalue);
                            print(subject);
                          });
                        });
                      },
                      fontSize: 22,
                      iconSize: 30),
                ),
              ]),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

//https://medium.com/47billion/how-to-use-firebase-with-flutter-e4a47a7470ce

  Widget chapterSubWidget(context, index, key) {
    List<String> subject = [];

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          child: TextField(
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            onChanged: (val) {
              chapter[key][index] = val;
              chaptervalue = chapter[key][index];
              //chaptervalue = val;

              //print(val);
              //print(subject);
            },
            controller: TextEditingController(text: chapter[key][index]),
            decoration: courseIconDecor(
                title: "Enter Chapter name",
                icon: Icon(
                  FontAwesomeIcons.times,
                  color: Colors.red,
                ),
                onPress: () {
                  setState(() {
                    chapter[key].removeAt(index);
                  });
                },
                context: context),
          ),
        ),
      ],
    );
  }

  InputDecoration courseIconDecor(
      {title, contentPadding = 25, icon, context, onPress}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(contentPadding),
      isDense: true,
      suffixIcon: GestureDetector(
        child: IconButton(
          icon: icon,
          onPressed: onPress,
        ),
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
          //color: Colors.black,
          color: Color(0xff7E7E7E),
          fontSize: 19,
          fontWeight: FontWeight.w600),
    );
  }
}

Row courseHeading(BuildContext context) {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          Provider.of<Routing>(context, listen: false)
              .updateRouting(widget: Course());
        },
        child: Icon(Icons.arrow_back_ios_rounded,
            color: Color(0xFF0091D2), size: 25),
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        "Courses",
        style: aCourseMainStyle,
      )
    ],
  );
}
