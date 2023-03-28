import 'package:dr_nashar_admin/screens/app/addLecture.dart';
import 'package:dr_nashar_admin/screens/app/addQuestion.dart';
import 'package:dr_nashar_admin/screens/app/addQuizScreen.dart';
import 'package:dr_nashar_admin/screens/app/lecture_screen/appLectureScreen.dart';
import 'package:dr_nashar_admin/screens/app/appScreen.dart';
import 'package:dr_nashar_admin/screens/app/attendanceScreen.dart';
import 'package:dr_nashar_admin/screens/app/lectureCodesScreen.dart';
import 'package:dr_nashar_admin/screens/app/loadLectureScreen.dart';
import 'package:dr_nashar_admin/screens/app/students_data_screen.dart';
import 'package:dr_nashar_admin/screens/app/subjectScreen.dart';
import 'package:dr_nashar_admin/screens/web/AddImageScreen.dart';
import 'package:dr_nashar_admin/screens/web/AddNewsScreen.dart';
import 'package:dr_nashar_admin/screens/web/ImagesScreen.dart';
import 'package:dr_nashar_admin/screens/web/addLectureScreen.dart';
import 'package:dr_nashar_admin/screens/web/addMELectuerScreen.dart';
import 'package:dr_nashar_admin/screens/intro.dart';
import 'package:dr_nashar_admin/screens/web/addTopStudentScreen.dart';
import 'package:dr_nashar_admin/screens/web/lectuerScreen.dart';
import 'package:dr_nashar_admin/screens/web/mathandenglishScreen.dart';
import 'package:dr_nashar_admin/screens/web/newsScreen.dart';
import 'package:dr_nashar_admin/screens/web/subjectScreen.dart';
import 'package:dr_nashar_admin/screens/web/topStudentListScreen.dart';
import 'package:dr_nashar_admin/screens/web/topStudentsScreen.dart';
import 'package:dr_nashar_admin/screens/web/website.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'screens/app/lecture_screen/bloc/lecture_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      BlocProvider(create: (context) => LectureBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
      routes: {
        'Intro': (context) => IntroScreen(),
        'WebSiteScreen': (context) => WebSiteScreen(),
        'LectuerScreen': (context) => LectuerScreen(),
        'SubjectScreen': (context) => SubjectScreen(),
        'AddLecture': (context) => AddLectuer(),
        'MathAndEnglishScreen': (context) => MathAndEnglishScreen(),
        'AddMELectureScreen': (context) => AddMELectuer(),
        'TopStudentsScreen': (context) => TopStudentsScreen(),
        'TopStudentListScreen': (context) => TopStudentListScreen(),
        'AddTopStudentScreen': (context) => AddTopStudentScreen(),
        'ImagesScreen': (context) => ImagesScreen(),
        'AddNewsScreen': (context) => ADDNewsScreen(),
        'AddImageScreen': (context) => ADDImageScreen(),
        'NewsScreen': (context) => NewsScreen(),
        'AppScreen': (context) => AppScreen(),
        'AppSubjectScreen': (context) => AppSubjectScreen(),
        // 'AppLoadingLectureScreen':(context)=>AppLoadLectureScreen(),
        'AppLectureScreen': (context) => AppLectureScreen(),
        'AppLectureCodesScreen': (context) => AppLectureCodeScreen(),
        'AppAddLectureScreen': (context) => AppAddLectuerScreen(),
        'AttendanceScreen': (context) => AttendanceScreen(),
        // 'AddQuizScreen': (context) => AddQuizScreen(),
        'StudentsDataScreen': (context) => StudentsDataScreen(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
