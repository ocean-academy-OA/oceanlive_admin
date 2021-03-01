import 'dart:html';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_live/models/routing.dart';
import 'dart:ui' as htmlLoader;

import 'package:ocean_live/screens/admin/course.dart';
import 'package:ocean_live/screens/admin/course/view_course.dart';
import 'package:provider/provider.dart';

class IframeScreen extends StatefulWidget {
  final String image;
  final String coursename;
  final String coursedescription;
  final String mode;
  final String rate;
  final String batchid;
  final String trainername;
  final String pdf;
  IframeScreen(
      {this.coursename,
      this.image,
      this.coursedescription,
      this.trainername,
      this.mode,
      this.batchid,
      this.pdf,
      this.rate});

  @override
  _IframeScreenState createState() => _IframeScreenState();
}

class _IframeScreenState extends State<IframeScreen> {
  final IFrameElement _iframeElement = IFrameElement();
  @override
  void initState() {
    super.initState();
    _iframeElement.src = widget.pdf;
    // _iframeElement.style.border = 'none';
    // ignore: undefined_prefixed_name
    htmlLoader.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
        ),
        Container(
          height: 800,
          width: 1000,
          child: HtmlElementView(
            viewType: 'iframeElement',
          ),
        ),
        SizedBox(
          width: 30,
        ),
        aCustomButtom(
            text: "Back to View Course",
            iconSize: 25,
            fontSize: 20,
            iconData: FontAwesomeIcons.stepBackward,
            buttonClick: () {
              Provider.of<Routing>(context, listen: false).updateRouting(
                  widget: ViewCourse(
                course: widget.coursename,
                img: widget.image,
                desc: widget.coursedescription,
                mode: widget.mode,
                rate: widget.rate,
                batchid: widget.batchid,
                trainername: widget.trainername,
                pdfLink: widget.pdf,
              ));

              ///navigator
            }),
      ],
    );
  }
}
