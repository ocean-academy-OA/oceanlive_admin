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
import 'package:url_launcher/url_launcher.dart';
import 'rectangular_raw_material_button.dart';

final _firestore = FirebaseFirestore.instance;

class Mentor extends StatefulWidget {
  @override
  _MentorState createState() => _MentorState();
}

class _MentorState extends State<Mentor> {
  var paymentEditId;
  var studentId = 0;
  String filename;
  Uint8List uploadfile;
  String image;
  String fetchimage;

  String dropdownValue = 'Search By';
  TextEditingController _name = TextEditingController();
  TextEditingController _designation = TextEditingController();
  TextEditingController _fbLink = TextEditingController();
  TextEditingController _gmailLink = TextEditingController();
  TextEditingController _linkedinLink = TextEditingController();
  TextEditingController _twitter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
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
                          "Add Mentor's Details",
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
                          displayDialog(name: AlertMentor(), context: context);
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
              SizedBox(height: 15),
              Column(
                children: [
                  Wrap(children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('Mentor').snapshots(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading.....");
                        } else {
                          final messages = snapshot.data.docs;
                          List<MentorDesign> trainerContent = [];

                          for (var message in messages) {
                            var thisDocsid = message.id;
                            final dbimage = message.data()['image'];
                            final dbDesignation = message.data()['designation'];
                            final dbName = message.data()['name'];
                            final dbFb = message.data()['fbLink'];
                            final dbGmail = message.data()['gmailLink'];
                            final dbLinkedIn = message.data()['linkedinLink'];
                            final dbTwitter = message.data()['twitterLink'];

                            final messageContent = MentorDesign(
                              image: dbimage,
                              designation: dbDesignation,
                              name: dbName,
                              fbLink: dbFb,
                              gmailLink: dbGmail,
                              linkinLink: dbLinkedIn,
                              twitterLink: dbTwitter,
                              onLongPress: () {
                                image = dbimage;
                                _name.text = dbName;
                                _designation.text = dbDesignation;
                                _fbLink.text = dbFb;
                                _gmailLink.text = dbGmail;
                                _linkedinLink.text = dbLinkedIn;
                                _twitter.text = dbTwitter;
                                displayDialog(
                                    name: MentorEdit(
                                      mentorLink: image,
                                      name: _name,
                                      designation: _designation,
                                      fbLink: _fbLink,
                                      gmailLink: _gmailLink,
                                      linkedinLink: _linkedinLink,
                                      twitter: _twitter,
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
                                            print('pick image');
                                          }
                                          Future uploadPic(
                                              BuildContext context) async {
                                            Reference firebaseStorageRef =
                                                FirebaseStorage.instance
                                                    .ref()
                                                    .child("Mentor")
                                                    .child(filename);
                                            UploadTask uploadTask =
                                                firebaseStorageRef
                                                    .putData(uploadfile);
                                            TaskSnapshot taskSnapshot =
                                                await uploadTask
                                                    .whenComplete(() {
                                              setState(() {
                                                print(
                                                    "Profile Picture uploaded");
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Staff Picture Uploaded')));
                                                uploadTask.snapshot.ref
                                                    .getDownloadURL()
                                                    .then((value) {
                                                  setState(() {
                                                    image = value;
                                                  });
                                                  setState(() {
                                                    image = fetchimage;
                                                  });

                                                  print(
                                                      "${fetchimage}yyyyyyyyyyyyyyyyyyyyyyyy");
                                                });
                                              });
                                            });
                                          }

                                          setState(() {
                                            uploadPic(context);
                                          });
                                          ///////

                                          print("${image}uploaded");

                                          //uploadPic(context);
                                        },
                                      ),
                                      onPress: () {
                                        _firestore
                                            .collection('Mentor')
                                            .doc(thisDocsid)
                                            .set({
                                          'image': image,
                                          'name': _name.text,
                                          'designation': _designation.text,
                                          'fbLink': _fbLink.text,
                                          'gmailLink': _gmailLink.text,
                                          'linkedinLink': _linkedinLink.text,
                                          'twitter': _twitter.text,
                                        });
                                        print(
                                            "${image}image streambuiler chech working r not");
                                        Navigator.pop(context);
                                      },
                                    ),
                                    context: context);
                              },
                            );
                            trainerContent.add(messageContent);
                          }
                          return Wrap(
                            alignment: WrapAlignment.center,
                            children: trainerContent,
                          );
                        }
                      },
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// < Mentor Design > ///

class MentorDesign extends StatefulWidget {
  String image;
  String name;
  String designation;
  String fbLink;
  String gmailLink;
  String linkinLink;
  String twitterLink;
  Function onLongPress;

  MentorDesign(
      {this.image,
      this.name,
      this.designation,
      this.fbLink,
      this.gmailLink,
      this.linkinLink,
      this.twitterLink,
      this.onLongPress});

  @override
  _MentorDesignState createState() => _MentorDesignState();
}

class _MentorDesignState extends State<MentorDesign> {
  bool isVisible = false;
  String docid;
  String horizondal;

  void messageStream() async {
    await for (var snapshot in _firestore
        .collection('Mentor')
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
                        print("Profile Picture uploaded");
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(content: Text('Profile Picture Deleted')));
                      });

                      _firestore.collection("Mentor").doc(horizondal).delete();
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }

  _getFb() async {
    String url = '${widget.fbLink}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getGooglePlus() async {
    String url = '${widget.gmailLink}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getLinkedin() async {
    String url = '${widget.linkinLink}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getTwitter() async {
    String url = '${widget.twitterLink}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              height: 320.0,
              width: 265.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 10,
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
                    "${widget.name}",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.designation} at Ocean",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RectangularMaterialButton(
                        icon: FontAwesomeIcons.facebookF,
                        onPressed: () {
                          _getFb();
                        },
                      ),
                      RectangularMaterialButton(
                        icon: FontAwesomeIcons.googlePlusG,
                        onPressed: () {
                          _getGooglePlus();
                        },
                      ),
                      RectangularMaterialButton(
                        icon: FontAwesomeIcons.linkedinIn,
                        onPressed: () {
                          _getLinkedin();
                        },
                      ),
                      RectangularMaterialButton(
                        icon: FontAwesomeIcons.twitter,
                        onPressed: () {
                          _getTwitter();
                        },
                      ),
                    ],
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

/// < Onpressed Alert Mentor > ///

class AlertMentor extends StatefulWidget {
  @override
  _AlertMentorState createState() => _AlertMentorState();
}

class _AlertMentorState extends State<AlertMentor> {
  var studentId = 0;
  var mentorLink;
  String filename;
  Uint8List uploadfile;

  TextEditingController name = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController fbLink = TextEditingController();
  TextEditingController gmailLink = TextEditingController();
  TextEditingController linkedinLink = TextEditingController();
  TextEditingController twitter = TextEditingController();

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
          SizedBox(height: 15),
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
                      "${mentorLink}",
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
                                  mentorLink = value;
                                });

                                print({mentorLink});
                              });
                            });
                          });
                        }

                        print('$mentorLink');
                        uploadPic(context);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
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
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: _heading(text: "Designation"),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: TextField(
                  controller: designation,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: _heading(text: "Fb link"),
              ),
              Expanded(
                child: _heading(text: "Gmail link"),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                  child: TextField(
                controller: fbLink,
                decoration: customDecor(),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: TextField(
                controller: gmailLink,
                decoration: customDecor(),
              )),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: _heading(text: "LinkedIn link"),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _heading(text: "Twitter"),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: TextField(
                  controller: linkedinLink,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: twitter,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dynamicSizeButton(
                  text: "Save Details",
                  onPress: () async {
                    print("jaya");
                    print("${mentorLink}kkkkkkkkkkkkkkk");
                    if (name.text.length >= 3 && mentorLink != null) {
                      var mentorList =
                          await _firestore.collection('Mentor').get();
                      _firestore
                          .collection("Mentor")
                          .doc('${mentorList.docs.length}${name.text}')
                          .set({
                        "image": mentorLink,
                        "name": name.text,
                        "designation": designation.text,
                        "fbLink": fbLink.text,
                        "gmailLink": gmailLink.text,
                        "linkedinLink": linkedinLink.text,
                        "twitterLink": twitter.text,
                      });

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
    );
  }
}

/// < Mentor Edit > ///

class MentorEdit extends StatefulWidget {
  TextEditingController name = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController fbLink = TextEditingController();
  TextEditingController gmailLink = TextEditingController();
  TextEditingController linkedinLink = TextEditingController();
  TextEditingController twitter = TextEditingController();
  Function onPress;
  var mentorLink;
  Widget GestureDetector;

  MentorEdit(
      {this.GestureDetector,
      this.mentorLink,
      this.onPress,
      this.name,
      this.designation,
      this.fbLink,
      this.gmailLink,
      this.linkedinLink,
      this.twitter});

  @override
  _MentorEditState createState() => _MentorEditState();
}

class _MentorEditState extends State<MentorEdit> {
  var paymentEditId;
  var studentId = 0;

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
                  "Add Student Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                closeIcon(context),
              ],
            ),
          ),
          SizedBox(height: 15),
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
                      "${widget.mentorLink}",
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: widget.GestureDetector,
                  ),
                  SizedBox(width: 10),
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
                      controller: widget.name,
                      decoration: customDecor(),
                    )
                  ],
                ),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: _heading(text: "Designation"),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: TextField(
                  controller: widget.designation,
                  decoration: customDecor(),
                ),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: _heading(text: "Fb link"),
              ),
              Expanded(
                child: _heading(text: "Gmail link"),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                  child: TextField(
                controller: widget.fbLink,
                decoration: customDecor(),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: TextField(
                controller: widget.gmailLink,
                decoration: customDecor(),
              )),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: _heading(text: "LinkedIn link"),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _heading(text: "Twitter"),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                  child: TextField(
                controller: widget.linkedinLink,
                decoration: customDecor(),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: TextField(
                controller: widget.twitter,
                decoration: customDecor(),
              )),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dynamicSizeButton(text: "Save Details", onPress: widget.onPress)
            ],
          ),
        ],
      ),
    );
  }

  ///todo futeure
}

///< Heading widget >///

Text _heading({text}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 18, color: Color(0xFF555454), fontWeight: FontWeight.w600),
  );
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
