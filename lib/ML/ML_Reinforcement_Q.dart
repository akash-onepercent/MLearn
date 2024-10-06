import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../AppTheme.dart';
import 'ML_Cover.dart';

class MonteCarloVisualization extends StatefulWidget {
  @override
  _MonteCarloVisualizationState createState() => _MonteCarloVisualizationState();
}

class _MonteCarloVisualizationState extends State<MonteCarloVisualization> {
  final int gridSize = 4;
  final int episodes = 100;
  final double learningRate = 0.1;
  final double discountFactor = 0.9;
  late List<List<double>> qValues;
  late List<List<int>> rewards;
  Random random = Random();
  int currentEpisode = 0;
  int totalReward = 0;
  int previousTotalReward = 0;
  double improvementPercentage = 0.0;
  int currentX = 0;
  int currentY = 0;
  late int maxX, maxY;
  bool running = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    maxX = gridSize - 1;
    maxY = gridSize - 1;
    qValues = List.generate(gridSize, (i) => List.generate(gridSize, (j) => 0.0));
    rewards = List.generate(gridSize, (i) => List.generate(gridSize, (j) => 0));

    rewards[0][0] = 0;
    rewards[1][1] = 10;
    rewards[2][2] = 5;
    rewards[3][3] = -1;
  }

  void runEpisode() {
    setState(() {
      running = true;
      currentEpisode = 0;
      totalReward = 0;
      previousTotalReward = 0;
      improvementPercentage = 0.0;
      currentX = 0;
      currentY = 0;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentEpisode < episodes) {
        totalReward = 0;
        currentX = 0;
        currentY = 0;
        List<int> episodeStates = [];

        while (currentX != maxX || currentY != maxY) {
          int action = chooseAction(currentX, currentY);
          episodeStates.add(currentX * gridSize + currentY);

          setState(() {
            totalReward += rewards[currentX][currentY];
            if (action == 0 && currentX < maxX) currentX++;
            if (action == 1 && currentY < maxY) currentY++;
            if (action == 2 && currentX > 0) currentX--;
            if (action == 3 && currentY > 0) currentY--;
          });

          if (currentX == maxX && currentY == maxY) break;
        }

        for (int state in episodeStates) {
          int x = state ~/ gridSize;
          int y = state % gridSize;
          qValues[x][y] += learningRate * (totalReward + discountFactor * maxQ(currentX, currentY) - qValues[x][y]);
        }

        if (currentEpisode > 0) {
          improvementPercentage = ((totalReward - previousTotalReward) / previousTotalReward) * 100;
        }
        previousTotalReward = totalReward;

        setState(() {
          currentEpisode++;
        });
      } else {
        timer.cancel();
        setState(() {
          running = false;
        });
      }
    });
  }

  void stopSimulation() {
    timer?.cancel();
    setState(() {
      running = false;
    });
  }

  int chooseAction(int x, int y) {
    if (random.nextDouble() < 0.1) {
      return random.nextInt(4);
    } else {
      double maxQValue = -double.infinity;
      int bestAction = 0;

      for (int action = 0; action < 4; action++) {
        int newX = x, newY = y;
        if (action == 0 && newX < maxX) newX++;
        if (action == 1 && newY < maxY) newY++;
        if (action == 2 && newX > 0) newX--;
        if (action == 3 && newY > 0) newY--;

        if (qValues[newX][newY] > maxQValue) {
          maxQValue = qValues[newX][newY];
          bestAction = action;
        }
      }
      return bestAction;
    }
  }

  double maxQ(int x, int y) {
    double maxValue = -double.infinity;
    for (int action = 0; action < 4; action++) {
      int newX = x, newY = y;
      if (action == 0 && newX < maxX) newX++;
      if (action == 1 && newY < maxY) newY++;
      if (action == 2 && newX > 0) newX--;
      if (action == 3 && newY > 0) newY--;

      if (qValues[newX][newY] > maxValue) {
        maxValue = qValues[newX][newY];
      }
    }
    return maxValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        toolbarHeight: kToolbarHeight,
        backgroundColor: DesignCourseAppTheme.nearlyBlack,
        title: Text("Monte Carlo Simulation", style: TextStyle(color: Colors.white),),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                "This simulation demonstrates how an agent learns to maximize rewards in a grid environment using Monte Carlo methods. The agent updates its action values (Q-values) based on the rewards received, gradually learning the best actions to take.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(26, 3, 26, 0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                  ),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    int x = index ~/ gridSize;
                    int y = index % gridSize;
                    return Container(
                      decoration: BoxDecoration(
                        color: (currentX == x && currentY == y) ? Colors.yellow : Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          "${qValues[x][y].toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                "Episode: $currentEpisode | Total Reward: $totalReward",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Improvement: ${improvementPercentage.toStringAsFixed(2)}%",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DesignCourseAppTheme.nearlyBlack),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getTimeBoxUI(running ? "Running..." : "Run Episodes", runEpisode),
                  getTimeBoxUI("Stop", stopSimulation),
                ],
              ),
              SizedBox(height: 12),
              getTimeBoxUI("Finish", () {
                GetStorage().write("Monte Carlo", true);
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => ML_Cover(),
                  ),
                );
              }, false),
            ],
          ),
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
