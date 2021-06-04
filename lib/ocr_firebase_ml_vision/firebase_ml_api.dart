import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FirebaseMlApi{
  static Future<String> recognizeText(File imageFile)async{
    if(imageFile==null){
      return'No Image Found';
    }
    else{
      final visionImage=FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer=FirebaseVision.instance.textRecognizer();
      try{
        final visionText=await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text=extractText(visionText);
        return text!=null?text:'No Text Found';

      }
      catch(e){
        return e.toString();
      }
    }
  }

  static extractText(VisionText visionText) {
    String text='';
    for(TextBlock block in visionText.blocks){
      for(TextLine line in block.lines){
        for(TextElement element in line.elements){
          text=text+element.text+'';
        }
        text=text+'\n';
      }
    }
    return text;
  }
}