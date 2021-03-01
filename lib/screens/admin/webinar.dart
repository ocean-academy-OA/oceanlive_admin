import 'package:ocean_live/screens/admin/video.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/Details.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

final _firestore = FirebaseFirestore.instance;

/// < Webinar Main Design > ///

class Webinar extends StatefulWidget {
  @override
  _WebinarState createState() => _WebinarState();
}

class _WebinarState extends State<Webinar> {
  bool _content1 = true;
  bool _content2 = false;
  bool _content3 = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 120),
                          Icon(
                            Icons.live_tv_outlined,
                            size: 40,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Webinar',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: _content1 ? Colors.blue[500] : Colors.grey[100],
                        border: Border(
                          top: BorderSide(color: Colors.black, width: 0.1),
                          bottom: BorderSide(color: Colors.black, width: 0.1),
                          left: BorderSide(color: Colors.black, width: 0.1),
                        ),
                      ),
                      height: 50,
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _content1 = true;
                            _content2 = false;
                            _content3 = false;
                            Provider.of<Routing>(context, listen: false)
                                .updateRouting(widget: Webinar());
                          });
                          print('Content 1');
                        },
                        child: Center(
                          child: Text('Content 1'),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: _content2 ? Colors.blue : Colors.grey[100],
                        border: Border.all(color: Colors.black, width: 0.1),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _content1 = false;
                            _content2 = true;
                            _content3 = false;
                          });
                          print('Content 2');
                        },
                        child: Center(
                          child: Text('Content 2'),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: _content3 ? Colors.blue : Colors.grey[100],
                        border: Border(
                          top: BorderSide(color: Colors.black, width: 0.1),
                          bottom: BorderSide(color: Colors.black, width: 0.1),
                          right: BorderSide(color: Colors.black, width: 0.1),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _content1 = false;
                            _content2 = false;
                            _content3 = true;
                          });
                          print('Content 3');
                        },
                        child: Center(
                          child: Text('Content 3'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                _content1
                    ? Content1()
                    : _content2
                        ? Content2()
                        : Content3()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// < Content 1 > ///

class Content1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                displayDialog(name: Content1UploadAlert(), context: context);
              },
              color: Colors.blue,
              child: Row(
                children: [
                  Icon(
                    Icons.download_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 20),
            RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Color(0xff0090E9),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xff0090E9),
                      ),
                    ),
                  ),
                ],
              ),
              textColor: Colors.white,
              onPressed: () {
                displayDialog(context: context, name: Content1EditAlert());
              },
            ),
          ],
        ),
        SizedBox(height: 50),
        Container(
          padding: EdgeInsets.all(50),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      child: Text(
                        'Heading 1',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 1000,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Lorem Aldus PageMaker including versions of Lorem Ipsum.  PageMaker including versions of Lorem Ipsum  PageMaker including versions of Lorem Ipsum  PageMaker including versions of Lorem Ipsum  PageMaker including versions of Lorem Ipsum Lorem Ipsum  PageMaker including versions of Lorem Ipsum Lorem Ipsum  PageMaker including versions of Lorem Ipsum",
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Text(
                        'Heading 2',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 1000,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Text(
                        'Heading 3',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 1000,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(),
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        "images/girl.jpg",
                        height: 500,
                        width: 300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}

/// < Content 2 > ///

class Content2 extends StatefulWidget {
  @override
  _Content2State createState() => _Content2State();
}

class _Content2State extends State<Content2> {
  Uint8List uploadfile;
  bool isComplete = false, isOnline = false, isOffline = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              aCustomButtom(
                  text: "Upload New Video",
                  iconData: FontAwesomeIcons.plusCircle,
                  buttonClick: () async {
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      uploadfile = result.files.single.bytes;
                      setState(() {
                        Video.filename = basename(result.files.single.name);
                      });
                      print(Video.filename);
                    } else {
                      print('pick image');
                    }
                    ///////
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please wait few seconds')));
                    Future uploadPic(BuildContext context) async {
                      Reference firebaseStorageRef = FirebaseStorage.instance
                          .ref()
                          .child("Video")
                          .child(Video.filename);
                      UploadTask uploadTask =
                          firebaseStorageRef.putData(uploadfile);
                      TaskSnapshot taskSnapshot =
                          await uploadTask.whenComplete(() {
                        setState(() {
                          print("Profile Picture uploaded");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Profile Picture Uploaded')));
                          uploadTask.snapshot.ref
                              .getDownloadURL()
                              .then((value) {
                            setState(() {
                              Video.getLink = value;
                            });

                            print(Video.getLink);
                            _firestore
                                .collection("Video")
                                .add({"Video": Video.getLink});
                          });
                        });
                      });
                    }

                    setState(() {
                      isComplete = true;
                    });

                    uploadPic(context);
                  }),
            ],
          ),
          SizedBox(height: 50),
          Container(
            color: Colors.grey[100],
            height: 400,
            width: 550,
            child: Row(
              children: [
                Videos(),
              ],
            ),
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  displayDialog(name: Content1UploadAlert(), context: context);
                },
                color: Colors.blue,
                child: Row(
                  children: [
                    Icon(
                      Icons.download_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 20),
              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xff0090E9),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xff0090E9),
                        ),
                      ),
                    ),
                  ],
                ),
                textColor: Colors.white,
                onPressed: () {
                  displayDialog(context: context, name: Content1EditAlert());
                },
              ),
            ],
          ),
          SizedBox(height: 50),
          Container(
            color: Colors.grey[100],
            height: 500,
            width: 1200,
            child: Row(
              children: [],
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

/// < Content 3 > ///

class Content3 extends StatefulWidget {
  @override
  _Content3State createState() => _Content3State();
}

class _Content3State extends State<Content3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  displayDialog(name: Content3UploadAlert(), context: context);
                },
                color: Colors.blue,
                child: Row(
                  children: [
                    Icon(
                      Icons.download_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 20),
              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xff0090E9),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xff0090E9),
                        ),
                      ),
                    ),
                  ],
                ),
                textColor: Colors.white,
                onPressed: () {
                  displayDialog(context: context, name: Content3EditAlert());
                },
              ),
            ],
          ),
          SizedBox(height: 50),
          Container(
            padding: EdgeInsets.all(50),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 800,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.'),
                  ),
                ),
                Container(
                  height: 500,
                  width: 400,
                  child: Image.asset(
                    'images/pichai.jpg',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

///< Content 1 Upload Alert >///

class Content1UploadAlert extends StatefulWidget {
  @override
  _Content1UploadAlertState createState() => _Content1UploadAlertState();
}

class _Content1UploadAlertState extends State<Content1UploadAlert> {
  @override
  String heading1;
  String heading2;
  String heading3;
  final heading1Controller = TextEditingController();
  final heading2Controller = TextEditingController();
  final heading3Controller = TextEditingController();

  Widget _heading1() {
    return TextFormField(
      maxLines: null,
      minLines: 3,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Heading 1',
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      onChanged: (value) {
        heading1 = value;
      },
    );
  }

  Widget _heading2() {
    return TextFormField(
      maxLines: null,
      minLines: 10,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Heading 2',
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      controller: heading2Controller,
      onChanged: (value) {
        heading2 = value;
      },
    );
  }

  Widget _heading3() {
    return TextFormField(
      maxLines: null,
      minLines: 10,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Heading 3',
        labelStyle: TextStyle(color: Colors.black, fontSize: 15),
      ),
      controller: heading3Controller,
      onChanged: (value) {
        heading3 = value;
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      height: 550,
      width: 460,
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blue,
                height: 100,
                width: 500,
                child: Center(
                  child: Text(
                    'Content 1',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 20),
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xff0090E9),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff0090E9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text(
                  //   'Heading 1',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  Container(
                    height: 70,
                    width: 330,
                    child: _heading1(),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text(
                  //   'Heading 2',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  Container(
                    height: 70,
                    width: 330,
                    child: _heading2(),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text(
                  //   'Heading 3',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  Container(
                    height: 70,
                    width: 330,
                    child: _heading3(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 15,
            top: 60,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              maxRadius: 45,
            ),
          ),
          Positioned(
            width: 35,
            top: 30,
            right: 13,
            child: RaisedButton(
              elevation: 0,
              hoverColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              padding: EdgeInsets.zero,
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.black,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// < Content 2 Upload Alert > ///

class Content2UploadAlert extends StatefulWidget {
  @override
  _Content2UploadAlertState createState() => _Content2UploadAlertState();
}

class _Content2UploadAlertState extends State<Content2UploadAlert> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// < Content 3 Upload Alert > ///

class Content3UploadAlert extends StatefulWidget {
  @override
  _Content3UploadAlertState createState() => _Content3UploadAlertState();
}

class _Content3UploadAlertState extends State<Content3UploadAlert> {
  String aboutMentor;
  TextEditingController aboutMentorController = TextEditingController();

  Widget _buildAboutMentor() {
    return TextFormField(
      maxLines: null,
      minLines: 10,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Mentor Description',
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
      onChanged: (value) {
        aboutMentor = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 450,
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blue,
                height: 100,
                width: 500,
                child: Center(
                  child: Text(
                    'Content 3',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "About Mentor",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 120,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xff0090E9),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.upload_outlined,
                              color: Colors.blue,
                              size: 15,
                            ),
                            SizedBox(width: 3),
                            Padding(
                              padding: EdgeInsets.all(1),
                              child: Text(
                                'Upload Image',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff0090E9),
                                ),
                              ),
                            ),
                          ],
                        ),
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 150,
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: _buildAboutMentor(),
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 15,
            top: 60,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              maxRadius: 45,
            ),
          ),
          Positioned(
            width: 35,
            top: 30,
            right: 13,
            child: RaisedButton(
              elevation: 0,
              hoverColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              padding: EdgeInsets.zero,
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.black,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}

///< Content 1 Edit Alert >///

class Content1EditAlert extends StatefulWidget {
  @override
  _Content1EditAlertState createState() => _Content1EditAlertState();
}

class _Content1EditAlertState extends State<Content1EditAlert> {
  @override
  String heading1;
  String heading2;
  String heading3;
  final heading1Controller = TextEditingController();
  final heading2Controller = TextEditingController();
  final heading3Controller = TextEditingController();

  Widget _heading1() {
    return TextFormField(
      maxLines: null,
      minLines: 3,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Heading 1',
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      onChanged: (value) {
        heading1 = value;
      },
    );
  }

  Widget _heading2() {
    return TextFormField(
      maxLines: null,
      minLines: 10,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Heading 2',
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      controller: heading2Controller,
      onChanged: (value) {
        heading2 = value;
      },
    );
  }

  Widget _heading3() {
    return TextFormField(
      maxLines: null,
      minLines: 10,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Heading 3',
        labelStyle: TextStyle(color: Colors.black, fontSize: 15),
      ),
      controller: heading3Controller,
      onChanged: (value) {
        heading3 = value;
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      height: 550,
      width: 460,
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blue,
                height: 100,
                width: 500,
                child: Center(
                  child: Text(
                    'Content 1',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 20),
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xff0090E9),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff0090E9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text(
                  //   'Heading 1',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  Container(
                    height: 70,
                    width: 330,
                    child: _heading1(),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text(
                  //   'Heading 2',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  Container(
                    height: 70,
                    width: 330,
                    child: _heading2(),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text(
                  //   'Heading 3',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  Container(
                    height: 70,
                    width: 330,
                    child: _heading3(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 15,
            top: 60,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              maxRadius: 45,
            ),
          ),
          Positioned(
            width: 35,
            top: 30,
            right: 13,
            child: RaisedButton(
              elevation: 0,
              hoverColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              padding: EdgeInsets.zero,
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.black,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// < Content 3 Edit Alert > ///

class Content3EditAlert extends StatefulWidget {
  @override
  _Content3EditAlertState createState() => _Content3EditAlertState();
}

class _Content3EditAlertState extends State<Content3EditAlert> {
  String aboutMentor;
  TextEditingController aboutMentorController = TextEditingController();

  Widget _buildAboutMentor() {
    return TextFormField(
      maxLines: null,
      minLines: 10,
      validator: (value) {
        if (value.isEmpty) {
          print(value);
          return "query is required";
        } else if (value.length < 2) {
          return 'character should be more than 2';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 40, left: 5),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.black54)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.blueAccent),
        ),
        labelText: 'Mentor Description',
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
      onChanged: (value) {
        aboutMentor = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 450,
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blue,
                height: 100,
                width: 500,
                child: Center(
                  child: Text(
                    'Content 3',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "About Mentor",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 120,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xff0090E9),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.upload_outlined,
                              color: Colors.blue,
                              size: 15,
                            ),
                            SizedBox(width: 3),
                            Padding(
                              padding: EdgeInsets.all(1),
                              child: Text(
                                'Upload Image',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff0090E9),
                                ),
                              ),
                            ),
                          ],
                        ),
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 150,
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: _buildAboutMentor(),
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 15,
            top: 60,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              maxRadius: 45,
            ),
          ),
          Positioned(
            width: 35,
            top: 30,
            right: 13,
            child: RaisedButton(
              elevation: 0,
              hoverColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              padding: EdgeInsets.zero,
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.black,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}

///< Alert Dialog >///

Future<void> displayDialog({name, context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Container(
        child: AlertDialog(
          // buttonPadding: EdgeInsets.zero,
          // insetPadding: EdgeInsets.zero,
          // titlePadding: EdgeInsets.zero,
          // actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: SingleChildScrollView(child: name),
          actions: <Widget>[],
        ),
      );
    },
  );
}

/////////////////////////////////////////////////////////////////////////////////////

class Videos extends StatefulWidget {
  static String filename;
  static var getLink;
  String imageLink;
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  Uint8List uploadfile;
  bool isComplete = false, isOnline = false, isOffline = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: SingleChildScrollView(
        child: Container(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Video').snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading.....");
                  } else {
                    final messages = snapshot.data.docs;
                    List<UpcomingCourseImage> upcoming = [];
                    for (var message in messages) {
                      final messageImage = message.data()['Video'];
                      final upcomingImage = UpcomingCourseImage(
                        imagePath: messageImage,
                      );
                      upcoming.add(upcomingImage);
                    }
                    return Wrap(
                      //alignment: WrapAlignment.start,
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: upcoming,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingCourseImage extends StatefulWidget {
  UpcomingCourseImage({this.imagePath});
  final String imagePath;

  @override
  _UpcomingCourseImageState createState() => _UpcomingCourseImageState();
}

class _UpcomingCourseImageState extends State<UpcomingCourseImage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      '${widget.imagePath}',
    );
    print('${widget.imagePath}');

    // Initielize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  String docid;
  bool isVisible = false;
  String horizondal;

  void messageStream() async {
    await for (var snapshot in _firestore
        .collection('Video')
        .where("Video", isEqualTo: widget.imagePath)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        horizondal = message.documentID;
        print(horizondal);
      }
      docid = horizondal;
    }
  }

  @override
  Widget build(BuildContext context) {
    Padding deleteDetails({newLink, document}) {
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
                      Navigator.pop(this.context);
                    }),
                SizedBox(
                  width: 10,
                ),
                outlinebutton(
                    text: "Yes",
                    onPress: () {
                      messageStream();
                      print("${docid}hhhhhhh");
                      print("${horizondal}jayaa");
                      setState(() async {
                        var removeImage =
                            FirebaseStorage.instance.ref().child(newLink);

                        try {
                          await removeImage.delete();
                        } catch (e) {
                          print(e);
                        }
                        Navigator.pop(this.context);

                        setState(() {
                          print("Video Deleted");
                          ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text('Video Deleted')));
                        });

                        _firestore.collection("Video").doc(horizondal).delete();
                      });
                    })
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 400,
          height: 220,
          child: InkWell(
            onTap: () {},
            onHover: (isHovering) {
              if (isHovering) {
                print("Mouse over");
                setState(() {
                  isVisible = true;
                });
              } else {
                print("mouse out");
                setState(() {
                  isVisible = false;
                });
              }
            },
            child: Stack(
              children: [
                Container(
                  width: 400,
                  height: 400,
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the VideoPlayerController has finished initialization, use
                        // the data it provides to limit the aspect ratio of the video.
                        return AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          // Use the VideoPlayer widget to display the video.
                          child: ClipRRect(
                            child: ClipRRect(
                              child: VideoPlayer(_controller),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        );
                      } else {
                        // If the VideoPlayerController is still initializing, show a
                        // loading spinner.
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 120,
                  bottom: 50,
                  child: ButtonTheme(
                      height: 10.0,
                      minWidth: 20.0,
                      child: RaisedButton(
                        color: Colors.transparent,
                        textColor: Colors.white,
                        onPressed: () {
                          // Wrap the play or pause in a call to `setState`. This ensures the
                          // correct icon is shown.
                          setState(() {
                            // If the video is playing, pause it.
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              // If the video is paused, play it.
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 120.0,
                        ),
                      )),
                ),
                Visibility(
                  visible: isVisible,
                  child: Positioned(
                    top: 13,
                    right: 15,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF504E4E),
                      radius: 15,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(FontAwesomeIcons.times),
                          color: Colors.white,
                          onPressed: () {
                            displayDialog(
                                name: deleteDetails(
                                    newLink: widget.imagePath,
                                    document: horizondal),
                                context: context);
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
