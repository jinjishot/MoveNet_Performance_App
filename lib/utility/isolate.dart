import 'dart:isolate';

import 'package:image/image.dart' as image_lib;
import 'classifier.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateUtils {
  static const String DEBUG_NAME = "InferenceIsolate";

  late Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      if (isolateData != null) {
        Classifier classifier = Classifier(
            interpreter:
                Interpreter.fromAddress(isolateData.interpreterAddress));
        classifier.performOperations(isolateData.cameraImage, isolateData.inputSize);
        classifier.runModel();
        List<dynamic> results = classifier.parseLandmarkData();
        isolateData.responsePort.send(results);
      }
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  image_lib.Image cameraImage;
  int interpreterAddress;
  late SendPort responsePort;
  int inputSize;

  IsolateData(this.cameraImage, this.interpreterAddress, this.inputSize);
}