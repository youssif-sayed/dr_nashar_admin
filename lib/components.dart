import 'dart:io';

import 'package:dr_nashar_admin/screens/models/question_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuestionItem extends StatelessWidget {
  final int questionNumber;
  final String text;
  final String? image;
  final List<String> choices;
  final String answer;
  final VoidCallback removeQuestion;
  final int mark;

  const QuestionItem({
    super.key,
    required this.questionNumber,
    required this.text,
    required this.image,
    required this.choices,
    required this.answer,
    required this.removeQuestion,
    required this.mark,
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
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 5,
                  ),
                ),
                Text(
                  'Mark: $mark',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20.0,
            ),

            image != null
                ? Image.file(File(image!), fit: BoxFit.cover)
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
                        choices[index],
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
                      answer,
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
                icon: const Icon(Icons.delete, color: Colors.red, size: 30.0),
              ),
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

bool isToastShown = false;

void showToast(String message, ToastGravity toastGravity) {
  // toastGravity ??= ToastGravity.CENTER

  if (!isToastShown) {
    isToastShown = true;
    Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: toastGravity,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0)
        .then((value) async{
          await Future.delayed(const Duration(milliseconds:500));
          isToastShown = false;
        } );
  }
}
