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
import 'dart:async';
import 'package:video_player/video_player.dart';

final _firestore = FirebaseFirestore.instance;

class Video extends StatefulWidget {
  static String filename;
  static var getLink;
  String imageLink;
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
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
                          Reference firebaseStorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child("Video")
                              .child(Video.filename);
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
