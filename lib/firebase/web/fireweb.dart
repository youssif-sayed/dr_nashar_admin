import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FireWeb {
    static final db = FirebaseFirestore.instance;
    static Iterable<String>? years ;
    static Map<String,dynamic>? yearsData;
    static Map<String,dynamic>? MEData;
    static Map<String,dynamic>? sliderData;
    static Map<String,dynamic>? topStudentData;
    static var currentSubject;
    static List<int> inhetanceSubjectNumbers= [];


    static Future getYears()async{
    final docRef = db.collection("web").doc("years");
    final sliderRef = db.collection("web").doc("slider");

    await docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        yearsData=data;
        final keys = data.keys;
        years=keys;

      },
      onError: (e) => print("Error getting document: $e"),
    );
    await sliderRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        sliderData=data;

      },
      onError: (e) => print("Error getting document: $e"),
    );

  }
  static String removeUnderScore(string){
    var replace=string.replaceAll(RegExp('_'),' ');
    return replace;
  }
  static String addUnderScore(string){
      var replace=string.replaceAll(RegExp(' '),'_');
      return replace;
    }
    static void update_favourite(int index,bool value){
      FireWeb.yearsData?.values.elementAt(inhetanceSubjectNumbers[0]).
      values.elementAt(inhetanceSubjectNumbers[1]).
      values.elementAt(inhetanceSubjectNumbers[2]).
      values.elementAt(index)['favourite']=value;
      final refrance = FireWeb.yearsData?.values.elementAt(inhetanceSubjectNumbers[0]).
      values.elementAt(inhetanceSubjectNumbers[1]).
      values.elementAt(inhetanceSubjectNumbers[2]).
      values.elementAt(index)['refrance'];
      final name=FireWeb.yearsData?.values.elementAt(inhetanceSubjectNumbers[0]).
      values.elementAt(inhetanceSubjectNumbers[1]).
      values.elementAt(inhetanceSubjectNumbers[2]).
      keys.elementAt(index);
      if (value==true){
        Map<String,dynamic> addToSlider = {'$name':{'refrance':'$refrance'}};
        sliderData?.addAll(addToSlider);
        db
            .collection("web")
            .doc("slider")
            .update(sliderData!)
            .onError((e, _) => print("Error writing document: $e"));


      }else{
          for (int i=0; i<sliderData!.keys.length;i++)
            {
              if (refrance==sliderData!.values.elementAt(i)['refrance'])
                {
                  final docRef = db.collection("web").doc("slider");

                  final updates = <String, dynamic>{
                    "${sliderData!.keys.elementAt(i)}": FieldValue.delete(),
                  };

                  docRef.update(updates);
                }
            }
      }
      db
          .collection("web")
          .doc("years")
          .update(yearsData!)
          .onError((e, _) => print("Error writing document: $e"));
    }
    static String get_path(){
      String pathname ='${FireWeb.yearsData?.keys.elementAt(inhetanceSubjectNumbers[0])}/'
          '${FireWeb.yearsData?.values.elementAt(inhetanceSubjectNumbers[0]).
      keys.elementAt(inhetanceSubjectNumbers[1])}/'
          '${FireWeb.yearsData?.values.elementAt(inhetanceSubjectNumbers[0]).
      values.elementAt(inhetanceSubjectNumbers[1]).keys.elementAt(inhetanceSubjectNumbers[2])}/';
      return pathname;
    }
    static void change_map(Map<String,dynamic> addedmap){
    FireWeb.yearsData?.values.elementAt(inhetanceSubjectNumbers[0]).
    values.elementAt(inhetanceSubjectNumbers[1]).
    values.elementAt(inhetanceSubjectNumbers[2]).addAll(addedmap);
    db
        .collection("web")
        .doc("years")
        .update(yearsData!)
        .onError((e, _) => print("Error writing document: $e"));
    }
    //////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
  static var MEYear;
  static Future getME()async{
    final docRef = db.collection("web").doc("math_and_english");
    final sliderRef = db.collection("web").doc("slider");

    await docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        MEData=data;

      },
      onError: (e) => print("Error getting document: $e"),
    );
    await sliderRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        sliderData=data;

      },
      onError: (e) => print("Error getting document: $e"),
    );

  }
  static void update_ME_favourite(int sana,int index,int mada,bool value){
    FireWeb.MEData?.values.elementAt(sana).values.elementAt(index).values.elementAt(mada)['favourite']=value;
    final refrance = FireWeb.MEData?.values.elementAt(sana).values.elementAt(index).values.elementAt(mada)['refrance'];
    final name=FireWeb.MEData?.values.elementAt(sana).keys.elementAt(index);
    if (value==true){
      Map<String,dynamic> addToSlider = {'$name':{'refrance':'$refrance'}};
      sliderData?.addAll(addToSlider);
      db
          .collection("web")
          .doc("slider")
          .update(sliderData!)
          .onError((e, _) => print("Error writing document: $e"));


    }else{
      for (int i=0; i<sliderData!.keys.length;i++)
      {
        if (refrance==sliderData!.values.elementAt(i)['refrance'])
        {
          final docRef = db.collection("web").doc("slider");

          final updates = <String, dynamic>{
            "${sliderData!.keys.elementAt(i)}": FieldValue.delete(),
          };

          docRef.update(updates);
        }
      }
    }
    db
        .collection("web")
        .doc("math_and_english")
        .update(MEData!)
        .onError((e, _) => print("Error writing document: $e"));
  }
  static void change_ME_map(Map<String,dynamic> addedmap){
    FireWeb.MEData?.values.elementAt(MEYear).addAll(addedmap);
    db
        .collection("web")
        .doc("math_and_english")
        .update(MEData!)
        .onError((e, _) => print("Error writing document: $e"));
  }
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
  static var topStudentYear;
  static Future getTopStudent()async{
    final docRef = db.collection("web_leaderboard").doc("$topStudentYear");


    await docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        topStudentData=data;

      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
  static void change_topStudent_map(Map<String,dynamic> addedmap){
    topStudentData?.addAll(addedmap);
    db
        .collection("web_leaderboard")
        .doc("$topStudentYear")
        .update(topStudentData!)
        .onError((e, _) => print("Error writing document: $e"));
  }
  static Future<void> delete_topStudent (int index)async {
    final storageRef = FirebaseStorage.instance.ref();
    final path = '${FireWeb.topStudentData?.values.elementAt(index)['photo']}';
    print(path);
    final desertRef = storageRef.child("${FireWeb.topStudentData?.values.elementAt(index)['photo']}");

    await desertRef.delete();
    final docRef = db.collection("web_leaderboard")
        .doc("$topStudentYear");

    final updates = <String, dynamic>{
      "${FireWeb.topStudentData?.keys.elementAt(index)}": FieldValue.delete(),
    };
    print(updates);

    docRef.update(updates);


  }
}