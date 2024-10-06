import 'dart:math' as math;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:vector_math/vector_math.dart' as vector;
import '../AppTheme.dart';

class WaveView extends StatefulWidget {
  final double percentageValue;
  final double value;

  const WaveView({this.percentageValue = 100.0, this.value = 0.0});

  @override
  _WaveViewState createState() => _WaveViewState();
}

class _WaveViewState extends State<WaveView> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController waveAnimationController;
  Offset bottleOffset1 = Offset(0, 0);
  List<Offset> animList1 = [];
  Offset bottleOffset2 = Offset(60, 0);
  List<Offset> animList2 = [];

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    waveAnimationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animationController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

    if (widget.percentageValue != null && widget.percentageValue != "") {
      waveAnimationController.addListener(() {
        animList1.clear();
        for (int i = -2 - bottleOffset1.dx.toInt(); i <= 60 + 2; i++) {
          animList1.add(
            new Offset(
              i.toDouble() + bottleOffset1.dx.toInt(),
              math.sin((waveAnimationController.value * 360 - i) % 360 * vector.degrees2Radians) * 4 + (((100 - widget.percentageValue) * widget.value / 100)),
            ),
          );
        }
        animList2.clear();
        for (int i = -2 - bottleOffset2.dx.toInt(); i <= 60 + 2; i++) {
          animList2.add(
            new Offset(
              i.toDouble() + bottleOffset2.dx.toInt(),
              math.sin((waveAnimationController.value * 360 - i) % 360 * vector.degrees2Radians) * 4 + (((100 - widget.percentageValue) * widget.value / 100)),
            ),
          );
        }
      });
    }

    waveAnimationController.repeat();
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    waveAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new Stack(
          children: <Widget>[
            new ClipPath(
              child: new Container(
                decoration: BoxDecoration(
                  color: DesignCourseAppTheme.nearlyBlack,
                  borderRadius: BorderRadius.circular(80),
                  gradient: LinearGradient(
                    colors: [DesignCourseAppTheme.nearlyBlack.withOpacity(0.5), DesignCourseAppTheme.nearlyBlack],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              clipper: new WaveClipper(animationController.value, animList1),
            ),
            new ClipPath(
              child: new Neumorphic(style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(80)),
                color: DesignCourseAppTheme.nearlyBlack,
                depth: 3.5,
              )),
              clipper: new WaveClipper(animationController.value, animList2),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.percentageValue != 0 ? widget.percentageValue.round().toString() : "0", style: TextStyle(fontSize: 21, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text('%', style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 6,
              bottom: 8,
              child: new ScaleTransition(
                alignment: Alignment.center,
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 0,
              bottom: 16,
              child: new ScaleTransition(
                alignment: Alignment.center,
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 24,
              bottom: 32,
              child: new ScaleTransition(
                alignment: Alignment.center,
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0.6, 0.8, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 20,
              bottom: 0,
              child: new Transform(
                transform: new Matrix4.translationValues(0.0, 16 * (1.0 - animationController.value), 0.0),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(animationController.status == AnimationStatus.reverse ? 0.0 : 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => animation != oldClipper.animation;
}
