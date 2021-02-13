import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_live/models/routing.dart';
import 'package:ocean_live/screens/admin/batch_syllabus.dart';
import 'package:provider/provider.dart';

class BatchSudents extends StatefulWidget {
  BatchSudents({this.studentList, this.trinerBatchId});

  List studentList;
  String trinerBatchId;

  @override
  _BatchSudentsState createState() => _BatchSudentsState();
}

class _BatchSudentsState extends State<BatchSudents> {
  String studentName;
  String profilePicture;
  String mobileNumber;
  bool isList = true;
  List<Widget> studentList = [];
  List<Widget> studentGird = [];

  nameList() {
    for (var i in widget.studentList) {
      for (var j in i) {
        Widget list = Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              height: 100,
              width: 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 3))
                  ]),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: Offset(0, 2))
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        j[2],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        j[0],
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        j[1],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
        Widget gird = Wrap(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 3))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(3, 4))
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        j[2],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        j[0],
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        j[1],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
        studentList.add(list);
        studentGird.add(gird);
      }
    }
  }

  @override
  void initState() {
    nameList();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text('Go To Schedule',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      color: Colors.blue,
                      minWidth: 250,
                      height: 50,
                      onPressed: () {
                        Provider.of<Routing>(context, listen: false)
                            .updateRouting(
                                widget: BatchSyllebus(
                          trinerID: widget.trinerBatchId,
                        ));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          color:
                              isList != false ? Colors.blue : Colors.grey[500],
                          iconSize: 35,
                          icon: Icon(
                            Icons.list,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isList == false) {
                                isList = true;
                              }
                            });
                          },
                        ),
                        IconButton(
                          color:
                              isList == false ? Colors.blue : Colors.grey[500],
                          iconSize: 35,
                          icon: Icon(Icons.grid_view),
                          onPressed: () {
                            setState(() {
                              if (isList == true) {
                                isList = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                isList != true
                    ? Wrap(
                        children: studentGird,
                      )
                    : Column(children: studentList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
