import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:export_video_frame/export_video_frame.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:model_performance_app/display/start_page.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'classifier.dart';
import 'isolate.dart';
import 'package:image/image.dart' as image_lib;

class PredictedKeypoint {
  late List<image_lib.Image> images = <image_lib.Image>[]; //out of memory
  final totalFrame = 100; //2878

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  late Classifier classifier;
  late IsolateUtils isolate;

  final ImagePicker _picker = ImagePicker();
  // bool predicting = false;
  // bool initialized = false;
  // double score = 0;

  predicted() async {
    isolate = IsolateUtils();
    await isolate.start();
    classifier = Classifier();
    await classifier.loadModel();

    // score.score![0] = 0;

    XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    _stopWatchTimer.onStartTimer();

    var imgFile = await ExportVideoFrame.exportImage(file!.path, totalFrame, 1);

    //pull keypoints
    FirebaseFirestore.instance.collection('keypoint').doc('keypoints').get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>;
        for (var i = 0; i < totalFrame; i++) {
          image_lib.Image img =
          image_lib.decodeImage(File(imgFile[i].path).readAsBytesSync())!;
          // print('Frame ${i + 1}');
          await createIsolate(img, data['frame${i+1}']);
        }
        print('total score = ${score.score[0]/100}');
    
        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.rawTime.listen((value) {
          score.duration[0] = StopWatchTimer.getDisplayTime(value);
          print(score.duration[0]);

          var time = StopWatchTimer.getDisplayTimeSecond(value);
          score.frame_sec[0] = 100 / int.parse(time);
          print('Frame/Sec = ${score.frame_sec[0]}');
        });
      } else {
        print('Document does not exist on the database');
      }
    });

    //convert file to Image
    // for (var i = 0; i < totalFrame; i++) {
    //   image_lib.Image img =
    //       image_lib.decodeImage(File(imgFile[i].path).readAsBytesSync())!;
    //   // images.add(img);
    //   print('Frame ${i + 1}');
    //   await createIsolate(img);
    // }
  }

  Future createIsolate(image_lib.Image image, keypoint) async {
    var isolateData = IsolateData(image, classifier.interpreter.address);
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
    // var vars = <dynamic>[];
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
    score.score[0] += oks_score;
  }

  // Future uploadKeypoint(List<dynamic> inferences) async {
  //   await FirebaseFirestore.instance.doc(path!).collection('keypoint').doc("frame${count_frame}").set({
  //       "0" : inferences[0], "1": inferences[1], "2": inferences[2], "3": inferences[3],
  //       "4": inferences[4], "5": inferences[5], "6": inferences[6], "7": inferences[7], "8": inferences[8],
  //       "9": inferences[9], "10": inferences[10], "11": inferences[11], "12": inferences[12], "13": inferences[13],
  //       "14": inferences[14], "15": inferences[15], "16": inferences[16]
  //   });
  // }

  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }
}
