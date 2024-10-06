import 'package:flutter/material.dart';

import '../AppTheme.dart';

class Math_Probability extends StatefulWidget {
  @override
  _Math_ProbabilityState createState() => _Math_ProbabilityState();
}

class _Math_ProbabilityState extends State<Math_Probability> with TickerProviderStateMixin {
  final double infoHeight = 840.0;
  int current = 0;
  TextEditingController probabilityController = TextEditingController();
  int userInput = 0;
  int totalBalls = 10;
  List<Widget> probabilityDots = [];

  @override
  void dispose() {
    probabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignCourseAppTheme.nearlyWhite,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: DesignCourseAppTheme.nearlyWhite,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: DesignCourseAppTheme.grey.withOpacity(0.2), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 73.0, left: 45, right: 16),
                    child: Text(
                      'Probability and Statistics',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        letterSpacing: 0.27,
                        color: DesignCourseAppTheme.darkerText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          getTimeBoxUI('Basic Probability', current == 0, 0),
                          getTimeBoxUI('AND / OR', current == 1, 1),
                          getTimeBoxUI('Bayes', current == 2, 2),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 570,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: current == 0
                        ? basicProbability()
                        : current == 1
                            ? andProbability()
                            : bayesTheorem(context),
                  ),
                  Container(
                    height: 48,
                    margin: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    decoration: BoxDecoration(
                      color: DesignCourseAppTheme.nearlyBlue,
                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: DesignCourseAppTheme.nearlyBlue.withOpacity(0.5), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Mark as Completed',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          color: DesignCourseAppTheme.nearlyWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              width: AppBar().preferredSize.height,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: DesignCourseAppTheme.nearlyBlack,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getTimeBoxUI(String text1, bool color, int val) {
    return GestureDetector(
      onTap: () {
        setState(() {
          current = val;
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 160,
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: DesignCourseAppTheme.grey.withOpacity(0.25),
              offset: const Offset(2.1, 9.1),
              blurRadius: 16.0,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          decoration: BoxDecoration(
            color: color ? DesignCourseAppTheme.nearlyBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.27,
              color: color ? Colors.white : DesignCourseAppTheme.nearlyBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget basicProbability() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Example 1: Probability of getting heads when flipping a coin",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          Text(
            "The two outcomes (Heads and Tails) are represented by the blue and green dots below. The probability of each is 0.5 (50%).",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "The probability of getting either heads or tails is 0.5 for each.",
            style: TextStyle(fontSize: 14),
          ),
          Divider(height: 40, thickness: 1, color: Colors.grey[300]),
          Text(
            "The two outcomes (Heads and Tails) are represented by blue and green dots. Now, enter a probability value (0-100) to visualize it.",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          TextField(
            controller: probabilityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter probability (0-100)',
            ),
            onChanged: (value) {
              int parsedInput = int.tryParse(value) ?? 0;
              if (parsedInput > 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a value between 0 and 100'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              setState(() {
                userInput = parsedInput.clamp(0, 100);
                updateProbabilityDots();
              });
            },
          ),
          SizedBox(height: 16),
          if (userInput > 0)
            Text(
              "You entered: $userInput% probability. Green dots show success (probability), red dots show failure.",
              style: TextStyle(fontSize: 14),
            ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: probabilityDots,
          ),
          Divider(height: 40, thickness: 1, color: Colors.grey[300]),
          Text(
            "Green dots represent success, and red dots represent failure.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void updateProbabilityDots() {
    probabilityDots.clear();
    int greenDots = (userInput * totalBalls) ~/ 100;
    double remainingPercent = (userInput * totalBalls) % 100 / 100;

    for (int i = 0; i < greenDots; i++) {
      probabilityDots.add(
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    if (remainingPercent > 0) {
      probabilityDots.add(
        Stack(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 65 * remainingPercent,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    int redDots = totalBalls - greenDots - (remainingPercent > 0 ? 1 : 0);
    for (int i = 0; i < redDots; i++) {
      probabilityDots.add(
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      );
    }
  }




  final TextEditingController event1Controller = TextEditingController();
  final TextEditingController event2Controller = TextEditingController();
  int event1Input = 0;
  int event2Input = 0;
  Widget andProbability() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AND Probability Visualization",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "The probability of both events occurring is represented by the overlap of the two circles.",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(
                    right: calculateCircleMargin(event1Input),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(
                    left: calculateCircleMargin(event2Input),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: event1Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter probability for Event 1 (0-100)',
            ),
            onChanged: (value) {
              int event1Prob = int.tryParse(value) ?? 0;
              setState(() {
                event1Input = event1Prob.clamp(0, 100);
              });
            },
          ),
          SizedBox(height: 16),
          TextField(
            controller: event2Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter probability for Event 2 (0-100)',
            ),
            onChanged: (value) {
              int event2Prob = int.tryParse(value) ?? 0;
              setState(() {
                event2Input = event2Prob.clamp(0, 100);
              });
            },
          ),
          SizedBox(height: 16),
          if (event1Input > 0 || event2Input > 0)
            Text(
              "Calculated AND Probability: ${calculateAndProbability()}%",
              style: TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }
  double calculateCircleMargin(int eventInput) {
    double totalMovement = 120;
    double overlapFactor = 1 - (eventInput / 100);
    return totalMovement * overlapFactor;
  }
  double calculateAndProbability() {
    double prob1 = event1Input / 100;
    double prob2 = event2Input / 100;
    return (prob1 * prob2) * 100;
  }






  final TextEditingController pABController = TextEditingController();
  final TextEditingController pAController = TextEditingController();
  final TextEditingController pBController = TextEditingController();

  double pABInput = 0;
  double pAInput = 0;
  double pBInput = 0;

  Widget bayesTheorem(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bayes' Theorem Visualization",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Visualizing Bayes' Theorem with two sections.",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("Event A Section (Green)", style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate((pAInput / 10).toInt(), (index) {
                          return Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            margin: EdgeInsets.all(2),
                          );
                        }),
                        ...List.generate((10 - (pAInput / 10).toInt()).clamp(0, 10), (index) {
                          return Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            margin: EdgeInsets.all(2),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Column(
                children: [
                  Text("Event B Section (Blue)", style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate((pBInput / 10).toInt(), (index) {
                          return Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            margin: EdgeInsets.all(2),
                          );
                        }),
                        ...List.generate((10 - (pBInput / 10).toInt()).clamp(0, 10), (index) {
                          return Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            margin: EdgeInsets.all(2),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),
          TextField(
            controller: pAController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter P(A) (0-100)',
            ),
            onChanged: (value) {
              double pAProb = double.tryParse(value) ?? 0;
              setState(() {
                pAInput = pAProb.clamp(0, 100);
              });
            },
          ),
          SizedBox(height: 16),
          TextField(
            controller: pBController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter P(B) (0-100)',
            ),
            onChanged: (value) {
              double pBProb = double.tryParse(value) ?? 0;
              setState(() {
                pBInput = pBProb.clamp(0, 100);
              });
            },
          ),
          SizedBox(height: 16),

          TextField(
            controller: pABController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter P(B|A) (0-100)',
            ),
            onChanged: (value) {
              double pABProb = double.tryParse(value) ?? 0;
              setState(() {
                pABInput = pABProb.clamp(0, 100);
              });
            },
          ),
          SizedBox(height: 16),

          if (pAInput > 0 && pBInput > 0)
            Text(
              "Calculated P(A|B): ${calculateBayesProbability()}%",
              style: TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }

  double calculateBayesProbability() {
    if (pBInput == 0) return 0;
    return (pABInput * pAInput / pBInput);
  }

}
