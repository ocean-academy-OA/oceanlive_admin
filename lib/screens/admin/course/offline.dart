// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:universal_html/html.dart' as html;
// import 'package:flutter/services.dart';
//
// void main() {
//   runApp(PdfDemo());
// }
//
// class PdfDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final pdf = pw.Document();
//     pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text("Hello World"),
//           );
//         }));
//     final bytes = pdf.save();
//     final blob = html.Blob([bytes], 'application/pdf');
//
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               RaisedButton(
//                 child: Text("Open"),
//                 onPressed: () {
//                   final url = html.Url.createObjectUrlFromBlob(blob);
//                   html.window.open(url, "_blank");
//                   html.Url.revokeObjectUrl(url);
//                 },
//               ),
//               RaisedButton(
//                 child: Text("Download"),
//                 onPressed: () {
//                   final url = html.Url.createObjectUrlFromBlob(blob);
//                   final anchor =
//                       html.document.createElement('a') as html.AnchorElement
//                         ..href = url
//                         ..style.display = 'none'
//                         ..download = 'some_name.pdf';
//                   html.document.body.children.add(anchor);
//                   anchor.click();
//                   html.document.body.children.remove(anchor);
//                   html.Url.revokeObjectUrl(url);
//                 },
//               ),
//             ],
//             mainAxisAlignment: MainAxisAlignment.center,
//           ),
//         ),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// //
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:universal_html/html.dart' as html;
//
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: PdfDemo(),
// //     );
// //   }
// // }
// //
// // class PdfDemo extends StatelessWidget {
// //   Future<html.Blob> myGetBlobPdfContent() async {
// //     var data = await rootBundle.load("fonts/Ubuntu-Regular.ttf");
// //     var myFont = pw.Font.ttf(data);
// //     var myStyle = pw.TextStyle(font: myFont, fontSize: 36.0);
// //
// //     final pdf = pw.Document();
// //     pdf.addPage(pw.Page(
// //         pageFormat: PdfPageFormat.a4,
// //         build: (pw.Context context) {
// //           return pw.Center(
// //             child: pw.Text(
// //               "ocean academy",
// //               style: myStyle,
// //             ),
// //             // child: pw.Text("Hello World", style: myStyle),
// //           );
// //         }));
// //     final bytes = await pdf.save();
// //     html.Blob blob = html.Blob([bytes], 'application/pdf');
// //     return blob;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     myGetBlobPdfContent();
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(),
// //         body: Center(
// //           child: Column(
// //             children: <Widget>[
// //               RaisedButton(
// //                 child: Text("Open"),
// //                 onPressed: () async {
// //                   String url =
// //                       " https://firebasestorage.googleapis.com/v0/b/ocean-live.appspot.com/o/pdf%2FAngular%20Sylls.docx?alt=media&token=d7fb9ba2-f2ec-4a2a-aeb6-31a0da3e4648";
// //                   html.window.open(url, "_blank");
// //                   html.Url.revokeObjectUrl(url);
// //                 },
// //               ),
// //               RaisedButton(
// //                 child: Text("Download"),
// //                 onPressed: () async {
// //                   final url = html.Url.createObjectUrlFromBlob(
// //                       await myGetBlobPdfContent());
// //                   final anchor = html.document.createElement('a')
// //                       as html.AnchorElement
// //                     ..href =
// //                         "https://firebasestorage.googleapis.com/v0/b/ocean-live.appspot.com/o/pdf%2FAngular%20Sylls.docx?alt=media&token=d7fb9ba2-f2ec-4a2a-aeb6-31a0da3e4648"
// //                     ..style.display = 'none'
// //                     ..download = 'some_name.pdf';
// //                   html.document.body.children.add(anchor);
// //                   anchor.click();
// //                   html.document.body.children.remove(anchor);
// //                   html.Url.revokeObjectUrl(url);
// //                 },
// //               ),
// //             ],
// //             mainAxisAlignment: MainAxisAlignment.center,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:date_format/date_format.dart';

// void main() {
//   runApp(Test());
// }
//
// class Test extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: Webinar());
//   }
// }
//
// class Webinar extends StatefulWidget {
//   @override
//   _WebinarState createState() => _WebinarState();
// }
//
// class _WebinarState extends State<Webinar> {
//   final _firestore = FirebaseFirestore.instance;
//   TextEditingController _timeController = TextEditingController();
//
//   var a = DateTime(
//     2021,
//     03,
//     01,
//   );
//   var b = DateTime(11, 30);
//
//   List<Widget> date = [Text("jaya")];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 40,
//           ),
//           RaisedButton(
//               child: Text("date"),
//               onPressed: () async {
//                 final selectedDate = await _selectDateTime(context);
//                 print(selectedDate);
//                 var year = DateFormat('y').format(selectedDate);
//                 var month = DateFormat('MM').format(selectedDate);
//                 var day = DateFormat('d').format(selectedDate);
//
//                 print(year);
//                 print(month);
//                 print(day);
//
//                 setState(() {
//                   selectDate = DateFormat("dd-MM-y").format(selectedDate);
//                 });
//               }),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Text(
//               selectDate,
//               style: TextStyle(fontSize: 20, fontFamily: 'Gilroy'),
//             ),
//           ),
//           RaisedButton(
//               child: Text("time"),
//               onPressed: () async {
//                 await _selectTime(context);
//
//                 setState(() {
//                   selectTime = selectedTime;
//                 });
//                 // var hour = DateFormat("HH").format(selectedTime.hour);
//                 // print("${hour}hour");
//
//                 // _firestore.collection("admin").add({
//                 //   "date":
//                 //       "${DateTime.now().day}  ${DateTime.now().month} ${DateTime.now().year} ",
//                 //   "year": a,
//               }),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Text(
//               selectTime,
//               style: TextStyle(fontSize: 20, fontFamily: 'Gilroy'),
//             ),
//           ),
//           Text("topic"),
//           TextField()
//         ],
//       ),
//     );
//   }
//
//   String selectDate = 'select Date';
//   _selectDateTime(BuildContext context1) {
//     return showDatePicker(
//         context: context,
//         initialDate: DateTime.now().add(Duration(seconds: 1)),
//         firstDate: DateTime.now(),
//         lastDate: DateTime(DateTime.now().year + 1));
//   }
//
//   var selectedTime;
//   String selectTime = 'Select time';
//   // _selectTime(BuildContext context2) async {
//   //   final TimeOfDay picked = await showTimePicker(
//   //     context: context,
//   //     initialTime: TimeOfDay.now(),
//   //   );
//   //   selectedTime = TimeOfDay.now();
//   //
//   //   MaterialLocalizations localizations = MaterialLocalizations.of(context);
//   //   String formattedTime =
//   //       localizations.formatTimeOfDay(picked, alwaysUse24HourFormat: false);
//   //   if (formattedTime != null) {
//   //     selectedTime = formattedTime;
//   //   }
//   // }
//   _selectTime(BuildContext context) async {
//     final TimeOfDay picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null)
//       setState(() {
//         selectedTime = picked;
//         String hour = selectedTime.hour.toString();
//         String minute = selectedTime.minute.toString();
//         String time = hour + ' : ' + minute;
//         _timeController.text = time;
//         _timeController.text = formatDate(
//             DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
//             [hh, ':', nn, " ", am]).toString();
//       });
//   }
// }
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: DateTimePicker(),
  ));
}

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final _firestore = FirebaseFirestore.instance;
  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;
  num year;
  num day;
  num month;
  num hour;
  num minute;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  DateTime time;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));

    final TimeOfDay tpicked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null)
      setState(() {
        selectedDate = picked;
        print(tpicked);

        print(selectedDate.compareTo(DateTime.now()));
        var a = '$selectedDate $tpicked';
        time = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            tpicked.hour, tpicked.minute);
        print(DateTime);
        print('=====================');
        print(time);
        print(time.runtimeType);
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
    year = int.parse(DateFormat('y').format(selectedDate));
    month = int.parse(DateFormat('MM').format(selectedDate));
    day = int.parse(DateFormat('d').format(selectedDate));
    print(year);
    print(month);
    print(day);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                selectedTime.hour, selectedTime.minute),
            [hh, ':', nn]).toString();
      });
    print(_hour);
    print(_minute);
    hour = int.parse(_hour);
    minute = int.parse(_minute);
    var a = ("${_timeController.text} ${_dateController.text}");
    print(a);
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Date time picker'),
      ),
      body: Container(
        width: _width,
        height: _height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Choose Date',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: _width / 1.7,
                    height: _height / 9,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      onSaved: (String val) {
                        _setDate = val;
                      },
                      decoration: InputDecoration(
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Choose Time',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: _width / 1.7,
                    height: _height / 9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(onPressed: () {
              print('................');
              var result = time.difference(DateTime.now()).inSeconds;
              print("---------------------------------");
              print(time);
              print(result.runtimeType);
              print(result);

              _firestore.collection("webinar_time").add({
                "timeStamp": time,
              });
            }),
          ],
        ),
      ),
    );
  }
}

// class Retrive extends StatefulWidget {
//   @override
//   _RetriveState createState() => _RetriveState();
// }
//
// class _RetriveState extends State<Retrive> {
//   Timestamp total;
//   void retriveTime() async {
//     await for (var snapshot in _firestore
//         .collection('webinar_time')
//         .snapshots(includeMetadataChanges: true)) {
//       for (var message in snapshot.docs) {
//         //print(message.documentID);
//         hour = message.data()['timestamp'];
//         print("${hour}db hour");
//         mnute = message.data()['minute'];
//         print("${mnute}db minute");
//
//         var a = TimeOfDay.now().hour;
//         var b = TimeOfDay.now().minute;
//         print("${a}current hour");
//         print("${b}current minute");
//
//         if (hour > a) {
//           hour = hour - a;
//           print("${hour}result");
//         } else {
//           hour = (hour - a) + 24;
//           print("${hour}result");
//         }
//       }
//     }
//   }
//
//   final _firestore = FirebaseFirestore.instance;
//   num hour;
//   num mnute;
//   num second;
//   num days;
//   num month;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     retriveTime();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Text("time"),
//       ),
//     );
//   }
// }
