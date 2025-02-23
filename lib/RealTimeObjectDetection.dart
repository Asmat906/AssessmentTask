import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_obj_detection/boxes.dart';
import 'package:realtime_obj_detection/provider/detection_provider.dart';

class RealTimeObjectDetection extends StatelessWidget {
  final String selectedObject;
  const RealTimeObjectDetection({super.key, required this.selectedObject});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetectionProvider>(
      builder: (context, provider, _) {
        if (!provider.controller.value.isInitialized) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.blue[800]),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Detecting: $selectedObject',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[800],
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    CameraPreview(provider.controller),
                    if (provider.recognitions != null)
                      BoundingBoxes(
                        recognitions: provider.recognitions!,
                        previewH: MediaQuery.of(context).size.height,
                        previewW: MediaQuery.of(context).size.width,
                        screenH: MediaQuery.of(context).size.height,
                        screenW: MediaQuery.of(context).size.width,
                      ),
                    if (provider.isObjectFar)
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[800]!.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Move closer to object',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: IconButton(
                  icon: Icon(
                    Icons.switch_camera,
                    size: 32,
                    color: Colors.blue[800],
                  ),
                  onPressed: provider.toggleCamera,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
