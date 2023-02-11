import 'package:dr_nashar_admin/screens/web/addLectureScreen.dart';
import 'package:dr_nashar_admin/screens/web/addMELectuerScreen.dart';
import 'package:dr_nashar_admin/screens/intro.dart';
import 'package:dr_nashar_admin/screens/web/addTopStudentScreen.dart';
import 'package:dr_nashar_admin/screens/web/lectuerScreen.dart';
import 'package:dr_nashar_admin/screens/web/mathandenglishScreen.dart';
import 'package:dr_nashar_admin/screens/web/subjectScreen.dart';
import 'package:dr_nashar_admin/screens/web/topStudentListScreen.dart';
import 'package:dr_nashar_admin/screens/web/topStudentsScreen.dart';
import 'package:dr_nashar_admin/screens/web/website.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
      routes: {
        'Intro':(context) =>IntroScreen(),
        'WebSiteScreen':(context)=>WebSiteScreen(),
        'LectuerScreen':(context)=>LectuerScreen(),
        'SubjectScreen':(context)=>SubjectScreen(),
        'AddLecture' :(context)=>AddLectuer(),
        'MathAndEnglishScreen' :(context)=>MathAndEnglishScreen(),
        'AddMELectureScreen' :(context)=>AddMELectuer(),
        'TopStudentsScreen' :(context)=>TopStudentsScreen(),
        'TopStudentListScreen' :(context)=>TopStudentListScreen(),
        'AddTopStudentScreen' :(context)=>AddTopStudentScreen(),
      },
    );
  }
}
