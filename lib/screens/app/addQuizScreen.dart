import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/components.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/app/addQuestion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({Key? key}) : super(key: key);

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
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
                  content: const Text('Are you sure to remove this quiz?'),
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
                            quizQuestions = [];
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
              quizQuestions.isNotEmpty
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
                              questionMark: quizQuestions[index].mark,
                              questionNumber: index + 1,
                              questionText: quizQuestions[index].questionText,
                              questionImage: quizQuestions[index].questionImage,
                              answers: quizQuestions[index].answers,
                              rightAnswer: quizQuestions[index].rightAnswer,
                              removeQuestion: () {
                                setState(() {
                                  quizQuestions.removeAt(index);
                                });
                              },
                            );
                          },
                          itemCount: quizQuestions.length,
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
              // Quiz Title
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
                              AddQuestionScreen(quizQuestions)))
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
                onPressed: quizQuestions.isNotEmpty
                    ? () async {
                        if (totalMarks != 0) {
                          showLoadingDialog(context);
                          if (quizQuestions.isNotEmpty) {
                            final firebaseStorage = FirebaseStorage.instance;

                            for (int i = 0; i < quizQuestions.length; i++) {
                              if (quizQuestions[i].questionImage.isNotEmpty) {
                                var snapshot = await firebaseStorage
                                    .ref()
                                    .child(
                                        'images/quizzes/${YearsData.selectedYear}-${YearsData.selectedSubject}-${quizQuestions[i].questionID}')
                                    .putFile(
                                        File(quizQuestions[i].questionImage))
                                    .whenComplete(() {

                                });
                                var downloadUrl =
                                    await snapshot.ref.getDownloadURL();
                                setState(() {
                                  quizQuestions[i].questionImage = downloadUrl;
                                });
                              }
                            }
                          }

                          List quizQs = [];

                          for (var element in quizQuestions) {
                            quizQs.add(element.toMap());
                          }

                          if (quizQs.isNotEmpty) {
                            firestoreInstance
                                .collection(
                                    "${YearsData.selectedYear}-lectures")
                                .doc('${YearsData.selectedSubject}')
                                .collection('quiz')
                                .add({
                              '${YearsData.selectedYear}-${YearsData.selectedSubject}-quiz':
                                  quizQs,
                              'total_marks': totalMarks,
                            }).then((value) {
                              print(value.id);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              quizQuestions = [];
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
