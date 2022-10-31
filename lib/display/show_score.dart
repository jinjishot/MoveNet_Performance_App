import 'package:flutter/material.dart';
import 'package:model_performance_app/display/submit.dart';

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
              child: Text('Total time = ', style: TextStyle(fontSize: 24, color: Colors.white)),
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
                    "Duration = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ",
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
                    "Duration = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ",
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
                    "Duration = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ",
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
                    "Duration = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Score = ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Frame / Sec = ",
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
