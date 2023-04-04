import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class AddTopStudentScreen extends StatefulWidget {
  const AddTopStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddTopStudentScreen> createState() => _AddTopStudentScreenState();
}

class _AddTopStudentScreenState extends State<AddTopStudentScreen> {
  double progress = 0.0;
  FilePickerResult? result;
  late String studentName;
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
                        studentName = value;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: "Student Name",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Pick Image:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(15),
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
                                      result = null;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_rounded),
                                  color: Colors.blueAccent,
                                ),
                                Expanded(
                                    child: Text(
                                  '${result?.files.first.name}',
                                  style:
                                      const TextStyle(color: Colors.blueAccent),
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
                      if (result != null) {
                        setState(() {
                          isLoading = true;
                        });
                        await pick_file(result);
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

  Future<void> pick_file(var result) async {
    if (result != null) {
      Uint8List? file = result.files.first.bytes;
      String fileName =
          "web/top_students/${FireWeb.addUnderScore(studentName)}.${result.files.first.extension}";
      Map<String, dynamic> addedMap = {
        FireWeb.addUnderScore(studentName): {
          'name': studentName,
          'photo': fileName
        }
      };
      print(result.files.first);
      UploadTask task = FirebaseStorage.instance.ref().child(fileName).putData(
          file!,
          SettableMetadata(
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
