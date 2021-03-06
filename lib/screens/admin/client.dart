import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/screens/admin/Details.dart';
import 'package:ocean_live/screens/admin/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../../constants.dart';

final _firestore = FirebaseFirestore.instance;

class Client extends StatefulWidget {
  static String filename;
  static var getLink;
  String imageLink;
  @override
  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  aCustomButtom(
                      text: "Upload new image",
                      iconData: FontAwesomeIcons.plusCircle,
                      buttonClick: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          uploadfile = result.files.single.bytes;
                          setState(() {
                            Client.filename =
                                basename(result.files.single.name);
                          });
                          print(Client.filename);
                        } else {
                          print('pick imafe');
                        }
                        ///////
                        Future uploadPic(BuildContext context) async {
                          Reference firebaseStorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child("Client")
                              .child(Client.filename);
                          UploadTask uploadTask =
                              firebaseStorageRef.putData(uploadfile);
                          TaskSnapshot taskSnapshot =
                              await uploadTask.whenComplete(() {
                            setState(() {
                              print("Profile Picture uploaded");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Profile Picture Uploaded')));
                              uploadTask.snapshot.ref
                                  .getDownloadURL()
                                  .then((value) {
                                setState(() {
                                  Client.getLink = value;
                                });

                                print(Client.getLink);
                                _firestore
                                    .collection("Client")
                                    .add({"Client": Client.getLink});
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
              SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Client').snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading.....");
                  } else {
                    final messages = snapshot.data.docs;
                    List<UpcomingCourseImage> upcoming = [];
                    for (var message in messages) {
                      final messageImage = message.data()['Client'];
                      final upcomingImage = UpcomingCourseImage(
                        imagePath: messageImage,
                      );
                      // Text('$messageText from $messageSender');
                      upcoming.add(upcomingImage);
                    }
                    return Wrap(
                      //alignment: WrapAlignment.start,
                      spacing: 40.0,
                      runSpacing: 40.0,
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
  String docid;
  bool isVisible = false;
  String horizondal;
  void messageStream() async {
    await for (var snapshot in _firestore
        .collection('Client')
        .where("Client", isEqualTo: widget.imagePath)
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
                          print("Profile Picture uploaded");
                          ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                  content: Text('Profile Picture Deleted')));
                        });

                        // List<DocumentSnapshot> documentList = [];
                        // documentList = (await _firestore
                        //         .collection("Upcoming_Course")
                        //         .where("upcomingcourse", isEqualTo: newLink)
                        //         .get())
                        //     .docs;
                        // print(documentList);
                        _firestore
                            .collection("Client")
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  child: Image(
                    height: 200,
                    width: 270,
                    image: NetworkImage("${widget.imagePath}"),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Positioned(
                  right: 3,
                  top: 3,
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
                                    newLink: widget.imagePath,
                                    document: horizondal),
                                context: context);
                          }),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

//
// .where("upcomingcourse", isEqualTo: widget.imagePath)
