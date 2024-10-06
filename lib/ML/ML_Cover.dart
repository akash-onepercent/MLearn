import 'package:learn/HomePage.dart';
import 'package:learn/AppTheme.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get_storage/get_storage.dart';
import 'ML_Reinforcement_Q.dart';
import 'ML_Supervised_Polynomial.dart';
import 'ML_Unsuupervised_KMeans.dart';
import 'Wave.dart';

class ML_Cover extends StatefulWidget {
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<ML_Cover> with TickerProviderStateMixin {
  var data = [
    {
      "Heading": "Supervised Learning",
      "Completed": [],
      "NotCompleted": [],
      "Class": 0,
      "Tutorials": ["Polynomial Regression", "Logistic Regression"],
    },
    {
      "Heading": "Unsupervised Learning",
      "Completed": [],
      "NotCompleted": [],
      "Class": 1,
      "Tutorials": ["K-Means Clustering", "Hierarchical Clustering"],
    },
    {
      "Heading": "Reinforcement Learning",
      "Completed": [],
      "NotCompleted": [],
      "Class": 2,
      "Tutorials": ["Monte Carlo"],
    },
  ];

  GetStorage storage = GetStorage();

  @override
  void initState() {
    _loadTutorials();
    super.initState();
  }

  Future<void> _loadTutorials() async {
    for (var item in data) {
      List<String> completed = [];
      List<String> notCompleted = [];

      var tutorials = item["Tutorials"];

      if (tutorials is List<String>) {
        for (var tutorial in tutorials) {
          bool status = await storage.read(tutorial);
          if (status) {
            completed.add(tutorial);
          } else {
            notCompleted.add(tutorial);
          }
        }
      }

      item["Completed"] = completed;
      item["NotCompleted"] = notCompleted;
    }

    setState(() {
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        toolbarHeight: kToolbarHeight,
        backgroundColor: DesignCourseAppTheme.nearlyBlack,
        title: Text(
          "Machine Learning",
          style: TextStyle(color: Colors.white),
        ),
        leadingWidth: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => HomePage(),
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        padding: EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (BuildContext context, int index) {
          var completed = (data[index]["Completed"] is Iterable) ? List<String>.from(data[index]["Completed"] as Iterable) : <String>[];

          var notCompleted = (data[index]["NotCompleted"] is Iterable) ? List<String>.from(data[index]["NotCompleted"] as Iterable) : <String>[];

          return Neumorphic(
            margin: EdgeInsets.fromLTRB(24, 4, 22, 18),
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
              color: Colors.transparent,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 210,
                          padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 10),
                                  child: Text(
                                    data[index]["Heading"].toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: DesignCourseAppTheme.nearlyBlack,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: completed.isNotEmpty,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: (28.0 * completed.length + 17),
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF87A0E5),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4, bottom: 2),
                                              child: Text('Completed'),
                                            ),
                                            Container(
                                              height: 28.0 * completed.length,
                                              width: MediaQuery.of(context).size.width / 2,
                                              child: ListView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: completed.length,
                                                itemBuilder: (BuildContext ctxt, int i) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 25,
                                                        height: 25,
                                                        child: Image.asset("assets/positive.png"),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 4, bottom: 2),
                                                          child: Text(
                                                            completed[i],
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: DesignCourseAppTheme.nearlyBlack.withOpacity(0.7),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Visibility(
                                  visible: notCompleted.isNotEmpty,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 0),
                                        height: (28.0 * notCompleted.length + 17),
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF56E98),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 4, bottom: 2),
                                              child: Text('Topics Remaining'),
                                            ),
                                            Container(
                                              height: 28.0 * notCompleted.length,
                                              width: MediaQuery.of(context).size.width / 2,
                                              child: ListView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: notCompleted.length,
                                                itemBuilder: (BuildContext ctxt, int i) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 25,
                                                        height: 25,
                                                        child: Image.asset("assets/negative.png"),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 4, bottom: 2),
                                                          child: Text(
                                                            notCompleted[i],
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: DesignCourseAppTheme.nearlyBlack.withOpacity(0.7),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 8, 0),
                        child: Container(
                          width: 55,
                          height: 155,
                          decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyBlack.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(80),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: DesignCourseAppTheme.nearlyBlack.withOpacity(0.1),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: WaveView(
                            percentageValue: completed.isNotEmpty ? (completed.length / (completed.length + notCompleted.length)) * 100 : 0,
                            value: 155,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: completed.isNotEmpty && notCompleted.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 100,
                      child: Neumorphic(
                        padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                          color: DesignCourseAppTheme.nearlyBlack,
                          depth: 3.5,
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          onPressed: () {
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => data[index]["Class"] == 0
                                    ? PolynomialRegressionVisualization()
                                    : data[index]["Class"] == 1
                                        ? KMeansClusteringVisualization()
                                        : MonteCarloVisualization(),
                              ),
                            );
                          },
                          child: Text(
                            "Understand AI",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
