import 'dart:math';
import 'dart:typed_data';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/models/lecture_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class AppAddLectuerScreen extends StatefulWidget {
  const AppAddLectuerScreen({Key? key}) : super(key: key);

  @override
  _AppAddLectuerScreenState createState() => _AppAddLectuerScreenState();
}

class _AppAddLectuerScreenState extends State<AppAddLectuerScreen> {
  double progress = 0.0;
  FilePickerResult? result, result2, result3;
  late String lectureName, price;
  bool isLoading = false;
  int finishedTasks = 0;
  int totalTasks = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
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
                        onChanged: (value) {
                          lectureName = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Lectuer Name",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextField(
                        onChanged: (value) {
                          price = value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "price",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Pick Poster Image:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blueAccent,
                      ),
                      child: result == null
                          ? IconButton(
                              color: Colors.white,
                              iconSize: 40,
                              onPressed: () async {
                                final pickedfile = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.image, withData: true);
                                setState(() {
                                  result = pickedfile;
                                  totalTasks++;
                                });
                              },
                              icon: Icon(Icons.image_rounded),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        result = null;
                                        totalTasks--;
                                      });
                                    },
                                    icon: Icon(Icons.cancel_rounded),
                                    color: Colors.blueAccent,
                                  ),
                                  Expanded(
                                      child: Text(
                                    '${result?.files.first.name}',
                                    style: TextStyle(color: Colors.blueAccent),
                                    maxLines: 10,
                                  )),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Pick Lecture Videos:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: result2 == null
                          ? IconButton(
                              color: Colors.white,
                              iconSize: 40,
                              onPressed: () async {
                                final pickedfile = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.video,
                                        withData: true,
                                        allowMultiple: true);
                                setState(() {
                                  result2 = pickedfile;
                                  totalTasks =
                                      totalTasks + result2!.files.length;
                                });
                              },
                              icon: Icon(Icons.video_camera_back_rounded),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        totalTasks =
                                            totalTasks - result2!.files.length;
                                        result2 = null;
                                      });
                                    },
                                    icon: Icon(Icons.cancel_rounded),
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < result2!.files.length;
                                          i++)
                                        Text(
                                          '${result2?.files.elementAt(i).name}',
                                          style: TextStyle(
                                              color: Colors.deepPurpleAccent),
                                          maxLines: 10,
                                        ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Pick Lecture Documents:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.cyan,
                      ),
                      child: result3 == null
                          ? IconButton(
                              color: Colors.white,
                              iconSize: 40,
                              onPressed: () async {
                                final pickedfile = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.any,
                                        withData: true,
                                        allowMultiple: true);
                                setState(() {
                                  result3 = pickedfile;
                                  totalTasks =
                                      totalTasks + result3!.files.length;
                                });
                              },
                              icon: Icon(Icons.description_rounded),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        totalTasks =
                                            totalTasks - result2!.files.length;
                                        result3 = null;
                                      });
                                    },
                                    icon: Icon(Icons.cancel_rounded),
                                    color: Colors.cyan,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < result3!.files.length;
                                          i++)
                                        Text(
                                          '${result3?.files.elementAt(i).name}',
                                          style: TextStyle(color: Colors.cyan),
                                          maxLines: 10,
                                        ),
                                    ],
                                  )),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        if (lectureName != '' &&
                            price != '' &&
                            result != null &&
                            result2 != null &&
                            result3 != null) {
                          setState(() {
                            isLoading = true;
                          });
                          await pick_file(result, result2, result3);
                          Navigator.of(context).pop();
                        } else {}
                      },
                      child: Text(
                        'submit',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color(0x80000000),
                  child: Center(
                      child: Container(
                    height: 100.0,
                    width: finishedTasks == totalTasks ? double.infinity : 100,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 375),
                      child: finishedTasks == totalTasks
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
                                Text('Upload Complete',
                                    style: TextStyle(color: Colors.green)),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  )),
                )
              : Container(),
        ]),
      ),
    );
  }

  Future<void> pick_file(var result, var result2, var result3) async {
    if (result != null && result2 != null && result3 != null) {
      Uint8List? file = result.files.first.bytes;

      String fileName =
          "app/lectures/${YearsData.selectedYear}/${YearsData.selectedSubject}/picture/${result.files.first.name}";
      final imgRef = FirebaseStorage.instance.ref().child(fileName);
      print('uploading image');

      await imgRef.putData(
          file!,
          SettableMetadata(
              contentType: 'image/${result.files.first.extension}'));
      final imgURL = await imgRef.getDownloadURL();


      List<Video> videos = [];

      for (int i = 0; i < result2.files.length; i++) {
        print('uploading video $i');
        String videoName =
            'app/lectures/${YearsData.selectedYear}/${YearsData.selectedSubject}/videos/${result2.files.elementAt(i).name}';
        Uint8List? videoFile = result2.files.elementAt(i).bytes;
        final videoRef = FirebaseStorage.instance.ref().child(videoName);
        await videoRef.putData(
            videoFile!,
            SettableMetadata(
                contentType: 'video/${result2.files.elementAt(i).extension}'));
        final videoURL = await videoRef.getDownloadURL();
        String name = result2.files
            .elementAt(i)
            .name
            .substring(0, result2.files.elementAt(i).name.indexOf('.'));
        videos.add(Video(name: name, url: videoURL));
        setState(() {
          finishedTasks++;
        });
        print('$i video uploaded');
      }
      List<Document> documents = [];
      for (int i = 0; i < result3?.files.length; i++) {
        print('uploading doc $i');
        String docName =
            "app/lectures/${YearsData.selectedYear}/${YearsData.selectedSubject}/docs/${result3.files.elementAt(i).name}";
        Uint8List? docFile = result3.files.elementAt(i).bytes;
        final docRef = FirebaseStorage.instance.ref().child(docName);
        await docRef.putData(
            docFile!,
            SettableMetadata(
                contentType:
                    'application/${result3.files.elementAt(i).extension}'));
        final docURL = await docRef.getDownloadURL();
        String name = result3.files.elementAt(i).name;
        documents.add(Document(name: name, src: docURL));
        setState(() {
          finishedTasks++;
        });
        print('$i doc uploaded');
      }
      var lectureId = Random().nextInt(100000000).toString();
      var lecture = LectureModel(
        image: imgURL,
        documents: documents,
        videos: videos,
        name: lectureName,
        price: double.parse(price),
        id: lectureId,
      );

      FirebaseFirestore.instance
          .collection('${YearsData.selectedYear}-lectures')
          .doc('${YearsData.selectedSubject}')
          .collection('lectures')
          .doc(lectureId)
          .set(lecture.toJson());

      FirebaseFirestore.instance
          .collection('codes')
          .doc(lectureId)
          .set({
        'AS-2023': {'UID': '', 'used': false, 'expireDate': 1}
      });
      print('firestore created');
    }
  }
}
