import 'dart:math';

import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Classifier {
  late Interpreter _interpreter;
  late ImageProcessor imageProcessor;
  late TensorImage inputImage;
  late List<Object> inputs;

  Map<int, Object> outputs = {};
  TensorBuffer outputLocations = TensorBufferFloat([]);

  Classifier({Interpreter? interpreter}) {
    loadModel(interpreter: interpreter);
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void performOperations(image_lib.Image cameraImage, inputSize) {
    inputImage = TensorImage(TfLiteType.uint8);
    inputImage.loadImage(cameraImage);
    inputImage = getProcessedImage(inputSize);

    inputs = [inputImage.buffer];
  }

  TensorImage getProcessedImage(inputSize) {
    int padSize = max(inputImage.height, inputImage.width);
    imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(padSize, padSize))
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  runModel() async {
    Map<int, Object> outputs = {0: outputLocations.buffer};
    interpreter.runForMultipleInputs(inputs, outputs);
  }

  loadModel({Interpreter? interpreter, asset}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            asset,
            // options: InterpreterOptions()..threads = 4,
            options: InterpreterOptions(),
          );
    } catch (e) {
      print("Error while creating interpreter: $e");
    }

    // var outputTensors = interpreter?.getOutputTensors();
    // var inputTensors = interpreter?.getInputTensors();
    // List<List<int>> _outputShapes = [];

    // outputTensors?.forEach((tensor) {
    //   print("Output Tensor: " + tensor.toString());
    //   _outputShapes.add(tensor.shape);
    // });
    // inputTensors?.forEach((tensor) {
    //   print("Input Tensor: " + tensor.toString());
    // });

    // print("------------------[A}========================\n" +
    //     _outputShapes.toString());

    outputLocations = TensorBufferFloat([1, 1, 17, 3]);
  }

  parseLandmarkData() {
    List outputParsed = [];
    List<double> data = outputLocations.getDoubleList();
    List result = [];
    var x, y, c;

    for (var i = 0; i < 51; i += 3) {
      y = (((data[0 + i] - 0.21875) / (1 - (2 * 0.21875))) * 1080)
          .toInt(); //640
      x = (data[1 + i] * 1920).toInt(); //480
      c = (data[2 + i]);
      result.add([x, y, c]);
    }
    outputParsed = result;

    // print("\n");
    // printWrapped(outputParsed.toString());
    // print("\n");

    return result;
  }

  Interpreter get interpreter => _interpreter;
}
