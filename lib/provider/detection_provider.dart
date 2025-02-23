import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:realtime_obj_detection/RealTimeObjectDetection.dart';
import 'package:realtime_obj_detection/result_screen.dart';
import 'package:tflite_v2/tflite_v2.dart';

class DetectionProvider extends ChangeNotifier {
  CameraController get controller => _controller;
  late CameraController _controller;
  List<dynamic>? recognitions;
  bool isModelLoaded = false;
  bool isCapturing = false;
  bool isObjectFar = false;
  final List<CameraDescription> cameras;

  DetectionProvider(this.cameras) {
    initializeCamera(cameras[0]);
    loadModel();
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/detect.tflite',
      labels: 'assets/labelmap.txt',
    );
    isModelLoaded = res != null;
    notifyListeners();
  }

  void toggleCamera() {
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription = cameras.firstWhere(
      (description) => description.lensDirection != lensDirection,
    );
    initializeCamera(newDescription);
  }

  void initializeCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.high);
    await _controller.initialize();
    _controller.startImageStream((image) => runModel(image));
    notifyListeners();
  }

  void runModel(CameraImage image) async {
    if (!isModelLoaded || image.planes.isEmpty) return;

    var results = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      model: 'SSDMobileNet',
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    recognitions =
        results?.where((rec) => rec["confidenceInClass"] > 0.4).toList();
    isObjectFar = recognitions?.any((rec) => rec["rect"]["w"] < 0.4) ?? false;
    notifyListeners();
  }

  Future<void> captureImage(String objectName) async {
    isCapturing = true;
    notifyListeners();
    try {
      XFile image = await _controller.takePicture();
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (_) =>
                  ResultScreen(imagePath: image.path, objectName: objectName),
        ),
      );
    } finally {
      isCapturing = false;
      notifyListeners();
    }
  }

  void disposeController() {
    _controller.dispose();
    notifyListeners();
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

class ObjectSelectionScreen extends StatelessWidget {
  static const List<String> objects = ['Laptop', 'Mobile', 'Mouse', 'Bottle'];
  const ObjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an Object'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Object to Detect',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: objects.length,
                itemBuilder:
                    (ctx, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.blue[100]!),
                        ),
                        child: ListTile(
                          title: Text(
                            objects[i],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.blue[800],
                          ),
                          onTap:
                              () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                  builder:
                                      (_) => RealTimeObjectDetection(
                                        selectedObject: objects[i],
                                      ),
                                ),
                              ),
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
