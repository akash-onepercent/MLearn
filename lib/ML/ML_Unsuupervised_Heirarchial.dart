import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get_storage/get_storage.dart';
import '../AppTheme.dart';
import 'ML_Cover.dart';

class HierarchicalClusteringDemo extends StatefulWidget {
  @override
  _HierarchicalClusteringDemoState createState() => _HierarchicalClusteringDemoState();
}

class _HierarchicalClusteringDemoState extends State<HierarchicalClusteringDemo> {
  final List<Offset> points = [];
  final Random random = Random();
  int numberOfClusters = 5;
  List<List<Offset>> clusters = [];

  @override
  void initState() {
    super.initState();
    generateRandomPoints();
    updateClusters();
  }

  void generateRandomPoints() {
    for (int i = 0; i < 50; i++) {
      points.add(Offset(random.nextDouble() * 300, random.nextDouble() * 300));
    }
  }

  void updateClusters() {
    setState(() {
      clusters = hierarchicalClustering(points, numberOfClusters);
    });
  }

  List<List<Offset>> hierarchicalClustering(List<Offset> points, int clusterCount) {
    List<List<Offset>> clusters = points.map((point) => [point]).toList();

    while (clusters.length > clusterCount) {
      double minDistance = double.infinity;
      int cluster1 = -1, cluster2 = -1;

      for (int i = 0; i < clusters.length; i++) {
        for (int j = i + 1; j < clusters.length; j++) {
          double distance = calculateClusterDistance(clusters[i], clusters[j]);
          if (distance < minDistance) {
            minDistance = distance;
            cluster1 = i;
            cluster2 = j;
          }
        }
      }

      clusters[cluster1].addAll(clusters[cluster2]);
      clusters.removeAt(cluster2);
    }

    return clusters;
  }

  double calculateClusterDistance(List<Offset> cluster1, List<Offset> cluster2) {
    Offset centroid1 = calculateCentroid(cluster1);
    Offset centroid2 = calculateCentroid(cluster2);
    return (centroid1 - centroid2).distance;
  }

  Offset calculateCentroid(List<Offset> cluster) {
    double x = cluster.map((p) => p.dx).reduce((a, b) => a + b) / cluster.length;
    double y = cluster.map((p) => p.dy).reduce((a, b) => a + b) / cluster.length;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        toolbarHeight: kToolbarHeight,
        backgroundColor: DesignCourseAppTheme.nearlyBlack,
        title: Text("Hierarchical Clustering", style: TextStyle(color: Colors.white),),
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
              'Hierarchical clustering builds a hierarchy of clusters by either merging or splitting them based on similarity. It produces a tree-like structure (dendrogram) that helps visualize the relationships between clusters at different levels.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Container(
              height: 330,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: CustomPaint(
                painter: ClusteringPainter(points, clusters),
                size: Size.infinite,
              ),
            ),
            SizedBox(height: 9),
            Slider(
              min: 2,
              max: 10,
              divisions: 8,
              label: numberOfClusters.toString(),
              value: numberOfClusters.toDouble(),
              onChanged: (value) {
                setState(() {
                  numberOfClusters = value.toInt();
                  updateClusters();
                });
              },
            ),
            SizedBox(height: 9),
            Text(
              "Number of Clusters: $numberOfClusters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 65,),
            Row(
              children: [
                getTimeBoxUI("Finish", () {
                  GetStorage().write("Hierarchical Clustering", true);
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => ML_Cover(),
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

class ClusteringPainter extends CustomPainter {
  final List<Offset> points;
  final List<List<Offset>> clusters;

  ClusteringPainter(this.points, this.clusters);

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()..color = Colors.blue;
    final linePaint = Paint()..color = Colors.black..strokeWidth = 1.0;
    final clusterColors = [
      Colors.red, Colors.green, Colors.yellow, Colors.purple, Colors.orange,
      Colors.brown, Colors.pink, Colors.teal, Colors.cyan, Colors.lime
    ];

    for (var cluster in clusters) {
      if (cluster.length > 1) {
        for (int i = 0; i < cluster.length - 1; i++) {
          canvas.drawLine(cluster[i], cluster[i + 1], linePaint);
        }
      }
    }

    for (int i = 0; i < clusters.length; i++) {
      final clusterPaint = Paint()..color = clusterColors[i % clusterColors.length];
      for (var point in clusters[i]) {
        canvas.drawCircle(point, 5, clusterPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
