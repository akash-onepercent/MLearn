import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';

import '../AppTheme.dart';
import 'ML_Cover.dart';

class LogisticRegressionVisualization extends StatefulWidget {
  @override
  _LogisticRegressionVisualizationState createState() => _LogisticRegressionVisualizationState();
}

class _LogisticRegressionVisualizationState extends State<LogisticRegressionVisualization> {
  double coefficient = 1.0;
  double intercept = 0.0;
  double inputValue = 0.0;
  double boundary = 0.5;
  List<FlSpot> dataPoints = [];

  @override
  void initState() {
    super.initState();
    generateDataPoints();
  }

  void generateDataPoints() {
    dataPoints = List.generate(100, (index) {
      double x = index / 10.0 - 5;
      double y = logisticFunction(x);
      return FlSpot(x, y);
    });
  }

  double logisticFunction(double x) {
    return 1 / (1 + exp(-(coefficient * x + intercept)));
  }

  @override
  Widget build(BuildContext context) {
    double predictedProbability = logisticFunction(inputValue);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        toolbarHeight: kToolbarHeight,
        backgroundColor: DesignCourseAppTheme.nearlyBlack,
        title: Text("Logistic Regression", style: TextStyle(color: Colors.white)),
        leadingWidth: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Column(
          children: [
            Text(
              "Logistic regression predicts the probability of an outcome using the logistic function. "
                  "Change the input value to see how it gets squashed between 0 and 1!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  minX: -5,
                  maxX: 5,
                  minY: 0,
                  maxY: 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(-5, boundary),
                        FlSpot(5, boundary),
                      ],
                      isCurved: false,
                      color: Colors.red,
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Input Value (X)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  inputValue = double.tryParse(value) ?? 0.0;
                  generateDataPoints();
                });
              },
            ),
            SizedBox(height: 8),
            Text(
              "Sigmoid Function Result: ${predictedProbability.toStringAsFixed(8)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Decision Boundary: ${boundary.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: boundary,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  boundary = value;
                });
              },
            ),
            SizedBox(height: 8),
            Text(
              "Result: ${predictedProbability >= boundary ? '1 (True)' : '0 (False)'}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DesignCourseAppTheme.nearlyBlack),
            ),


            SizedBox(height: 25),
            Row(
              children: [
                getTimeBoxUI("Finish", () {
                  GetStorage().write("Logistic Regression", true);
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => ML_Cover(),
                    ),
                  );
                }, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text, Function method, [bool half = true]) {
    return GestureDetector(
      onTap: () => method(),
      child: Container(
        height: 46,
        margin: EdgeInsets.all(8),
        width: half ? 150 : 315,
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: DesignCourseAppTheme.nearlyBlack,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.27,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
