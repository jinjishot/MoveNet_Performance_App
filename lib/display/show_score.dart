import 'package:flutter/material.dart';
import 'package:model_performance_app/display/submit.dart';
import 'start_page.dart';

class ShowScore extends StatefulWidget {
  const ShowScore({super.key});

  @override
  State<ShowScore> createState() => _ShowScoreState();
}

class _ShowScoreState extends State<ShowScore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.red],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'Result',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(55, 35, 0, 0),
              child: Text('Total time = ${score.totalTime}', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(55, 30, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MoveNet Thunder Float 16",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    "Duration = ${score.duration[0]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ${score.score[0]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ${score.frame_sec[0]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(55, 30, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MoveNet Thunder Int 8",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    "Duration = ${score.duration[1]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ${score.score[1]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ${score.frame_sec[1]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(55, 30, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MoveNet Thunder Float 16",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    "Duration = ${score.duration[2]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ${score.score[2]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ${score.frame_sec[2]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(55, 30, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MoveNet Thunder Int 8",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    "Duration = ${score.duration[3]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ${score.score[3]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ${score.frame_sec[3]}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return Submit();
                  }));
                }, 
                child: Text('Next', style: TextStyle(fontSize: 18),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
