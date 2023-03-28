import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/components.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/app/addQuestion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/question_model.dart';
import '../models/lecture_model.dart';
import 'lecture_screen/bloc/lecture_bloc.dart';
import 'lecture_screen/bloc/lecture_event.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({Key? key, required this.lecture}) : super(key: key);
  final LectureModel lecture;
  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<QuestionModel> questions = [];

  int stepMarks = 0;
  @override
  Widget build(BuildContext context) {
    int totalMarks = 0;
    questions.forEach((question) => totalMarks += question.mark);

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
              questions.isNotEmpty
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
                            totalMarks = 0;
                            for (var question in questions) {
                              totalMarks += question.mark;
                            }
                            return QuestionItem(
                              mark: questions[index].mark,
                              questionNumber: index + 1,
                              text: questions[index].text,
                              image: questions[index].image,
                              choices: questions[index].choices,
                              answer: questions[index].answer,
                              removeQuestion: () {
                                setState(() {
                                  questions.removeAt(index);
                                });
                              },
                            );
                          },
                          itemCount: questions.length,
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
                              child: Center(
                                child: Text(
                                  (totalMarks + stepMarks).toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            )
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
                          builder: (context) => AddQuestionScreen(questions)))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: const Text(
                  'Add question',
                  textAlign: TextAlign.center,
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
                onPressed: questions.isNotEmpty
                    ? () async {
                        if (totalMarks != 0) {
                          showLoadingDialog(context);
                          if (questions.isNotEmpty) {
                            final firebaseStorage = FirebaseStorage.instance;

                            for (int i = 0; i < questions.length; i++) {
                              var question = questions[i];
                              var image = questions[i].image;
                              if (image != null) {
                                var snapshot = await firebaseStorage
                                    .ref()
                                    .child(
                                        'images/quizzes/${YearsData.selectedYear}-${YearsData.selectedSubject}-${question.id}')
                                    .putFile(File(image))
                                    .whenComplete(() {});
                                var downloadUrl =
                                    await snapshot.ref.getDownloadURL();
                                questions[i] =
                                    question.copyWith(image: downloadUrl);
                              }
                            }

                            var previousQuiz = widget.lecture.quiz;

                            var previousQuestions = previousQuiz?.questions;

                            if (previousQuestions != null) {
                              questions.addAll(previousQuestions);
                            }

                            var quiz = previousQuiz == null
                                ? Quiz(
                                    questions: questions,
                                    stepsMarks: stepMarks,
                                  )
                                : previousQuiz.copyWith(
                                    questions: questions,
                                    stepsMarks: stepMarks,
                                  );

                            var lecture = widget.lecture.copyWith(quiz: quiz);

                            await firestoreInstance
                                .collection(
                                    "${YearsData.selectedYear}-lectures")
                                .doc('${YearsData.selectedSubject}')
                                .collection('lectures')
                                .doc(widget.lecture.id)
                                .set(
                                  lecture.toJson(),
                                );

                            if (mounted) {
                              // notify the lecture pages of the change

                              BlocProvider.of<LectureBloc>(context)
                                  .add(ChangeLectureDetails(lecture));

                              Navigator.of(context).pop();
                              Navigator.of(context).pop(quiz);
                            }
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
