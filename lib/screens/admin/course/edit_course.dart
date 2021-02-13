import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/screens/admin/Details.dart';
import 'package:ocean_live/screens/admin/notification/send_notification.dart';

import '../course.dart';
import 'add_course.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class EditCourse extends StatefulWidget {
  EditCourse(
      {this.course,
      this.courseImage,
      this.batchid,
      this.rate,
      this.description,
      this.trainername});
  String course;
  String description;
  String rate;
  String trainername;
  String batchid;
  String courseImage;
  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  String getCourseLink;
  Uint8List uploadfile;
  String filename;
  final _firestore = FirebaseFirestore.instance;

  Map chapter = {};
  List section = [];
  int count = 0;
  bool isComplete = false;
  String sectionvalue;
  String chaptervalue;
  String getLink;
  Map checkbox = {"online": true, "offline": false};
  bool isVisible = true;
  bool isRuppe = true;
  bool isTrainer = true;
  String des = "";
  TextEditingController rupees;
  TextEditingController trainer;
  TextEditingController courseName;
  TextEditingController desc;
  bool isOnline = true;
  bool isOffline = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrivedata();
    rupees = TextEditingController(text: widget.rate);
    trainer = TextEditingController(text: widget.trainername);
    courseName = TextEditingController(text: widget.course);
    desc = TextEditingController(text: widget.description);
    //syllabus();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: pagePadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              courseHeading(context),
              SizedBox(
                height: 20,
              ),
              Text(
                "Course Name",
                style: aCourseStyle,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: customDecor(title: "Enter course name"),
                controller: courseName,
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
                      onChanged: (val) {
                        des = val;
                      },
                      controller: desc,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.bottom,
                      minLines: 8,
                      maxLines: 50,
                      keyboardType: TextInputType.multiline,
                      decoration: customDecor(title: ''),
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
                        // child: Text(
                        //   "Provide required description for course",
                        //   style: TextStyle(fontSize: 16, fontFamily: "Segoe UI"),
                        // ),
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
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      "${widget.courseImage}",
                      width: 300,
                      height: 150,
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
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Add Syllabus Details",
                style: aCourseStyle,
              ),

              // Add Listview
              // sectionMainWidget(),

              SizedBox(
                height: 20,
              ),

              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('course')
                    .doc(widget.batchid)
                    .collection('syllabus')
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading.....");
                  } else {
                    final messages = snapshot.data.docs;
                    String messageContent3;

                    List<SyllabusDb> syllabusDetails = [];

                    for (var message in messages) {
                      List<Widget> chapterWidget = [];
                      // if (message.data()['coursename'] == widget.course) {
                      final messageContent2 = message.data()['section'];
                      //final messageContent3 = message.data()['chapter'];
                      for (var i = 0;
                          i < message.data()["chapter"].length;
                          i++) {
                        messageContent3 = message.data()["chapter"][i];
                        chapterWidget.add(
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              onChanged: (val) {
                                chaptervalue = val;
                                print(val);
                                print(subject);
                              },
                              controller:
                                  TextEditingController(text: messageContent3),
                              decoration: courseIconDecor(
                                  title: "Enter Chapter name",
                                  icon: Icon(
                                    FontAwesomeIcons.times,
                                    color: Colors.red,
                                  ),
                                  onPress: () {
                                    setState(() {});
                                  },
                                  context: context),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40),
                          ),
                        );
                      }

                      final syllabus = SyllabusDb(
                        section: messageContent2,
                        chapterWidget: chapterWidget,
                      );
                      syllabusDetails.add(syllabus);
                      print("${chapterWidget}chapter");
                      print(messages);
                      // }
                    }

                    return Column(
                      children: syllabusDetails,
                    );
                  }
                },
              ),
              SizedBox(
                height: 30,
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
              sectionMainWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button(
                      text: "Submit Details",
                      onPress: () {
                        setState(() {
                          print("${widget.course}kkkkkkkkkkk");
                          trainerAutoId();
                        });
                        if (courseName.text.isEmpty) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Please enter the course name')));
                        } else if (desc.text.isEmpty) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Please enter the course description')));
                        } else if (!isOnline && !isOffline) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please choose any one in mode of teaching')));
                        } else if (widget.courseImage.isEmpty) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Please upload course image')));
                        } else {
                          isOnline
                              ? _firestore
                                  .collection("course")
                                  .doc(widget.batchid)
                                  .update({
                                  "coursename": courseName.text,
                                  "coursedescription": desc.text,
                                  "mode": isOnline ? "Online" : "Offline",
                                  "img": widget.courseImage,
                                  "rate": rupees.text,
                                  "trainername": trainer.text,
                                  "date": "02-22-2000",
                                  "time": "09-30",
                                })
                              : _firestore
                                  .collection("offline_course")
                                  .doc(widget.batchid)
                                  .update({
                                  "coursename": courseName.text,
                                  "description": desc.text,
                                  "mode": isOnline ? "Online" : "Offline",
                                  "rate": rupees.text,
                                  "img": getCourseLink,

                                  ///TODO onchange
                                });
                          // isOnline
                          //     ? _firestore
                          //         .collection("course")
                          //         .doc(widget.course)
                          //         .collection('syllabus')
                          //         .add({
                          //         "section": sectionvalue,
                          //         "chapter": FieldValue.arrayUnion(subject),
                          //       })
                          //     : _firestore
                          //         .collection("offline_course")
                          //         .doc(courseName.text)
                          //         .collection('syllabus')
                          //         .add({
                          //         "section": sectionvalue,
                          //         "chapter": FieldValue.arrayUnion(subject),
                          //       });
                          // setState(() {
                          //   subject = [];
                          // });

                          print("section $sectionvalue");
                          print("nameeeee ${courseName.text}");
                          print("nameeeee ${courseName.text}");
                          print(" chapter${chaptervalue}");

                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Saved successfully')));
                        }
                        print("${AddCourse.generatedid}kkkkkkkkkkkkkkkk");
                      },
                      fontSize: 25,
                      paddingSize: 15,
                      width: 300),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
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
                  getCourseLink = value;
                });
                setState(() {
                  widget.courseImage = getCourseLink;
                });
                print(getCourseLink);
              });
            }));
  }

  void trainerAutoId() {
    AddCourse.autoId = trainer.text;
    AddCourse.generatedid = "OCN" +
        AddCourse.autoId[0] +
        AddCourse.autoId[AddCourse.autoId.length - 1];

    print(AddCourse.generatedid);
  }

  Widget sectionSubWidget(key, String holdsub) {
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
                        onPress: () {
                          isOnline
                              ? _firestore
                                  .collection("course")
                                  .doc(widget.batchid)
                                  .collection('syllabus')
                                  .add({
                                  "section": sectionvalue,
                                  "chapter": FieldValue.arrayUnion(subject),
                                })
                              : _firestore
                                  .collection("offline_course")
                                  .doc(widget.batchid)
                                  .collection('syllabus')
                                  .add({
                                  "section": sectionvalue,
                                  "chapter": FieldValue.arrayUnion(subject),
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

  Widget sectionMainWidget({QueryDocumentSnapshot holdmain}) {
    print("Key size ${chapter.keys.length}");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chapter.keys.length,
      itemBuilder: (context, key) {
        return ListTile(
          title: sectionSubWidget(key, holdmain.toString()),
        );
      },
    );
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

  void retrivedata() async {
    print(
        '${widget.course.toLowerCase()} hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
    final message =
        await _firestore.collection("course").doc(widget.course).get();

    courseName.text = message.data()['coursename'];
    trainer.text = message.data()['trainername'];
    rupees.text = message.data()['rate'];
    desc.text = message.data()['coursedescription'];
    if (message.data()['mode'] == "online") {
      setState(() {
        isOnline = true;
        isOffline = false;
      });
    } else {
      setState(() {
        isOffline = true;
        isOnline = false;
      });
    }
    //section
  }
}

class SyllabusDb extends StatefulWidget {
  String section;
  List<Widget> chapterWidget;

  SyllabusDb({this.section, this.chapterWidget});

  @override
  _SyllabusDbState createState() => _SyllabusDbState();
}

class _SyllabusDbState extends State<SyllabusDb> {
  TextEditingController sections;
  TextEditingController chapters;

  Map chapter = {};
  int count = 0;

  String sectionvalue;
  String chaptervalue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sections = TextEditingController(text: widget.section);
    //chapters = TextEditingController(text: widget.chapter);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // sectionMainWidget(),
        SizedBox(
          height: 20,
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
                        onPress: () {},
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
                controller: sections,
                onChanged: (value) {
                  //print(value);
                  sectionvalue = value;
                  //print(sectionvalue);
                },
                decoration: customDecor(),
              ),
              // Column(
              //   children: customWidget,
              // ),
              SizedBox(
                height: 30,
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: widget.chapterWidget,
                ),
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
                        // setState(() {
                        //   List n = chapter[key];
                        //   n.add("");
                        //   chapter[key] = n;
                        // });
                        setState(() {
                          subject.add(chaptervalue);
                          print(subject);
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

  Widget sectionMainWidget({String holdMain}) {
    print("Key size ${chapter.keys.length}");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chapter.keys.length,
      itemBuilder: (context, key) {
        return ListTile(
          title: sectionSubWidget(key: key, holdsub: holdMain),
        );
      },
    );
  }

  Widget sectionSubWidget({key, String holdsub}) {
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
                        onPress: () {},
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
                controller: sections,
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
                    //
                    // _firestore
                    //     .collection("course")
                    //     .doc(courseName.text)
                    //     .collection('syllabus')
                    //     .add({
                    //   "section": sectionvalue,
                    //   "chapter": FieldValue.arrayUnion(subject),
                    // });
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
