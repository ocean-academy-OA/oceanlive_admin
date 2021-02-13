import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:provider/provider.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class BatchSyllebus extends StatefulWidget {
  BatchSyllebus({this.trinerID});
  final trinerID;
  Color activeColor = Colors.blue;
  Color successColor = Colors.green;
  Color disableColor = Colors.grey;

  @override
  _BatchSyllebusState createState() => _BatchSyllebusState();
}

class _BatchSyllebusState extends State<BatchSyllebus> {
  bool isTrue = false;
  Map boolContent = {};
  TextEditingController _scheduleDate = TextEditingController();
  TextEditingController _scheduletime = TextEditingController();
  TextEditingController _disctription = TextEditingController();
  TextEditingController _zoomLink = TextEditingController();
  TextEditingController _zoopPassword = TextEditingController();

  List<String> timeAndDate = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('course')
                    .doc(widget.trinerID)
                    .collection("syllabus")
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading.....");
                  } else {
                    final messages = snapshot.data.docs;

                    for (var message in messages) {
                      final topics = message.data()['section'];
                      final isCheckValue = message.data()['flag'];
                      final dbTimeAndDate = message.data()['time'];
                      boolContent[topics] = isCheckValue;
                      timeAndDate.add(dbTimeAndDate);
                    }
                    return TopicWidget(
                      content: boolContent,
                      dateAndTime: timeAndDate,
                    );
                    // return Text("welcome");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatButton(
                  minWidth: 300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  height: 50,
                  color: Colors.blue,
                  child: Text(
                    'SCHEDULE',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 23),
                  ),
                  onPressed: () {
                    print('${boolContent} checkListttttttttttttttttttttt');
                    for (var scheduleUpdate in boolContent.entries) {
                      bool done = scheduleUpdate.value;
                      String doneTopic = scheduleUpdate.key;
                      print(done);
                      _firestore
                          .collection('course')
                          .doc(widget.trinerID)
                          .collection("syllabus")
                          .doc(doneTopic)
                          .update({'flag': done});
                    }
                    _showDialog();
                  },
                ),
              ),
            ],
          )),
        ));
  }

  void _saveSchedule() async {
    print('${boolContent} checkListttttttttttttttttttttt');
    for (var scheduleUpdate in boolContent.entries) {
      bool done = scheduleUpdate.value;
      String doneTopic = scheduleUpdate.key;
      if (done) {
        // _firestore
        //     .collection('course')
        //     .doc(widget.trinerID)
        //     .collection("syllabus")
        //     .doc(doneTopic)
        //     .update({'time': '${_scheduleDate.text}  ${_scheduletime.text}'});
        _firestore
            .collection('course')
            .doc(widget.trinerID)
            .collection("schedule")
            .doc(doneTopic)
            .set({
          'date': '${_scheduleDate.text} ',
          'time': "${_scheduletime.text}",
          'description': _disctription.text,
          'zoom_link': _zoomLink.text,
          'zoom_password': _zoopPassword.text
        });
      } else {
        _firestore
            .collection('course')
            .doc(widget.trinerID)
            .collection("syllabus")
            .doc(doneTopic)
            .update({'time': null});
        _firestore
            .collection('course')
            .doc(widget.trinerID)
            .collection("schedule")
            .doc(doneTopic)
            .delete();
      }
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Container(
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            content: Container(
              height: 550,
              width: 450,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScheduleAlertTextField(
                    hintText: 'Select Date',
                    icon: Icon(FontAwesomeIcons.calendarAlt),
                    controller: _scheduleDate,
                    readOnly: true,
                    onPressed: () async {
                      final selectedDate = await _selectDateTime(context);
                      print(selectedDate);
                      _scheduleDate.text =
                          DateFormat("dd-MM-y").format(selectedDate);
                      print('${_scheduleDate.text}');
                    },
                  ),
                  ScheduleAlertTextField(
                    hintText: 'Select Time',
                    controller: _scheduletime,
                    icon: Icon(Icons.access_time_outlined),
                    readOnly: true,
                    onPressed: () async {
                      await _selectTime(context);
                      _scheduletime.text = selectedTime.toString();
                    },
                  ),
                  ScheduleAlertTextField(
                    hintText: "Description",
                    icon: Icon(Icons.notes_sharp),
                    controller: _disctription,
                  ),
                  ScheduleAlertTextField(
                    hintText: "Zoom Link",
                    icon: Icon(FontAwesomeIcons.video),
                    controller: _zoomLink,
                  ),
                  ScheduleAlertTextField(
                    hintText: "Zoom Password",
                    icon: Icon(Icons.vpn_key),
                    controller: _zoopPassword,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: FlatButton(
                          height: 60,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.blue,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 23),
                          ),
                          onPressed: () {
                            _saveSchedule();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: FlatButton(
                          height: 60,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Color(0xffFC5656),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 23),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var selectedTime;
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

  Future<DateTime> _selectDateTime(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
  }
}

class ScheduleAlertTextField extends StatelessWidget {
  ScheduleAlertTextField(
      {this.hintText,
      this.icon,
      this.onPressed,
      this.controller,
      this.readOnly = false});
  String hintText;
  Function onPressed;
  Icon icon;
  bool readOnly;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey[400],
            ),
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderSide: BorderSide.none),
            suffixIcon: IconButton(
              icon: icon,
              color: Colors.grey[400],
              onPressed: onPressed,
            ),
          ),
        ));
  }
}

class TopicWidget extends StatefulWidget {
  Map content;
  List dateAndTime;
  TopicWidget({this.content, this.dateAndTime});
  @override
  _TopicWidgetState createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.content);
    List topics = widget.content.keys.toList();
    List isScheduled = widget.content.values.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow(
              section: topics[index],
              isIcon: isScheduled[index],
              dateAndTime: widget.dateAndTime[index],
            ),
          ],
        );
      },
    );
    // return Text("welcome");
  }

  Container buildRow({section, isIcon, dateAndTime}) {
    return Container(
      width: 355,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                  splashRadius: 20,
                  iconSize: 35,
                  color: Colors.blue,
                  icon: Icon(
                    isIcon != true
                        ? FontAwesomeIcons.circle
                        : FontAwesomeIcons.checkCircle,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.content[section] = !isIcon;
                    });
                  }),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2.0,
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${section}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                      fontSize: 22.0),
                ),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: isIcon
                  ? dateAndTime != null
                      ? Text('${dateAndTime}')
                      : Text('Schedule time')
                  : Text(''))
        ],
      ),
    );
  }
}
