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
  var assignments = YearsData.studentAssignments;
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
                  print(assignments);
                  print(assignments.length);
                  // return Container(
                  //     color: Colors.black, height: 100, width: 100);
                  return StudentWorkElement(
                    index: index,
                    assignment: true,
                    userID: widget.studentID,
                    documentID: assignments[index].id,
                    name: assignments[index]['assignment_name'],
                    totalMarks: assignments[index]['assignment_marks'],
                    rightAnswers: assignments[index]['right_answers'],
                    wrongAnswers: assignments[index]['wrong_answers'],
                  );
                },
                itemCount: assignments.length,
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
                    index: index,
                    assignment: false,
                    userID: widget.studentID,
                    documentID: YearsData.studentQuizzes[index].id,
                    name: YearsData.studentQuizzes[index]['quiz_name'],
                    totalMarks: YearsData.studentQuizzes[index]['quiz_marks'],
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
}

class StudentWorkElement extends StatefulWidget {
  final int index;
  final String name;
  final String totalMarks;
  final String userID;
  final String documentID;
  final int rightAnswers;
  final int wrongAnswers;
  final bool assignment;

  const StudentWorkElement({
    super.key,
    required this.index,
    required this.name,
    required this.totalMarks,
    required this.userID,
    required this.documentID,
    required this.rightAnswers,
    required this.wrongAnswers,
    required this.assignment,
  });

  @override
  State<StudentWorkElement> createState() => _StudentWorkElementState();
}

class _StudentWorkElementState extends State<StudentWorkElement> {
  var assignments = YearsData.studentAssignments;

  bool stepMarksExists() {
    if (widget.assignment) {
      return !assignments[widget.index].data().containsKey('steps_marks')
          ? false
          : true;
    }
    return !YearsData.studentQuizzes[widget.index]
            .data()
            .containsKey('steps_marks')
        ? false
        : true;
  }

  final TextEditingController resultStepsMarksController =
      TextEditingController();

  late var maxStepsMarks;
  var stepsMarks;
  late String quizMarks;
  @override
  void initState() {
    super.initState();
    if (widget.assignment) {
      quizMarks = assignments[widget.index]['quiz_marks'];
      print(quizMarks.substring(
          quizMarks.indexOf('/') + 1, quizMarks.characters.length));

      maxStepsMarks = int.parse(assignments[widget.index]['total_marks']) -
          int.parse(quizMarks
              .substring(
                  quizMarks.indexOf('/') + 1, quizMarks.characters.length)
              .replaceAll(' ', ''));

      if (stepMarksExists()) {
        stepsMarks = assignments[widget.index]['steps_marks'];

        print(stepsMarks.substring(0, stepsMarks.indexOf('/') - 1));

        resultStepsMarksController.text =
            stepsMarks.substring(0, stepsMarks.indexOf('/') - 1);
      }
    } else {
      quizMarks = YearsData.studentQuizzes[widget.index]['quiz_marks'];
      maxStepsMarks =
          int.parse(YearsData.studentQuizzes[widget.index]['total_marks']) -
              int.parse(quizMarks
                  .substring(
                      quizMarks.indexOf('/') + 1, quizMarks.characters.length)
                  .replaceAll(' ', ''));

      if (stepMarksExists()) {
        stepsMarks = YearsData.studentQuizzes[widget.index]['steps_marks'];
        resultStepsMarksController.text =
            stepsMarks.substring(0, stepsMarks.indexOf('/') - 1);
      }
    }
  }

  // int newGrade = 0;

  late final TextEditingController maxStepsMarksController =
      TextEditingController(text: '$maxStepsMarks');

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
                  widget.name,
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
                    widget.rightAnswers.toString(),
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
                    widget.wrongAnswers.toString(),
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
                'Quiz Marks',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.totalMarks,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          stepsMarks != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Steps Marks',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stepsMarks,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.blueAccent)),
                  child: TextField(
                    controller: resultStepsMarksController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              const Text('out of'),
              const SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.blueAccent)),
                  child: TextField(
                    controller: maxStepsMarksController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              if (resultStepsMarksController.text.isEmpty ||
                  maxStepsMarksController.text.isEmpty ||
                  int.parse(resultStepsMarksController.text) >
                      int.parse(maxStepsMarksController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit is not valid')));
              } else {
                if (widget.assignment) {
                  // Assignment

                  print('Assignment');

                  showLoadingDialog(context);
                  YearsData.updateAssignmentMark(
                    userID: widget.userID,
                    documentID: widget.documentID,
                    stepsMarks:
                        '${resultStepsMarksController.text} / ${maxStepsMarksController.text}',
                    totalMarks:
                        '${int.parse(resultStepsMarksController.text) + int.parse(quizMarks.substring(quizMarks.indexOf('/') + 1, quizMarks.characters.length).replaceAll(' ', ''))}',
                  ).then((value) {
                    Navigator.of(context).pop();
                  });
                } else {
                  //Quiz
                  showLoadingDialog(context);
                  YearsData.updateQuizMark(
                    userID: widget.userID,
                    documentID: widget.documentID,
                    stepsMarks:
                        '${resultStepsMarksController.text} / ${maxStepsMarksController.text}',
                    totalMarks:
                        '${int.parse(resultStepsMarksController.text) + int.parse(quizMarks.substring(quizMarks.indexOf('/') + 1, quizMarks.characters.length).replaceAll(' ', ''))}',
                  ).then((value) {
                    Navigator.of(context).pop();
                  });
                }
                setState(() {
                  stepsMarks =
                      '${resultStepsMarksController.text} / ${maxStepsMarksController.text}';
                });
              }
            },
            child: const Text(
              'edit steps marks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
