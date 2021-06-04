import 'package:flutter/material.dart';
import 'package:ml_vision_app/ocr_firebase_ml_vision/text_recognition_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner:false,
      theme: ThemeData.dark(),
      home:TextRecognitionScreen(),
    );
  }
}

