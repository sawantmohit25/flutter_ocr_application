import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_vision_app/ocr_firebase_ml_vision/firebase_ml_api.dart';
import 'package:ml_vision_app/ocr_firebase_ml_vision/recognized_text_details.dart';
import 'package:permission_handler/permission_handler.dart';

class TextRecognitionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:AppBar(
          title:Text('Text Recognition'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera), text: "Camera"),
              Tab(icon: Icon(Icons.photo_album), text: "Gallery")
            ],
          ),
        ),
        body:TabBarView(children:[
        FirstScreen(),
        SecondScreen()
        ])
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  File _camera;

  String cameraText='';

  checkCameraPermission() async {
    var cameraStatus = await Permission.camera.status;
    print(cameraStatus);
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    if (await cameraStatus.isGranted) {
      setState(() {
        openCamera();
      });
    }
  }

  openCamera() async{
    PickedFile image = await ImagePicker().getImage(
        source: ImageSource.camera);
    setState(() {
      _camera= File(image.path);
    });
    Fluttertoast.showToast(
        msg:'Image Picked Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.teal,
        textColor: Colors.white
    );
  }

  scanCameraText()async{
    showDialog(context:context,
        child:Center(child: CircularProgressIndicator()));
    final apiText=await FirebaseMlApi.recognizeText(_camera);
    setState(() {
      cameraText=apiText;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,0),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            _camera != null ? Image.file(_camera) :Container(height:450,child: Image.asset('assets/gallery_image_1.png')),
            SizedBox(height:20,),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(onPressed:(){
                  checkCameraPermission();
                },color:Colors.teal,child:Text('Pick Camera Image'),),
                RaisedButton(onPressed:()async{
                  await scanCameraText();
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>TextDetails(recognizedText:cameraText)));
                },color:Colors.teal,child:Text('Scan Camera Image'),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  File _image;
  String galleryText='';
  checkGalleryPermission() async {
    var galleryStatus = await Permission.photos.status;
    print(galleryStatus);
    if (!galleryStatus.isGranted) {
      await Permission.photos.request();
    }
    if (await galleryStatus.isGranted) {
      openGallery();
    }
    else {
      Fluttertoast.showToast(
          msg: 'Provide Permission to use your photos',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white
      );
    }
  }
  openGallery() async {
    PickedFile image = await ImagePicker().getImage(
        source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    Fluttertoast.showToast(
        msg:'Image Picked Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.teal,
        textColor: Colors.white
    );
  }

  scanGalleryText()async{
    showDialog(context:context,
        child:Center(child: CircularProgressIndicator()));
    final apiText=await FirebaseMlApi.recognizeText(_image);
    setState(() {
      galleryText=apiText;
    });
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,0),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image) :Container(height: 450,child: Image.asset('assets/gallery_image_1.png')),
            SizedBox(height:20,),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(onPressed:(){
                  checkGalleryPermission();
                },color:Colors.teal,child:Text('Pick Gallery Image'),),
                RaisedButton(onPressed:()async{
                  await scanGalleryText();
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>TextDetails(recognizedText:galleryText)));
                },color:Colors.teal,child:Text('Scan Gallery Image'),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

