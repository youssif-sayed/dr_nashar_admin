import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class AddMELectuer extends StatefulWidget {
  const AddMELectuer({Key? key}) : super(key: key);

  @override
  _AddMELectuerState createState() => _AddMELectuerState();
}

class _AddMELectuerState extends State<AddMELectuer> {
  double progress = 0.0;
  FilePickerResult? result, result2;
  late String lectureName;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
                  const Text(
                    'Pick English Video:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.deepPurpleAccent,
                    ),
                    child: result == null
                        ? IconButton(
                            color: Colors.white,
                            iconSize: 40,
                            onPressed: () async {
                              final pickedfile = await FilePicker.platform
                                  .pickFiles(
                                      type: FileType.video, withData: true);
                              setState(() {
                                result = pickedfile;
                              });
                            },
                            icon: const Icon(Icons.video_camera_back_rounded),
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
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_rounded),
                                  color: Colors.deepPurpleAccent,
                                ),
                                Expanded(
                                    child: Text(
                                  '${result?.files.first.name}',
                                  style: const TextStyle(
                                      color: Colors.deepPurpleAccent),
                                  maxLines: 10,
                                )),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Pick Math Video:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.orangeAccent,
                    ),
                    child: result2 == null
                        ? IconButton(
                            color: Colors.white,
                            iconSize: 40,
                            onPressed: () async {
                              final pickedfile = await FilePicker.platform
                                  .pickFiles(
                                      type: FileType.video, withData: true);
                              setState(() {
                                result2 = pickedfile;
                              });
                            },
                            icon: const Icon(Icons.video_camera_back_rounded),
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
                                      result2 = null;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_rounded),
                                  color: Colors.orangeAccent,
                                ),
                                Expanded(
                                    child: Text(
                                  '${result2?.files.first.name}',
                                  style: const TextStyle(
                                      color: Colors.orangeAccent),
                                  maxLines: 10,
                                )),
                              ],
                            ),
                          ),
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
                      if (result != null && result2 != null) {
                        setState(() {
                          isLoading = true;
                        });
                        await pick_file(result, result2);
                      } else {}
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
                  width: progress == 100.0 ? double.infinity : 100,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 375),
                    child: progress == 100.0
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
    );
  }

  Future<void> pick_file(var result, var result2) async {
    if (result != null && result2 != null) {
      Uint8List? file = result.files.first.bytes;
      Uint8List? file2 = result2.files.first.bytes;
      String fileName =
          "web/math_and_english/${FireWeb.MEData?.keys.elementAt(FireWeb.MEYear)}/english/${FireWeb.addUnderScore(lectureName)}.mp4";
      String fileName2 =
          "web/math_and_english/${FireWeb.MEData?.keys.elementAt(FireWeb.MEYear)}/math/${FireWeb.addUnderScore(lectureName)}.mp4";
      Map<String, dynamic> addedMap = {
        lectureName: {
          'english': {'refrance': fileName, 'favourite': false},
          'math': {'refrance': fileName2, 'favourite': false}
        }
      };

      UploadTask task =
          FirebaseStorage.instance.ref().child(fileName).putData(file!);
      UploadTask task2 =
          FirebaseStorage.instance.ref().child(fileName2).putData(file2!);
      var progress1 = 0.0, progress2 = 0.0;
      task.snapshotEvents.listen((event) {
        setState(() {
          progress1 = (((event.bytesTransferred.toDouble() /
                          event.totalBytes.toDouble()) *
                      .5) *
                  100)
              .roundToDouble();
          progress = progress1 + progress2;

          if (progress == 100) {
            FireWeb.change_ME_map(addedMap);
            setState(() {
              FireWeb.getME();
            });

            event.ref
                .getDownloadURL()
                .then((downloadUrl) => print(downloadUrl));
          }

          print(progress);
        });
      });
      task2.snapshotEvents.listen((event) {
        setState(() {
          progress2 = (((event.bytesTransferred.toDouble() /
                          event.totalBytes.toDouble()) *
                      .5) *
                  100)
              .roundToDouble();
          progress = progress1 + progress2;

          if (progress == 100) {
            FireWeb.change_ME_map(addedMap);
            setState(() {
              FireWeb.getME();
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
