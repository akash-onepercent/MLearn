import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:get_storage/get_storage.dart';
import '../AppTheme.dart';
import 'ML_Cover.dart';
import 'ML_Supervised_Logistic.dart';

class PolynomialRegressionVisualization extends StatefulWidget {
  @override
  _PolynomialRegressionVisualizationState createState() => _PolynomialRegressionVisualizationState();
}

class _PolynomialRegressionVisualizationState extends State<PolynomialRegressionVisualization> {
  int polynomialDegree = 1;
  List<FlSpot> dataPoints = [];
  List<double> coefficients = [];
  int totalPoints = 25;

  @override
  void initState() {
    super.initState();
    generateLinearData();
    fitPolynomial();
  }

  void generateLinearData() {
    dataPoints = List.generate(totalPoints, (index) {
      double x = index.toDouble();
      double y = 2.0 * x + 3.0 + Random().nextDouble() * 10;
      return FlSpot(x, y);
    });
  }

  void fitPolynomial() {
    List<double> X = dataPoints.map((spot) => spot.x).toList();
    List<double> Y = dataPoints.map((spot) => spot.y).toList();
    coefficients = computePolynomialCoefficients(X, Y, polynomialDegree);
  }

  List<double> computePolynomialCoefficients(List<double> X, List<double> Y, int degree) {
    List<List<double>> matrix = List.generate(degree + 1, (i) => List.filled(degree + 1, 0.0));
    List<double> rightSide = List.filled(degree + 1, 0.0);

    for (int i = 0; i <= degree; i++) {
      for (int j = 0; j <= degree; j++) {
        matrix[i][j] = X.map((x) => pow(x, i + j).toDouble()).reduce((a, b) => a + b);
      }
      rightSide[i] = X.asMap().entries.map((entry) => pow(entry.value, i) * Y[entry.key]).reduce((a, b) => a + b);
    }

    return solveMatrix(matrix, rightSide);
  }

  List<double> solveMatrix(List<List<double>> matrix, List<double> rightSide) {
    int n = matrix.length;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        if (matrix[j][i].abs() > matrix[i][i].abs()) {
          List<double> temp = matrix[i];
          matrix[i] = matrix[j];
          matrix[j] = temp;

          double tmp = rightSide[i];
          rightSide[i] = rightSide[j];
          rightSide[j] = tmp;
        }
      }

      for (int j = i + 1; j < n; j++) {
        double factor = matrix[j][i] / matrix[i][i];
        rightSide[j] -= factor * rightSide[i];
        for (int k = i; k < n; k++) {
          matrix[j][k] -= factor * matrix[i][k];
        }
      }
    }

    List<double> solution = List.filled(n, 0.0);
    for (int i = n - 1; i >= 0; i--) {
      double sum = rightSide[i];
      for (int j = i + 1; j < n; j++) {
        sum -= matrix[i][j] * solution[j];
      }
      solution[i] = sum / matrix[i][i];
    }

    return solution;
  }

  double predict(double x) {
    double y = 0.0;
    for (int i = 0; i < coefficients.length; i++) {
      y += coefficients[i] * pow(x, i);
    }
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        toolbarHeight: kToolbarHeight,
        backgroundColor: DesignCourseAppTheme.nearlyBlack,
        title: Text("Supervised Learning", style: TextStyle(color: Colors.white),),
        leadingWidth: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => ML_Cover(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Column(
          children: [
            Text(
              "Polynomial regression fits a curve to the data points by increasing the degree of the polynomial. "
              "Slide the degree to see how the curve changes!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: totalPoints.toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: false,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: List.generate(totalPoints, (index) {
                        double x = index.toDouble();
                        return FlSpot(x, predict(x));
                      }),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                getTimeBoxUI("Increase Degree", () {
                  setState(() {
                    polynomialDegree++;
                    fitPolynomial();
                  });
                }),
                getTimeBoxUI("Decrease Degree", () {
                  setState(() {
                    polynomialDegree--;
                    fitPolynomial();
                  });
                }),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Degree of Polynomial: $polynomialDegree",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25,),
            Row(
              children: [
                getTimeBoxUI("Proceed", () {
                  GetStorage().write("Polynomial Regression", true);
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => LogisticRegressionVisualization(),
                    ),
                  );
                }, false)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text, method, [bool half = true]) {
    return GestureDetector(
      onTap: method,
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
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
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
