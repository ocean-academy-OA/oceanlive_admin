import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:provider/provider.dart';

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
                        : Container(
                            color: Colors.red,
                            height: 100,
                            width: 100,
                          )
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

/// < Content 2 > ///

class Content2 extends StatefulWidget {
  @override
  _Content2State createState() => _Content2State();
}

class _Content2State extends State<Content2> {
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
            ],
          ),
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
