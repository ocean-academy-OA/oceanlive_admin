import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_live/constants.dart';
import 'package:ocean_live/screens/comment.dart';
import 'package:ocean_live/screens/video_player_screen.dart';
import 'package:ocean_live/widgets/home/app_bar_widget.dart';
import 'package:ocean_live/widgets/home/main_badget_widget.dart';
import 'package:ocean_live/widgets/home/main_title_widget.dart';
import 'package:ocean_live/widgets/home/slider_widget.dart';
import 'package:ocean_live/widgets/home/upcoming_course_widget.dart';
import 'package:video_player_web/video_player_web.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            AppBarWidget(),
            SliderWidget(),
            MainBadgeWidget(),
            MainTitleWidget(
              title: "Upcoming Courses",
            ),
            UpcomingCourse(),
            MainTitleWidget(
              title: "Our student got placement",
            ),

            TextWidget(
              title:
                  " Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            ),

            // ListView(
            //   scrollDirection: Axis.horizontal,
            //   children: [
            //     Container(
            //         width: 417,
            //         height: 688,
            //         color: Colors.red,
            //         child: Row(
            //           children: [
            //             Expanded(
            //               child: Image.network(
            //                   "https://banner2.cleanpng.com/20180506/ile/kisspng-python-programming-language-computer-programming-5aefaba25ef4a4.302516281525656482389.jpg"),
            //             ),
            //             Expanded(
            //               child: Column(
            //                 children: [
            //                   Text("PYTHON"),
            //                   Text("Certification Training".toLowerCase())
            //                 ],
            //               ),
            //             )
            //           ],
            //         )),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
