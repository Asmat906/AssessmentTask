import 'package:flutter/material.dart';

class BoundingBoxes extends StatelessWidget {
  final List<dynamic> recognitions;
  final double previewH, previewW, screenH, screenW;

  const BoundingBoxes({
    required this.recognitions,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
          recognitions.map((rec) {
            final box = rec["rect"];
            return Positioned(
              left: box["x"] * screenW,
              top: box["y"] * screenH,
              width: box["w"] * screenW,
              height: box["h"] * screenH,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Text(
                  "${rec["detectedClass"]} ${(rec["confidenceInClass"] * 100).toInt()}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    backgroundColor: Colors.blue[800]!.withOpacity(0.7),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
