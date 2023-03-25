import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/appBar.dart';
import '../models/questionModel.dart';

class AddQuestionScreen extends StatefulWidget {
  final List<QuestionModel> questionsList;

  const AddQuestionScreen(this.questionsList, {super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  String questionText = '';
  List<Answer> answers = [
    Answer(answerID: 1, answerText: ''),
    Answer(answerID: 2, answerText: ''),
    Answer(answerID: 3, answerText: ''),
    Answer(answerID: 4, answerText: ''),
  ];
  String rightAnswer = '';
  final ImagePicker _picker = ImagePicker();
   XFile? image;
   int mark = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mark
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green)),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      mark = int.parse(value);
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Mark",
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              // Question Text
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white)),
                      child: TextField(
                        maxLines: 3,
                        onChanged: (value) {
                          questionText = value;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Question",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  CircleAvatar(
                    child: IconButton(
                        onPressed: ()  async{
                          image = await _picker.pickImage(
                              source: ImageSource.gallery);
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),

              const SizedBox(
                height: 20.0,
              ),

              const Text(
                'Answers',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15.0,
                ),
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
                        child: Container(
                          //padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(color: Colors.blueAccent)),
                          child: TextField(
                            onChanged: (value) {
                              answers[index].answerText = value;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
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

              const Text(
                'Right Answer :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),

              const SizedBox(
                height: 15.0,
              ),

              // Right Answer
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                      color: CupertinoColors.lightBackgroundGray,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) {
                          rightAnswer = value;
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          labelText: "Enter 1,2,3 or 4",
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20.0,
              ),

              // Add question
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (questionText.isNotEmpty &&
                        rightAnswer.isNotEmpty &&
                        answers[0].answerText.isNotEmpty &&
                        answers[1].answerText.isNotEmpty &&
                        answers[2].answerText.isNotEmpty &&
                        answers[3].answerText.isNotEmpty) {
                      if (int.parse(rightAnswer) <= 4 &&
                          int.parse(rightAnswer) > 0) {
                        widget.questionsList.add(
                          QuestionModel(
                            questionID: Random().nextInt(999),
                            questionText: questionText,
                            questionImage: image?.path ?? '',
                            answers: answers,
                            rightAnswer: rightAnswer,
                            mark: mark,
                          ),
                        );
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text(
                                'Right answer number is not correct!'),
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('Please fill all the fields!'),
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Add question',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
