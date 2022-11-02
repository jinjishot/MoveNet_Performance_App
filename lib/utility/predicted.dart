import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

import 'package:export_video_frame/export_video_frame.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'classifier.dart';
import 'isolate.dart';
import 'package:model_performance_app/display/start_page.dart';


class PredictedKeypoint {
  final totalFrame = 100; //2878

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  late Classifier classifier;
  late IsolateUtils isolate;

  predicted() async {
    isolate = IsolateUtils();
    await isolate.start();
    classifier = Classifier();
    // await classifier.loadModel();

    var response = await rootBundle.load('assets/break_dance.mp4');
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/break_dance.mp4");
    file.writeAsBytesSync(response.buffer.asInt8List());

    _stopWatchTimer.onStartTimer();

    var imgFile = await ExportVideoFrame.exportImage(file.path, totalFrame, 1);

    //pull keypoints
    await FirebaseFirestore.instance.collection('keypoint').doc('keypoints').get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>;
        for(var j=0; j<4; j++) {
          String modelName = 'movenet_thunder_float16.tflite';
          int inputSize = 256;
          if(j == 1) {
            modelName = 'movenet_thunder_int8.tflite';
            inputSize = 256;
          }
          else if(j == 2) {
            modelName = 'movenet_lightning_float16.tflite';
            inputSize = 192;
          }
          else if(j == 3){
            modelName = 'movenet_lightning_int8.tflite';
            inputSize = 192;
          }
          await classifier.loadModel(asset: modelName);

          final StopWatchTimer _stopWatchModel = StopWatchTimer();
          _stopWatchModel.onStartTimer();
          for (var i = 0; i < totalFrame; i++) {
            image_lib.Image img =
            image_lib.decodeImage(File(imgFile[i].path).readAsBytesSync())!;
            // print('Frame ${i + 1}');
            await createIsolate(img, data['frame${i+1}'], inputSize, j);
          }
          _stopWatchModel.onStopTimer();
          _stopWatchModel.rawTime.listen((value) {
            score.duration[j] = StopWatchTimer.getDisplayTime(value);
            
            var minute = int.parse(StopWatchTimer.getDisplayTimeMinute(value)) * 60;
            var seconds = int.parse(StopWatchTimer.getDisplayTimeSecond(value));
            var millisec = int.parse(StopWatchTimer.getDisplayTimeMillisecond(value)) / 1000;

            score.frame_sec[j] = double.parse((100 / (minute + seconds + millisec)).toStringAsFixed(2));
           });
          score.score[j] = double.parse((score.score[j] / 100).toStringAsFixed(2));
        }
    
        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.rawTime.listen((value) {
          score.totalTime = StopWatchTimer.getDisplayTime(value);
          // print(score.totalTime);
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future createIsolate(image_lib.Image image, keypoint, inputSize, count) async {
      var isolateData = IsolateData(image, classifier.interpreter.address, inputSize);
      List<dynamic> inferenceResults = await inference(isolateData);

      //BBox
      int x_max = 0;
      int y_max = 0;
      int x_min = keypoint['0'][0];
      int y_min = keypoint['0'][1];
      for(var i=0; i<17; i++) {
        int x = keypoint['${i}'][0];
        int y = keypoint['${i}'][1];

        if(x > x_max) {
          x_max = x;
        }
        if(x < x_min) {
          x_min = x;
        }
        if(y > y_max) {
          y_max = y;
        }
        if(y < y_min) {
          y_min = y;
        }
      }

      //OKS
      double oks_score = 0;
      var sigmas = [0.026, 0.025, 0.025, 0.035, 0.035, 0.079, 0.079, 0.072, 0.072, 0.062, 0.062, 0.107, 0.107, 0.087, 0.087, 0.089, 0.089];
      List<dynamic> vars = [];
      for(var i=0; i<sigmas.length; i++) {
        vars.add(pow((2 * sigmas[i]), 2));
      }
      var src_area = (x_max - x_min + 1) * (y_max - y_min + 1);
      for(var i=0; i<17; i++) {
        int ori_x = keypoint['${i}'][0];
        int ori_y = keypoint['${i}'][1];
        int cov_x = inferenceResults[i][0];
        int cov_y = inferenceResults[i][1];

        var dx = ori_x - cov_x;
        var dy = ori_y - ori_y;

        var e = ((pow(dx,2) + pow(dy, 2)) / vars[i] / src_area / 2);
        oks_score += exp(-e) / 17;
      }
      // print("oks score = $oks_score");
      // score += oks_score;
      score.score[count] += oks_score;
  }
  
  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }
}
