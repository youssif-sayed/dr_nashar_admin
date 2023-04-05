import 'dart:math';
import 'dart:typed_data';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/app/lecture_screen/appLectureScreen.dart';
import 'package:dr_nashar_admin/screens/models/lecture_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AppAddLectuerScreen extends StatefulWidget {
  const AppAddLectuerScreen({Key? key}) : super(key: key);

  @override
  _AppAddLectuerScreenState createState() => _AppAddLectuerScreenState();
}

class _AppAddLectuerScreenState extends State<AppAddLectuerScreen> {
  double progress = 0.0;
  FilePickerResult? image, pickedVideos, pickedDocuments;
  String lectureName = '', price = '';
  bool isLoading = false;
  int finishedTasks = 0;
  int totalTasks = 0;

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextField(
                        onChanged: (value) {
                          lectureName = value;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Lectuer Name",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextField(
                        onChanged: (value) {
                          price = value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "price",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Pick Poster Image:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blueAccent,
                      ),
                      child: image == null
                          ? IconButton(
                              color: Colors.white,
                              iconSize: 40,
                              onPressed: () async {
                                final pickedfile = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.image, withData: true);
                                setState(() {
                                  image = pickedfile;
                                  totalTasks++;
                                });
                              },
                              icon: const Icon(Icons.image_rounded),
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
                                        image = null;
                                        totalTasks--;
                                      });
                                    },
                                    icon: const Icon(Icons.cancel_rounded),
                                    color: Colors.blueAccent,
                                  ),
                                  Expanded(
                                      child: Text(
                                    '${image?.files.first.name}',
                                    style: const TextStyle(
                                        color: Colors.blueAccent),
                                    maxLines: 10,
                                  )),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (copiedLectureData.any(
                                (element) => element['videos'].isNotEmpty) ||
                            copiedLectureData.any(
                                (element) => element['documents'].isNotEmpty))
                        ? Column(
                            children: [
                              CopiedDataList(refresh),
                              MaterialButton(
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    copiedLectureData = [];
                                  });
                                },
                                child: const Text(
                                  'Delete All',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              const Text(
                                'Pick Lecture Videos:',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.deepPurpleAccent,
                                ),
                                child: pickedVideos == null
                                    ? IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        onPressed: () async {
                                          final pickedfile = await FilePicker
                                              .platform
                                              .pickFiles(
                                            type: FileType.video,
                                            withData: true,
                                            allowMultiple: true,
                                          );
                                          setState(() {
                                            pickedVideos = pickedfile;
                                            totalTasks = totalTasks +
                                                pickedVideos!.files.length;
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.video_camera_back_rounded),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  totalTasks = totalTasks -
                                                      pickedVideos!
                                                          .files.length;
                                                  pickedVideos = null;
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.cancel_rounded),
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        pickedVideos!
                                                            .files.length;
                                                    i++)
                                                  Text(
                                                    '${pickedVideos?.files.elementAt(i).name}',
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .deepPurpleAccent),
                                                    maxLines: 10,
                                                  ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Pick Lecture Documents:',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.cyan,
                                ),
                                child: pickedDocuments == null
                                    ? IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        onPressed: () async {
                                          final pickedfile = await FilePicker
                                              .platform
                                              .pickFiles(
                                                  type: FileType.any,
                                                  withData: true,
                                                  allowMultiple: true);
                                          setState(() {
                                            pickedDocuments = pickedfile;
                                            totalTasks = totalTasks +
                                                pickedDocuments!.files.length;
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.description_rounded),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  totalTasks = totalTasks -
                                                      pickedVideos!
                                                          .files.length;
                                                  pickedDocuments = null;
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.cancel_rounded),
                                              color: Colors.cyan,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          pickedDocuments!
                                                              .files.length;
                                                      i++)
                                                    Text(
                                                      '${pickedDocuments?.files.elementAt(i).name}',
                                                      style: const TextStyle(
                                                          color: Colors.cyan),
                                                      maxLines: 10,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        textStyle: const TextStyle(fontSize: 30),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        if (lectureName != '' &&
                            price != '' &&
                            image != null &&
                            pickedVideos != null &&
                            pickedDocuments != null) {
                          setState(() {
                            isLoading = true;
                          });
                          await uploadLecture(
                              image, pickedVideos, pickedDocuments);
                          Navigator.of(context).pop();
                        } else {
                          if (lectureName != '' &&
                              price != '' &&
                              image != null &&
                              copiedLectureData.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            await uploadLecture(
                                image, pickedVideos, pickedDocuments);
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        }
                      },
                      child: const Text(
                        'submit',
                      ),
                    ),
                    const SizedBox(
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
                  color: const Color(0x80000000),
                  child: Center(
                      child: SizedBox(
                    height: 100.0,
                    width: finishedTasks == totalTasks ? double.infinity : 100,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 375),
                      child: finishedTasks == totalTasks
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.check_rounded,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Upload Complete',
                                  style: TextStyle(color: Colors.green),
                                ),
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

  Future<void> uploadLecture(
      var image, var pickedVideos, var pickedDocuments) async {
    if (image != null && pickedVideos != null && pickedDocuments != null) {
      Uint8List? file = image.files.first.bytes;

      String fileName =
          "app/lectures/${YearsData.selectedYear}/${YearsData.selectedSubject}/picture/${image.files.first.name}";
      final imgRef = FirebaseStorage.instance.ref().child(fileName);
      print('uploading image');

      await imgRef.putData(
          file!,
          SettableMetadata(
              contentType: 'image/${image.files.first.extension}'));
      final imgURL = await imgRef.getDownloadURL();

      List<Video> videos = [];

      for (int i = 0; i < pickedVideos.files.length; i++) {
        print('uploading video $i');
        String videoName =
            'app/lectures/${YearsData.selectedYear}/${YearsData.selectedSubject}/videos/${pickedVideos.files.elementAt(i).name}';
        Uint8List? videoFile = pickedVideos.files.elementAt(i).bytes;
        final videoRef = FirebaseStorage.instance.ref().child(videoName);
        await videoRef.putData(
            videoFile!,
            SettableMetadata(
                contentType:
                    'video/${pickedVideos.files.elementAt(i).extension}'));
        final videoURL = await videoRef.getDownloadURL();
        String name = pickedVideos.files
            .elementAt(i)
            .name
            .substring(0, pickedVideos.files.elementAt(i).name.indexOf('.'));
        videos.add(Video(name: name, url: videoURL));
        setState(() {
          finishedTasks++;
        });
        print('$i video uploaded');
      }
      List<Document> documents = [];
      for (int i = 0; i < pickedDocuments?.files.length; i++) {
        print('uploading doc $i');
        String docName =
            "app/lectures/${YearsData.selectedYear}/${YearsData.selectedSubject}/docs/${pickedDocuments.files.elementAt(i).name}";
        Uint8List? docFile = pickedDocuments.files.elementAt(i).bytes;
        final docRef = FirebaseStorage.instance.ref().child(docName);
        await docRef.putData(
            docFile!,
            SettableMetadata(
                contentType:
                    'application/${pickedDocuments.files.elementAt(i).extension}'));
        final docURL = await docRef.getDownloadURL();
        String name = pickedDocuments.files.elementAt(i).name;
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


      print('firestore created');
    } else if (image != null && copiedLectureData.isNotEmpty) {
      Uint8List? file = image.files.first.bytes;

      String fileName =
          "app/lectures/${YearsData.selectedYear}/${YearsData.selectedSubject}/picture/${image.files.first.name}";
      final imgRef = FirebaseStorage.instance.ref().child(fileName);
      print('uploading image');

      await imgRef.putData(
          file!,
          SettableMetadata(
              contentType: 'image/${image.files.first.extension}'));
      final imgURL = await imgRef.getDownloadURL();

      List<Video> videos = [];
      List<Document> documents = [];

      if (copiedLectureData.isNotEmpty) {
        for (var data in copiedLectureData) {
          videos.addAll(data['videos']);
          documents.addAll(data['documents']);
        }
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

      copiedLectureData = [];
    }
  }
}

class CopiedDataList extends StatefulWidget {
  const CopiedDataList(
    this.refreshParent, {
    super.key,
  });
  final Function refreshParent;
  @override
  State<CopiedDataList> createState() => _CopiedDataListState();
}

class _CopiedDataListState extends State<CopiedDataList> {
  refreshParent() {
    if (copiedLectureData.every((element) => element['videos'].isEmpty) &&
        copiedLectureData.every((element) => element['documents'].isEmpty)) {
      copiedLectureData = [];
      widget.refreshParent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: copiedLectureData.length,
      itemBuilder: (context, lectureIndex) {
        var lecture = copiedLectureData[lectureIndex];
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lecture['videos'].length,
              itemBuilder: (context, index) {
                Video video = lecture['videos'][index];
                return ListTile(
                  leading: const Icon(Icons.play_circle_outline_rounded),
                  title: Text(video.name),
                  trailing: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          List<Video> reducedVideoList = [];
                          reducedVideoList.addAll(lecture['videos']);
                          reducedVideoList.remove(video);
                          copiedLectureData[lectureIndex]['videos'] =
                              reducedVideoList;
                        },
                      );
                      refreshParent();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lecture['documents'].length,
              itemBuilder: (context, index) {
                Document document = lecture['documents'][index];
                return ListTile(
                  leading: const Icon(Icons.file_present_sharp),
                  title: Text(document.name),
                  trailing: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          List<Document> reducedDocumentsList = [];
                          reducedDocumentsList.addAll(lecture['documents']);
                          reducedDocumentsList.remove(document);
                          copiedLectureData[lectureIndex]['documents'] =
                              reducedDocumentsList;
                        },
                      );
                      refreshParent();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
