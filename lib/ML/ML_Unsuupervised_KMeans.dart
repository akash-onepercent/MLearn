import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';
import '../AppTheme.dart';
import 'ML_Cover.dart';
import 'ML_Unsuupervised_Heirarchial.dart';

class KMeansClusteringVisualization extends StatefulWidget {
  @override
  _KMeansClusteringVisualizationState createState() => _KMeansClusteringVisualizationState();
}

class _KMeansClusteringVisualizationState extends State<KMeansClusteringVisualization> {
  List<Offset> dataPoints = [];
  List<Offset> clusterCentroids = [];
  List<List<Offset>> clusters = [];
  int numberOfClusters = 3;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateRandomPoints();
    fitKMeans();
  }

  void generateRandomPoints() {
    dataPoints = List.generate(50, (index) {
      return Offset(random.nextDouble() * 300, random.nextDouble() * 300);
    });
  }

  void fitKMeans() {
    clusters = List.generate(numberOfClusters, (_) => []);

    clusterCentroids = List.generate(numberOfClusters, (index) {
      return dataPoints[random.nextInt(dataPoints.length)];
    });

    bool centroidsChanged;

    do {
      centroidsChanged = false;

      for (var cluster in clusters) {
        cluster.clear();
      }

      for (var point in dataPoints) {
        double minDistance = double.infinity;
        int closestCentroidIndex = 0;

        for (int i = 0; i < clusterCentroids.length; i++) {
          double distance = (point - clusterCentroids[i]).distance;
          if (distance < minDistance) {
            minDistance = distance;
            closestCentroidIndex = i;
          }
        }
        clusters[closestCentroidIndex].add(point);
      }

      for (int i = 0; i < numberOfClusters; i++) {
        if (clusters[i].isNotEmpty) {
          double sumX = 0, sumY = 0;
          for (var point in clusters[i]) {
            sumX += point.dx;
            sumY += point.dy;
          }
          Offset newCentroid = Offset(sumX / clusters[i].length, sumY / clusters[i].length);

          if ((newCentroid - clusterCentroids[i]).distance > 1) {
            centroidsChanged = true;
          }
          clusterCentroids[i] = newCentroid;
        }
      }
    } while (centroidsChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        toolbarHeight: kToolbarHeight,
        backgroundColor: DesignCourseAppTheme.nearlyBlack,
        title: Text("K-Means Clustering", style: TextStyle(color: Colors.white),),
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
              "KMeans clustering groups data points into distinct clusters based on their similarity, minimizing variance within each cluster. It iteratively assigns points to the nearest cluster center and updates the centers for better accuracy.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 16),
              height: 330,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    painter: KMeansPainter(dataPoints, clusterCentroids, clusters),
                    size: Size.infinite,
                  ),
                ],
              ),
            ),
            Slider(
              min: 1,
              max: 10,
              divisions: 9,
              label: numberOfClusters.toString(),
              value: numberOfClusters.toDouble(),
              onChanged: (value) {
                setState(() {
                  numberOfClusters = value.toInt();
                  fitKMeans();
                });
              },
            ),
            Text(
              "Number of Clusters: $numberOfClusters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 70,),
            Row(
              children: [
                getTimeBoxUI("Proceed", () {
                  GetStorage().write("K-Means Clustering", true);
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => HierarchicalClusteringDemo(),
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

class KMeansPainter extends CustomPainter {
  final List<Offset> points;
  final List<Offset> centroids;
  final List<List<Offset>> clusters;

  KMeansPainter(this.points, this.centroids, this.clusters);

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()..color = Colors.blue;
    final centroidPaint = Paint()..color = Colors.red;

    for (var point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }

    for (int i = 0; i < clusters.length; i++) {
      for (var point in clusters[i]) {
        canvas.drawCircle(point, 5, Paint()..color = Color.fromARGB(255, 100 + i * 30, 100 + i * 50, 255));
      }
    }

    for (var centroid in centroids) {
      canvas.drawCircle(centroid, 7, centroidPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
