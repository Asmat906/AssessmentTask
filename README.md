# Real-Time Object Detection App

This Flutter application performs real-time object detection using the **TFLite** model. It allows users to select an object for detection, captures an image once the object is detected, and displays the detected image with meta information.

## Features

1. **Object Selection Screen**: 
   - A list of objects (e.g., Laptop, Mobile, Mouse, Bottle) is provided for selection.
   
2. **Object Detection Screen**: 
   - After selecting an object, the app takes you to the detection screen where the selected object is detected in real-time using the device's camera.
   
3. **Result Screen**: 
   - Once an object is detected, the app captures the image and displays the detected object along with metadata (e.g., object name, timestamping).

## Tools & Libraries Used

- **State Management**: Provider
- **Framework**: Flutter (Version: 3.19.6)
- **SDK**: TFLite v2

