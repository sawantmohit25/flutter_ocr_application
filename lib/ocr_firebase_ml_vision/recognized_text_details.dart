import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
class TextDetails extends StatefulWidget {
  String recognizedText;
  TextDetails({@required this.recognizedText});
  @override
  _TextDetailsState createState() => _TextDetailsState();
}

class _TextDetailsState extends State<TextDetails> {
  @override
  void initState() {
    Fluttertoast.showToast(
        msg:'Image Extracted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.teal,
        textColor: Colors.white
    );
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:AppBar(title:Text('Text Details'),),
      body:SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text('Extracted Text:-',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:Colors.white),),
                SizedBox(height: 20,),
                SelectableText(widget.recognizedText,style:TextStyle(fontSize:20),),
                SizedBox(height:20,),
                RaisedButton(onPressed:(){
                  FlutterClipboard.copy(widget.recognizedText);
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Copied to Clipboard')));
                },color:Colors.teal,child:Text('Copy to Clipboard'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
