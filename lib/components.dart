import 'dart:io';

import 'package:dr_nashar_admin/screens/models/questionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<QuestionModel> quizQuestions = [];
List<QuestionModel> assignmentQuestions = [];

class QuestionItem extends StatelessWidget {
  final int questionNumber;
  final String questionText;
  final String questionImage;
  final List<Answer> answers;
  final String rightAnswer;
  final VoidCallback removeQuestion;
  final int questionMark;

  const QuestionItem({
    super.key,
    required this.questionNumber,
    required this.questionText,
    required this.questionImage,
    required this.answers,
    required this.rightAnswer,
    required this.removeQuestion,
    required this.questionMark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$questionNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.green,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Text(
                    questionText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 5,
                  ),
                ),
                Text('Mark: $questionMark', style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),),
              ],
            ),

            const SizedBox(
              height: 20.0,
            ),

            questionImage.isNotEmpty
                ? Image.file(File(questionImage), fit: BoxFit.cover)
                : const SizedBox(),

            const SizedBox(
              height: 20.0,
            ),

            // Answers
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10.0,
                );
              },
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Text(
                        answers[index].answerText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                );
              },
              itemCount: 4,
            ),

            const SizedBox(
              height: 20.0,
            ),

            // Right answer
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: CupertinoColors.lightBackgroundGray,
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      rightAnswer,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20.0,
            ),
            // Delete
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                  onPressed: removeQuestion,
                  icon: const Icon(Icons.delete,
                      color: Colors.red, size: 30.0),),
            ),
          ],
        ),
      ),
    );
  }
}

showLoadingDialog(context) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      children: const [
        Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}