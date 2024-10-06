import 'package:learn/CategoryListAvailable.dart';
import 'package:learn/Mathematics/Math_Info.dart';
import 'package:learn/MathList.dart';
import 'package:flutter/material.dart';
import 'ML/ML_Cover.dart';
import 'CategoryListUnavailable.dart';
import 'AppTheme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignCourseAppTheme.nearlyWhite,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8.0, left: 18, right: 18, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Select your',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.2,
                          color: DesignCourseAppTheme.grey,
                        ),
                      ),
                      Text(
                        'AI Interest',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 0.27,
                          color: DesignCourseAppTheme.darkerText,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/userImage.png'),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(24, 0, 24, 12),
                  //   height: 80,
                  //   child: InkWell(
                  //     splashColor: Colors.transparent,
                  //     onTap: (){
                  //       Navigator.push<dynamic>(
                  //         context,
                  //         MaterialPageRoute<dynamic>(
                  //           builder: (BuildContext context) => CourseInfoScreen(),
                  //         ),
                  //       );
                  //     },
                  //     child: Row(
                  //       children: <Widget>[
                  //         Container(
                  //           width: MediaQuery.of(context).size.width - 52,
                  //           decoration: BoxDecoration(
                  //             color: Color(0xffe9eaea),
                  //             borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  //             // border: new Border.all(
                  //             //     color: DesignCourseAppTheme.notWhite),
                  //           ),
                  //           child: Column(
                  //             children: <Widget>[
                  //               Expanded(
                  //                 child: Container(
                  //                   child: Row(
                  //                     children: <Widget>[
                  //                       Container(
                  //                         padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
                  //                         child: ClipRRect(
                  //                           borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  //                           child: AspectRatio(aspectRatio: 1.28, child: Image.asset("assets/images/calculus.png")),
                  //                         ),
                  //                       ),
                  //                       Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         mainAxisAlignment: MainAxisAlignment.center,
                  //                         children: [
                  //                           Text(
                  //                             "Calculus",
                  //                             textAlign: TextAlign.left,
                  //                             style: TextStyle(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 16,
                  //                               letterSpacing: 0.27,
                  //                               color: DesignCourseAppTheme.darkerText,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             '12 lessons',
                  //                             textAlign: TextAlign.left,
                  //                             style: TextStyle(
                  //                               fontWeight: FontWeight.w400,
                  //                               fontSize: 12,
                  //                               letterSpacing: 0.27,
                  //                               color: DesignCourseAppTheme.nearlyBlack,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       )
                  //
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  mathCourses(),
                  mlCourses(),
                  dlCourses(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mlCourses() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 24, top: 8),
          child: Text(
            "Machine Learning",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        CategoryListView(
          callBack: () {
            Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => ML_Cover(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget dlCourses() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 24, top: 8),
          child: Text(
            "Deep Learning",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        CategoryListViewUnavailable(
          callBack: () {
          },
        ),
      ],
    );
  }

  Widget mathCourses() {
    return Container(
      height: 230,
      padding: const EdgeInsets.only(left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: PopularCourseListView(
              callBack: () {
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => CourseInfoScreen(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
