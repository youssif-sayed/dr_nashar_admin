import 'dart:math';

import 'package:dr_nashar_admin/screens/models/question_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/appBar.dart';

class EditQuestionScreen extends StatefulWidget {
  QuestionModel question;
  List<QuestionModel> questionsList;

  EditQuestionScreen(this.question, this.questionsList, {super.key});

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Text("EDIT"),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(15.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         // Question Text
      //         Container(
      //           padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(5),
      //               border: Border.all(color: Colors.blueAccent)),
      //           child: TextField(
      //
      //             maxLines: 10,
      //             onChanged: (value) {
      //               widget.question.questionText = value;
      //             },
      //             decoration: const InputDecoration(
      //               text
      //               border: InputBorder.none,
      //               labelText: "Question text",
      //             ),
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 20.0,
      //         ),
      //
      //         Row(
      //           children: [
      //             const Text(
      //               'Question Image (optional)',
      //               style: TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 15.0,
      //               ),
      //             ),
      //             const SizedBox(
      //               width: 20.0,
      //             ),
      //             TextButton(
      //               style: TextButton.styleFrom(
      //                 backgroundColor: Colors.green,
      //               ),
      //               onPressed: () {},
      //               child: const Text(
      //                 'Upload',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         const SizedBox(
      //           height: 20.0,
      //         ),
      //
      //         const Text(
      //           'Answers',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 15.0,
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 15.0,
      //         ),
      //         ListView.separated(
      //           shrinkWrap: true,
      //           physics: const NeverScrollableScrollPhysics(),
      //           separatorBuilder: (context, index) => const SizedBox(
      //             height: 15.0,
      //           ),
      //           itemBuilder: (context, index) {
      //             return Row(
      //               children: [
      //                 CircleAvatar(
      //                   child: Text('${index + 1}'),
      //                 ),
      //                 const SizedBox(
      //                   width: 10.0,
      //                 ),
      //                 Expanded(
      //                   child: Container(
      //                     padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      //                     decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(5),
      //                         border: Border.all(color: Colors.blueAccent)),
      //                     child: TextField(
      //                       onChanged: (value) {
      //                         widget.question.answers[index].answerText = value;
      //                       },
      //                       decoration: InputDecoration(
      //                         border: InputBorder.none,
      //                         labelText: "Answer ${index + 1}",
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             );
      //           },
      //           itemCount: 4,
      //         ),
      //
      //         const SizedBox(
      //           height: 20.0,
      //         ),
      //
      //         const Text(
      //           'Right Answer :',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 15.0,
      //           ),
      //         ),
      //
      //         const SizedBox(
      //           height: 15.0,
      //         ),
      //
      //         // Right Answer
      //         Row(
      //           children: [
      //             const CircleAvatar(
      //               backgroundColor: Colors.green,
      //               child: Icon(
      //                 Icons.check,
      //                 color: CupertinoColors.lightBackgroundGray,
      //               ),
      //             ),
      //             const SizedBox(
      //               width: 10.0,
      //             ),
      //             Expanded(
      //               child: Container(
      //                 padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(5),
      //                     border: Border.all(color: Colors.blueAccent)),
      //                 child: TextField(
      //                   keyboardType: TextInputType.number,
      //                   inputFormatters: [
      //                     LengthLimitingTextInputFormatter(1),
      //                   ],
      //                   onChanged: (value) {
      //                     widget.question.rightAnswer = value;
      //                   },
      //                   decoration: const InputDecoration(
      //                     border: InputBorder.none,
      //                     labelText: "Enter 1,2,3 or 4",
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //
      //         const SizedBox(
      //           height: 20.0,
      //         ),
      //
      //         // Add question
      //         SizedBox(
      //           width: double.infinity,
      //           child: ElevatedButton(
      //             onPressed: () {
      //               if (widget.question.questionText.isNotEmpty &&
      //                   widget.question.rightAnswer.isNotEmpty &&
      //                   widget.question.answers[0].answerText.isNotEmpty &&
      //                   widget.question.answers[1].answerText.isNotEmpty &&
      //                   widget.question.answers[2].answerText.isNotEmpty &&
      //                   widget.question.answers[3].answerText.isNotEmpty) {
      //                 if (int.parse(widget.question.rightAnswer) <= 4 &&
      //                     int.parse(widget.question.rightAnswer) > 0) {
      //                   widget.questionsList.add(
      //                     QuestionModel(
      //                       questionID: Random().nextInt(999),
      //                       questionText: widget.question.questionText,
      //                       questionImage: widget.question.questionImage ?? '',
      //                       answers: widget.question.answers,
      //                       rightAnswer: widget.question.rightAnswer,
      //                     ),
      //                   );
      //                   Navigator.of(context).pop();
      //                 } else {
      //                   showDialog(
      //                     context: context,
      //                     builder: (context) => AlertDialog(
      //                       content: const Text(
      //                           'Right answer number is not correct!'),
      //                       actions: [
      //                         Align(
      //                           alignment: AlignmentDirectional.centerEnd,
      //                           child: TextButton(
      //                             child: const Text('Okay'),
      //                             onPressed: () {
      //                               Navigator.of(context).pop();
      //                             },
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   );
      //                 }
      //               } else {
      //                 showDialog(
      //                   context: context,
      //                   builder: (context) => AlertDialog(
      //                     content: const Text('Please fill all the fields!'),
      //                     actions: [
      //                       Align(
      //                         alignment: AlignmentDirectional.centerEnd,
      //                         child: TextButton(
      //                           child: const Text('Okay'),
      //                           onPressed: () {
      //                             Navigator.of(context).pop();
      //                           },
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 );
      //               }
      //             },
      //             child: Padding(
      //               padding: const EdgeInsets.all(10.0),
      //               child: Text(
      //                 'Add question',
      //                 style: TextStyle(fontSize: 20.0),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
