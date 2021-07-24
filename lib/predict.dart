import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Predict extends StatefulWidget{
  @override
  _PredictState createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  late FToast fToast;
  final picker = ImagePicker();
  File? imgf;
  String url = "http://class-catdog.herokuapp.com/image";
  String pathimg = "";
  String pathpre = "";
  String final_response = "";
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text("Upload Image"),),
      body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height:50),
                imgf!=null?
                new Image.file(imgf!): new Text("Select an image to upload"),
                SizedBox(height:20),
                RaisedButton(
                  color:Colors.blue,
                  textColor:Colors.white,
                  child:Text("Pick Image from gallery",),
                  onPressed: ()async
                  {
                    var pickedFile = await picker.getImage(source: ImageSource.gallery);
                    final File fileimg = File(pickedFile!.path);
                    pathimg = pickedFile.path;
                    if(pickedFile != null){
                      Fluttertoast.showToast(
                          msg: "Upload Image Success",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.red,
                          fontSize: 10.0
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: "Fail To Upload Image",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.red,
                          fontSize: 10.0
                      );
                    }
                    setState(() {
                      imgf = fileimg;
                      pathpre = pathimg;
                      if(pathpre != null) {
                        _visible = true;
                      }else{
                        _visible = false;
                      }
                    });

                  },
                ),
                Visibility(
                    visible: _visible,
                    child:FlatButton(
                      color:Colors.blue,
                      textColor:Colors.white,
                      child:Text("Predict",),
                      onPressed: ()async
                      {
                        final request = http.MultipartRequest("POST", Uri.parse(url));
                        final multipartFile = await http.MultipartFile.fromPath('file', pathpre,contentType: MediaType('image', 'jpeg'));
                        request.files.add(multipartFile);
                        final streamedResponse = await request.send();
                        final response = await http.Response.fromStream(streamedResponse);
                        if(response.statusCode == 200){
                          Fluttertoast.showToast(
                              msg: "Predict Success",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.red,
                              fontSize: 10.0
                          );
                        }
                        final List responseData = json.decode(response.body) ;
                        setState(() {
                          final_response = responseData.toString().replaceAll(RegExp(r'[{[}]'), '').replaceAll(']','');
                          final_response = final_response.replaceAll(',','\n').replaceAll("categories:", "");
                        });
                      },
                    )
                ),

                Expanded(
                    child:
                    Text(final_response, style: TextStyle(fontSize: 10,color: Colors.blue,fontWeight: FontWeight.bold),)),
              ],),
          )
      ),);
  }



}