import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../firebase/app/yearsdata.dart';




class AppLoadLectureScreen extends StatefulWidget {
  const AppLoadLectureScreen({Key? key}) : super(key: key);

  @override
  State<AppLoadLectureScreen> createState() => _AppLoadLectureScreenState();
}

class _AppLoadLectureScreenState extends State<AppLoadLectureScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {


    bool issubject = await YearsData.get_subject_data();
    if (issubject)
      Navigator.of(context).pushReplacementNamed('AppLectureScreen');





  }
  @override
  void dispose() {

    super.dispose();

  }
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SpinKitPouringHourGlassRefined(color: Colors.orange,size: 100.0,),
        ),
      ),
    );
  }
}
