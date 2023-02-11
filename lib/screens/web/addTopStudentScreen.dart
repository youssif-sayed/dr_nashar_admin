import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../../firebase/web/fireweb.dart';


class AddTopStudentScreen extends StatefulWidget {
  const AddTopStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddTopStudentScreen> createState() => _AddTopStudentScreenState();
}

class _AddTopStudentScreenState extends State<AddTopStudentScreen> {
  double progress = 0.0;
  FilePickerResult? result;
  late String studentName ;
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [Container(
            padding: EdgeInsets.all(25),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextField(
                        onChanged: (value){studentName=value;},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Student Name",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Pick Image:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blueAccent,
                      ),
                      child: result==null?IconButton(
                        color: Colors.white,
                        iconSize: 40,
                        onPressed: ()  async{
                          final pickedfile = await FilePicker.platform.pickFiles(type: FileType.image,withData: true);
                          setState(() {
                            result =pickedfile;
                          });
                        },
                        icon: Icon(Icons.image_rounded),
                      ):Container(
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(50),),
                        child: Row(
                          children: [
                            IconButton(onPressed: (){setState(() {
                              result=null;
                            });}, icon: Icon(Icons.cancel_rounded),color: Colors.blueAccent,),
                            Expanded(child: Text('${result?.files.first.name}',style: TextStyle(color: Colors.blueAccent),maxLines: 10,)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        textStyle: TextStyle(fontSize: 30),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async{
                        if(studentName!=null) {
                          setState(() {
                            isLoading = true;
                          });
                          await pick_file(result);
                        }
                      },
                      child: Text(
                        'submit',
                      ),
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),
          ),
            isLoading?Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0x80000000),
              child: Center(child: Container(
                height: 100.0,
                width: progress == 100.0?double.infinity:100,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 375),
                  child: progress == 100.0
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                          'Upload Complete',
                          style: TextStyle(color: Colors.green)
                      ),
                    ],
                  )
                      :  LiquidCircularProgressIndicator(
                    value: progress / 100,
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                    backgroundColor: Colors.white,
                    direction: Axis.vertical,
                    center: Text(
                      "$progress%",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              )),
            ):Container(),
          ]
      ),
    );
  }

  Future<void> pick_file(var result) async {
    if (result != null) {
      
      Uint8List? file = result.files.first.bytes;
      String fileName = "web/top_students/${FireWeb.addUnderScore(studentName)}.${result.files.first.extension}";
      Map<String,dynamic> addedMap = {'${FireWeb.addUnderScore(studentName)}':{'name':studentName,'photo':fileName}};
      print(result.files.first);
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putData(file!,SettableMetadata(
        contentType: "image/${result.files.first.extension}"));

      task.snapshotEvents.listen((event) {
        setState(() {
          progress = ((event.bytesTransferred.toDouble() /
              event.totalBytes.toDouble()) *
              100)

              .roundToDouble();

          if (progress == 100) {
            FireWeb.change_topStudent_map(addedMap);
            setState(() {
              FireWeb.getTopStudent();
            });

            event.ref
                .getDownloadURL()
                .then((downloadUrl) => print(downloadUrl));

          }

          print(progress);
        });
      });
    }
  }
}
