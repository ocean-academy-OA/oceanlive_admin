import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/screens/admin/Details.dart';
import 'package:path/path.dart';
import 'package:ocean_live/screens/admin/notification/send_notification.dart';

final _firestore = FirebaseFirestore.instance;

class Certificate extends StatefulWidget {
  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  var studentId = 0;
  String filename;
  Uint8List uploadfile;
  String dropdownValue = 'Search By';
  TextEditingController _studentCourse = TextEditingController();
  TextEditingController _studentName = TextEditingController();
  String _image;
  String _fetchimage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                height: 70,
                width: 700,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_ind_outlined,
                          size: 50,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Add Student's Certificate Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Ubuntu '),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 50,
                      width: 180,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)),
                        onPressed: () {
                          displayDialog(
                              name: AlertCertificate(), context: context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 10,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Upload New",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('Certificate').snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('loading');
                      } else {
                        final messages = snapshot.data.docs;
                        List<CertificateDesign> trainerContent = [];
                        for (var message in messages) {
                          var thisDocsid = message.id;
                          print("${thisDocsid}");

                          final dbimage = message.data()['image'];
                          final dbStudentName = message.data()['studentName'];
                          final dbCourseName = message.data()['courseName'];

                          final messageContent = CertificateDesign(
                            image: dbimage,
                            studentName: dbStudentName,
                            courseName: dbCourseName,
                            onLongPress: () {
                              _image = dbimage;
                              _studentName.text = dbStudentName;
                              _studentCourse.text = dbCourseName;
                              print(
                                  "${_image} <  longPress _getimage (StreamBuilder) >");
                              print(
                                  "${thisDocsid} < longPress docs id(StreamBuilder) >");

                              displayDialog(
                                  name: CertificateEdit(
                                    mentorLink: _image,
                                    studentName: _studentName,
                                    courseName: _studentCourse,
                                    GestureDetector: GestureDetector(
                                      child: UploadImage(
                                        size: 12,
                                      ),
                                      onTap: () async {
                                        FilePickerResult result =
                                            await FilePicker.platform
                                                .pickFiles();
                                        if (result != null) {
                                          uploadfile =
                                              result.files.single.bytes;
                                          setState(() {
                                            filename = basename(
                                                result.files.single.name);
                                          });
                                          print(filename);
                                        } else {
                                          print('pick imafe');
                                        }
                                        ///////
                                        uploadPic(BuildContext context) async {
                                          Reference firebaseStorageRef =
                                              FirebaseStorage.instance
                                                  .ref()
                                                  .child("Mentor")
                                                  .child(filename);
                                          UploadTask uploadTask =
                                              firebaseStorageRef
                                                  .putData(uploadfile);
                                          TaskSnapshot taskSnapshot =
                                              await uploadTask.whenComplete(() {
                                            setState(() {
                                              print("Profile Picture uploaded");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Staff Picture Uploaded')));
                                              uploadTask.snapshot.ref
                                                  .getDownloadURL()
                                                  .then((value) {
                                                setState(() {
                                                  _firestore
                                                      .collection('Certificate')
                                                      .doc(thisDocsid)
                                                      .set({
                                                    'image': _image,
                                                  });
                                                  setState(() {
                                                    _image = value;
                                                  });
                                                });

                                                print(
                                                    "${_image} <      Check it    >");
                                              });
                                            });
                                          });
                                        }

                                        uploadPic(context);
                                      },
                                    ),
                                    onPress: () {
                                      _firestore
                                          .collection('Certificate')
                                          .doc(thisDocsid)
                                          .set({
                                        'image': _image,
                                        'courseName': _studentCourse.text,
                                        'studentName': _studentName.text,
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  context: context);
                            },
                          );
                          trainerContent.add(messageContent);
// }
                        }
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: trainerContent,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// < Certificate Design > ////////////////////

class CertificateDesign extends StatefulWidget {
  String image;
  String studentName;
  String courseName;
  Function onLongPress;

  CertificateDesign(
      {this.image, this.studentName, this.courseName, this.onLongPress});

  @override
  _CertificateDesignState createState() => _CertificateDesignState();
}

class _CertificateDesignState extends State<CertificateDesign> {
  bool isVisible = false;
  String docid;
  String horizondal;

  void messageStream() async {
    await for (var snapshot in _firestore
        .collection('Certificate')
        .where("image", isEqualTo: widget.image)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        //print(message.documentID);
        horizondal = message.documentID;
        print(horizondal);
      }
      docid = horizondal;
    }
  }

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
                        print("Profile Picture uploaded");
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(content: Text('Profile Picture Deleted')));
                      });

                      _firestore
                          .collection("Certificate")
                          .doc(horizondal)
                          .delete();
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: InkWell(
        onLongPress: widget.onLongPress,
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
              margin: EdgeInsets.all(50.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              height: 320.0,
              width: 265.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 155,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage("${widget.image}"),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Text(
                    "${widget.studentName}",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.courseName} at Ocean",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Positioned(
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF504E4E),
                    radius: 20,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(FontAwesomeIcons.times),
                        color: Colors.white,
                        onPressed: () {
                          displayDialog(
                              name: deleteDetails(
                                  newLink: widget.image, document: horizondal),
                              context: context);
                        }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// < Onpressed Alert Certificate > ///

class AlertCertificate extends StatefulWidget {
  String studentName;
  @override
  _AlertCertificateState createState() => _AlertCertificateState();
}

class _AlertCertificateState extends State<AlertCertificate> {
  var studentId = 0;
  var certificateLink;
  String filename;
  Uint8List uploadfile;
  String dropdownName = "Select Name";
  String dropdownCourse = "Select Course";

  TextEditingController courseName = TextEditingController();

  List<DropdownMenuItem> name = [
    DropdownMenuItem(
      child: Text(
        'Select Name',
        style: TextStyle(color: Colors.black),
      ),
      value: 'Select Name',
    ),
  ];

  List<DropdownMenuItem<String>> allcourse = [
    DropdownMenuItem(
      child: Text(
        'Select Course',
        style: TextStyle(color: Colors.black),
      ),
      value: 'Select Course',
    ),
  ];

  getName() async {
    var documents = await _firestore.collection('new users').get();
    for (var document in documents.docs) {
      DropdownMenuItem<String> newList = DropdownMenuItem(
        child: Text(
            "${document.data()['First Name']}"
            // "${document.data()['Last Name']}"
            ,
            style: TextStyle(fontSize: 15)),
        value: "${document.data()['First Name']}"
        // "${document.data()['Last Name']}"
        ,
      );
      name.add(newList);
    }
  }

  // getCourse() async {
  //   var documents = await _firestore.collection('new users').get();
  //   for (var document in documents.docs) {
  //     DropdownMenuItem<String> newList = DropdownMenuItem(
  //       child: Text("${document.data()['Courses']} ".toUpperCase(),
  //           style: TextStyle(fontSize: 15)),
  //       value: "${document.data()['Courses']} ".toUpperCase(),
  //     );
  //     course.add(newList);
  //     print('${course} < course List >');
  //   }
  // }

  getCourse(String userName) async {
    await for (var snapshot in _firestore
        .collection('new users')
        .where('First Name', isEqualTo: userName)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        var courses = message.data()['Courses'];
        for (var course in courses) {
          print("${course} < docs >");
          DropdownMenuItem<String> newList = DropdownMenuItem(
            child: Text("${course} ", style: TextStyle(fontSize: 15)),
            value: "${course} ".toUpperCase(),
          );
          allcourse.add(newList);
          print('${course} < course List >');
          print('${dropdownName} < dropdownName > ');
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
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
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "${certificateLink}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Student Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 400,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                      value: dropdownName,
                      items: name,
                      onChanged: (value) {
                        setState(() {
                          dropdownName = value;
                          getCourse(dropdownName);
                        });
                        print("${value} dropDown onChanged value(name)");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Course Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 400,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                      value: dropdownCourse,
                      items: allcourse,
                      onChanged: (value) {
                        setState(() {
                          dropdownCourse = value;
                        });
                        print("${value} < dropDown onChanged value(course)>");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                              .child("Mentor")
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
                                  certificateLink = value;
                                });

                                print({certificateLink});
                              });
                            });
                          });
                        }

                        print('$certificateLink');
                        uploadPic(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dynamicSizeButton(
                      text: "Save Details",
                      onPress: () async {
                        if (dropdownName != 'Select Name' &&
                            dropdownCourse != 'Select Course' &&
                            certificateLink != null) {
                          var CerficateList =
                              await _firestore.collection('Certificate').get();
                          _firestore.collection("Certificate").add({
                            "image": certificateLink,
                            "studentName": dropdownName,
                            "courseName": dropdownCourse
                          });
                          print('${CerficateList.docs.length} < length >');

                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Message'),
                              content: Text("Mentor's name and image is must"),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(); // dismisses only the dialog and returns nothing
                                  },
                                  child: new Text('OK'),
                                ),
                              ],
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Sending Message"),
                          ));
                        }
                      }),
                ],
              ),
            ],
          ),
        )
      ],
    ));
  }
}

/// < Onhold Certificate Edit > ///

class CertificateEdit extends StatefulWidget {
  TextEditingController courseName = TextEditingController();
  TextEditingController studentName = TextEditingController();
  Function onPress;
  var mentorLink;
  Widget GestureDetector;

  CertificateEdit(
      {this.GestureDetector,
      this.courseName,
      this.mentorLink,
      this.onPress,
      this.studentName});

  @override
  _CertificateEditState createState() => _CertificateEditState();
}

class _CertificateEditState extends State<CertificateEdit> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
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
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "${widget.mentorLink}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Student Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 400,
                    child: TextField(
                      controller: widget.studentName,
                      decoration: customDecor(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    child: Text(
                      'Course Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 400,
                    child: TextField(
                      controller: widget.courseName,
                      decoration: customDecor(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: widget.GestureDetector,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dynamicSizeButton(
                    text: "Save Details",
                    onPress: widget.onPress,
                  )
                ],
              ),
            ],
          ),
        )
      ],
    ));
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(child: name),
          actions: <Widget>[],
        ),
      );
    },
  );
}
