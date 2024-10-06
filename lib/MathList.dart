import 'package:learn/AppTheme.dart';
import 'package:learn/Category.dart';
import 'package:learn/main.dart';
import 'package:flutter/material.dart';

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;

  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return GridView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                Category.mathList.length,
                (int index) {
                  final int count = Category.mathList.length;
                  final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController?.forward();
                  return CategoryView(
                    callback: index == 0
                        ? widget.callBack
                        : () {
                            const snackBar = SnackBar(
                              backgroundColor: DesignCourseAppTheme.nearlyBlack,
                              content: Text(
                                'Coming soon...',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                    category: Category.mathList[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 0.8,
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key, this.category, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final Category? category;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation!.value), 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffe9eaea),
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                    child: Text(
                                      category!.title,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${category!.lessonCount} lessons',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            letterSpacing: 0.27,
                                            color: DesignCourseAppTheme.nearlyBlack,
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '${category!.rating}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18,
                                                  letterSpacing: 0.27,
                                                  color: DesignCourseAppTheme.nearlyBlack,
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: DesignCourseAppTheme.nearlyBlue,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 48,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(14, 22, 14, 0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                        child: AspectRatio(
                            aspectRatio: 1.28,
                            child: Image.asset(
                              category!.imagePath,
                              scale: category!.title == "Probability and Statistics" ? 0.8 : 0.5,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
