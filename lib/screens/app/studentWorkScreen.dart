import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components.dart';
import '../../constants/appBar.dart';

class StudentWorkScreen extends StatefulWidget {
  final studentID;

  const StudentWorkScreen({super.key, required this.studentID});

  @override
  State<StudentWorkScreen> createState() => _StudentWorkScreenState();
}

class _StudentWorkScreenState extends State<StudentWorkScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assignments',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10.0),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10.0),
                itemBuilder: (context, index) {
                  return StudentWorkElement(
                    assignment: true,
                    userID: widget.studentID,
                    documentID: YearsData.studentAssignments[index].id,
                    name: YearsData.studentAssignments[index]
                        ['assignment_name'],
                    totalMarks: YearsData.studentAssignments[index]
                        ['total_marks'],
                    rightAnswers: YearsData.studentAssignments[index]
                        ['right_answers'],
                    wrongAnswers: YearsData.studentAssignments[index]
                        ['wrong_answers'],
                  );
                },
                itemCount: YearsData.studentAssignments.length,
              ),
              const SizedBox(height: 20.0),
              const Divider(color: Colors.grey, thickness: 2),
              const SizedBox(height: 20.0),
              const Text(
                'Quizzes',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10.0),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10.0),
                itemBuilder: (context, index) {
                  return StudentWorkElement(
                    assignment: false,
                    userID: widget.studentID,
                    documentID: YearsData.studentQuizzes[index].id,
                    name: YearsData.studentQuizzes[index]['quiz_name'],
                    totalMarks: YearsData.studentQuizzes[index]['total_marks'],
                    rightAnswers: YearsData.studentQuizzes[index]
                        ['right_answers'],
                    wrongAnswers: YearsData.studentQuizzes[index]
                        ['wrong_answers'],
                  );
                },
                itemCount: YearsData.studentQuizzes.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget studentWorkElement({
//   required String name,
//   required String totalMarks,
//   required int rightAnswers,
//   required int wrongAnswers,
// }) {
//   int newGrade = 0;
// }
}

class StudentWorkElement extends StatelessWidget {
  final String name;
  final String totalMarks;
  final String userID;
  final String documentID;
  final int rightAnswers;
  final int wrongAnswers;
  final bool assignment;
  int newGrade = 0;

  StudentWorkElement({
    super.key,
    required this.name,
    required this.totalMarks,
    required this.userID,
    required this.documentID,
    required this.rightAnswers,
    required this.wrongAnswers,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 2,
                  ),
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    Text(
                      rightAnswers.toString(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    Text(
                      wrongAnswers.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Marks',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  totalMarks,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.blueAccent)),
                    child: TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        newGrade = int.parse(value);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if (assignment) {
                        // Assignment

                        print('Assignment');

                        print('$newGrade /${totalMarks.substring(totalMarks.indexOf('/') +1)}');
                        showLoadingDialog(context);
                        YearsData.updateAssignmentMark(
                          userID: userID,
                          documentID: documentID,
                          totalMarks: '$newGrade /${totalMarks.substring(totalMarks.indexOf('/') +1)}',
                        ).then((value) {
                          Navigator.of(context).pop();
                        });;
                      } else {
                        //Quiz
                        showLoadingDialog(context);
                        YearsData.updateQuizMark(
                          userID: userID,
                          documentID: documentID,
                          totalMarks: '$newGrade /${totalMarks.substring(totalMarks.indexOf('/') +1)}',
                        ).then((value) {
                          Navigator.of(context).pop();
                        });

                        print('Quiz');

                        print('$newGrade / ${totalMarks.substring(totalMarks.indexOf('/') +1)}');
                      }
                    },
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
          ],
        ));
  }
}
