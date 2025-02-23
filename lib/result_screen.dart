import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final String objectName;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.objectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Result'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Detected Object',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    objectName,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Detection'),
            ),
          ],
        ),
      ),
    );
  }
}
