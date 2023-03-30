import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/components.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/app/addAssignmentScreen.dart';
import 'package:dr_nashar_admin/screens/app/addQuizScreen.dart';
import 'package:dr_nashar_admin/screens/app/lecture_screen/bloc/lecture_bloc.dart';
import 'package:dr_nashar_admin/screens/app/lecture_screen/bloc/lecture_event.dart';
import 'package:dr_nashar_admin/screens/app/lecture_screen/bloc/lecture_state.dart';
import 'package:dr_nashar_admin/screens/app/lecture_screen/hero_dialogue_route.dart';
import 'package:dr_nashar_admin/screens/models/lecture_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

List copiedLectureData = [];

class AppLectureScreen extends StatefulWidget {
  const AppLectureScreen({Key? key}) : super(key: key);

  @override
  State<AppLectureScreen> createState() => _AppLectureScreenState();
}

class _AppLectureScreenState extends State<AppLectureScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LectureBloc, LectureState>(
      bloc: BlocProvider.of<LectureBloc>(context)..add(FetchData()),
      builder: (context, state) {
        switch (state.status) {
          case LectureStatus.initial:
            return const Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Center(
                  child: SpinKitPouringHourGlassRefined(
                    color: Colors.orange,
                    size: 100.0,
                  ),
                ),
              ),
            );
          case LectureStatus.success:
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
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.lectures.length,
                            itemBuilder: (BuildContext context, int index) {
                              var lecture = state.lectures[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          lecture.name,
                                          maxLines: 3,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // Quiz
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizDetailsScreen(
                                                    lecture: lecture,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: const Text(
                                                'Quiz',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: CupertinoColors
                                                      .lightBackgroundGray,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Assignment
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssignmentDetailsScreen(
                                                    lecture: lecture,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: const Text(
                                                'Assignment',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: CupertinoColors
                                                      .lightBackgroundGray,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Code
                                          PopupMenuButton<String>(
                                            onSelected: (value) async {
                                              if (value == 'copy') {
                                                copiedLectureData.add(
                                                  {
                                                    'videos': lecture.videos,
                                                    'documents':
                                                        lecture.documents
                                                  },
                                                );
                                                showToast(
                                                  'Lecture data has been copied',
                                                  ToastGravity.TOP,
                                                );
                                              } else {
                                                BlocProvider.of<LectureBloc>(
                                                        context)
                                                    .add(
                                                        DeleteLecture(lecture));
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem<String>(
                                                value: 'copy',
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.copy,
                                                      color: Colors.orange,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('Copy Data')
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('Delete')
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'AppAddLectureScreen');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add_rounded,
                                  size: 30,
                                ),
                                Text(
                                  'Add Lecture',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  state.isLoading
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: const Color(0x80000000),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          case LectureStatus.failure:
            return const Scaffold(
              body: Center(
                child: Text('something went wrong'),
              ),
            );
        }
      },
    );
  }
}

class AssignmentDetailsScreen extends StatefulWidget {
  const AssignmentDetailsScreen({Key? key, required this.lecture})
      : super(key: key);
  final LectureModel lecture;

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  late var assignment = widget.lecture.assignment;
  late int stepsMarks = assignment?.stepsMarks ?? 0;
  @override
  Widget build(BuildContext context) {
    var questions = assignment?.questions;
    int totalMarks = 0;
    questions?.forEach((question) => totalMarks += question.mark);
    totalMarks += stepsMarks;
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
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total Marks: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      totalMarks.toString(),
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Steps Marks: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          stepsMarks.toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        var newStepMarks = await Navigator.of(context).push(
                          HeroDialogRoute(
                            builder: (context) => EditStepsMarks(
                              lecture: widget.lecture
                                  .copyWith(assignment: assignment),
                              isAssignment: true,
                            ),
                          ),
                        );
                        if (newStepMarks != null) {
                          setState(() {
                            stepsMarks = newStepMarks;
                          });
                          BlocProvider.of<LectureBloc>(context).add(
                            ChangeLectureDetails(
                              widget.lecture.copyWith(
                                assignment: assignment!
                                    .copyWith(stepsMarks: newStepMarks),
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () async {
          var newAssignment = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) =>
                  AddAssignmentScreen(lecture: widget.lecture)),
            ),
          );
          if (newAssignment != null) {
            setState(() {
              assignment = newAssignment;
            });
          }
        },
      ),
      body: assignment == null
          ? const Center(
              child: Text('You have not added any question yet'),
            )
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                  child: Text(
                    'Assignment Question',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: assignment!.questions.length,
                  itemBuilder: (context, index) {
                    var question = questions![index];
                    var image = question.image;
                    return ListTile(
                      leading: image != null ? Image.network(image) : null,
                      title: Text("${index + 1} - ${question.text}"),
                    );
                  },
                )
              ],
            ),
    );
  }
}

class QuizDetailsScreen extends StatefulWidget {
  const QuizDetailsScreen({Key? key, required this.lecture}) : super(key: key);
  final LectureModel lecture;

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  late var quiz = widget.lecture.quiz;
  late int stepsMarks = quiz?.stepsMarks ?? 0;
  @override
  Widget build(BuildContext context) {
    var questions = quiz?.questions;
    int totalMarks = 0;
    questions?.forEach((question) => totalMarks += question.mark);
    totalMarks += stepsMarks;
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
      ),
      bottomSheet: quiz == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Total Marks: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            totalMarks.toString(),
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Steps Marks: ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                stepsMarks.toString(),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              var newStepMarks =
                                  await Navigator.of(context).push(
                                HeroDialogRoute(
                                  builder: (context) => EditStepsMarks(
                                    lecture:
                                        widget.lecture.copyWith(quiz: quiz),
                                    isAssignment: false,
                                  ),
                                ),
                              );

                              if (newStepMarks != null) {
                                setState(
                                  () {
                                    stepsMarks = newStepMarks;
                                  },
                                );
                                if (mounted) {
                                  BlocProvider.of<LectureBloc>(context).add(
                                    ChangeLectureDetails(
                                      widget.lecture.copyWith(
                                        quiz: quiz!
                                            .copyWith(stepsMarks: newStepMarks),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.edit),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {
          var newQuiz = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => AddQuizScreen(lecture: widget.lecture)),
            ),
          );
          if (newQuiz != null) {
            setState(() {
              quiz = newQuiz;
            });
          }
        },
      ),
      body: quiz == null
          ? const Center(
              child: Text('You have not added any question yet'),
            )
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                  child: Text(
                    'Quiz Question',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: quiz!.questions.length,
                  itemBuilder: (context, index) {
                    var question = questions![index];
                    var image = question.image;
                    return ListTile(
                      leading: image != null ? Image.network(image) : null,
                      title: Text("${index + 1} - ${question.text}"),
                    );
                  },
                )
              ],
            ),
    );
  }
}

class EditStepsMarks extends StatefulWidget {
  const EditStepsMarks(
      {Key? key, required this.lecture, required this.isAssignment})
      : super(key: key);
  final LectureModel lecture;
  final bool isAssignment;
  @override
  State<EditStepsMarks> createState() => _EditStepsMarksState();
}

class _EditStepsMarksState extends State<EditStepsMarks> {
  var stepMarks = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 200,
        child: Card(
          child: Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            stepMarks = int.parse(value);
                          } else {
                            stepMarks = 0;
                          }
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () async {
                      final firestoreInstance = FirebaseFirestore.instance;
                      if (widget.isAssignment) {
                        firestoreInstance
                            .collection("${YearsData.selectedYear}-lectures")
                            .doc('${YearsData.selectedSubject}')
                            .collection('lectures')
                            .doc(widget.lecture.id)
                            .set(
                              widget.lecture
                                  .copyWith(
                                      assignment: widget.lecture.assignment!
                                          .copyWith(stepsMarks: stepMarks))
                                  .toJson(),
                            );
                      } else {
                        firestoreInstance
                            .collection("${YearsData.selectedYear}-lectures")
                            .doc('${YearsData.selectedSubject}')
                            .collection('lectures')
                            .doc(widget.lecture.id)
                            .set(
                              widget.lecture
                                  .copyWith(
                                      quiz: widget.lecture.quiz!
                                          .copyWith(stepsMarks: stepMarks))
                                  .toJson(),
                            );
                      }
                      if (mounted) {
                        Navigator.of(context).pop(stepMarks);
                      }
                    },
                    child: const Text(
                      'confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
