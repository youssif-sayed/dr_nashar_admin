import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/components.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/app/addQuestion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({Key? key}) : super(key: key);

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  int totalMarks = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage(
            'images/Icons/appIcon.png',
          ),
          height: 50,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content:
                      const Text('Are you sure to remove this assignment?'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            assignmentQuestions = [];
                          },
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Questions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              // Questions List
              assignmentQuestions.isNotEmpty
                  ? Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 15.0,
                            );
                          },
                          itemBuilder: (context, index) {
                            return QuestionItem(
                              questionMark: assignmentQuestions[index].mark,
                              questionNumber: index + 1,
                              questionText:
                                  assignmentQuestions[index].questionText,
                              questionImage:
                                  assignmentQuestions[index].questionImage,
                              answers: assignmentQuestions[index].answers,
                              rightAnswer:
                                  assignmentQuestions[index].rightAnswer,
                              removeQuestion: () {
                                setState(() {
                                  assignmentQuestions.removeAt(index);
                                });
                              },
                            );
                          },
                          itemCount: assignmentQuestions.length,
                        ),

                        const SizedBox(
                          height: 15.0,
                        ),

                        // Total Marks
                        Row(
                          children: [
                            const Text(
                              'Total Marks',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      totalMarks = int.parse(value);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('No questions yet!'),
                    ),

              const SizedBox(
                height: 70.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              AddQuestionScreen(assignmentQuestions)))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: const Text(
                  'Add question',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const StadiumBorder(),
                ),
                onPressed: assignmentQuestions.isNotEmpty
                    ? () async {
                        if (totalMarks != 0) {
                          showLoadingDialog(context);
                          if (assignmentQuestions.isNotEmpty) {
                            final firebaseStorage = FirebaseStorage.instance;

                            for (int i = 0; i < assignmentQuestions.length; i++) {
                              if (assignmentQuestions[i].questionImage.isNotEmpty) {
                                var snapshot = await firebaseStorage
                                    .ref()
                                    .child(
                                        'images/assignments/${YearsData.selectedYear}-${YearsData.selectedSubject}-${assignmentQuestions[i].questionID}')
                                    .putFile(File(
                                        assignmentQuestions[i].questionImage))
                                    .whenComplete(() {
                                  print('COMPLETED!');
                                });
                                var downloadUrl =
                                    await snapshot.ref.getDownloadURL();
                                setState(() {
                                  assignmentQuestions[i].questionImage =
                                      downloadUrl;
                                });
                              }
                            }
                          }

                          List assignmentQs = [];

                          for (var element in assignmentQuestions) {
                            assignmentQs.add(element.toMap());
                          }

                          if (assignmentQs.isNotEmpty) {
                            firestoreInstance
                                .collection(
                                    "${YearsData.selectedYear}-lectures")
                                .doc('${YearsData.selectedSubject}')
                                .collection('assignment')
                                .add({
                              '${YearsData.selectedYear}-${YearsData.selectedSubject}-assignment':
                                  assignmentQs,
                              'total_marks': totalMarks,
                            }).then((value) {
                              print(value.id);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              assignmentQuestions = [];
                            });
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content:
                                  const Text('Please enter the total marks!'),
                              actions: [
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: TextButton(
                                    child: const Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
