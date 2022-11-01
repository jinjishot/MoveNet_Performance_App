import 'package:flutter/material.dart';
import 'package:model_performance_app/display/show_score.dart';
import 'package:model_performance_app/model/score.dart';
import 'package:model_performance_app/utility/predicted.dart';

Score score = Score(
  score: [0, 0, 0, 0],
  duration: ['', '', '', ''],
  frame_sec: [0, 0, 0, 0],
);

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  PredictedKeypoint predict = PredictedKeypoint();
  bool _isVisble = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red],
          )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isVisble)
                  Text("MoveNet Performance",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                if (!_isVisble)
                  Text(
                    'Wait for a moment...',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                SizedBox(
                  height: 40,
                ),
                if (_isVisble)
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isVisble = false;
                      });
                      await predict.predicted();

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return ShowScore();
                      }));
                    },
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                if (!_isVisble) CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
