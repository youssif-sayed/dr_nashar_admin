


import 'package:cloud_firestore/cloud_firestore.dart';


class YearsData{


  static var sec1,sec2,sec3,prep1,prep2,prep3;
  static var selectedSubject,selectedYear,subjectData;
  static var lectureNumber,lectureCodes,lectureID;


  static Future<bool> get_years_data() async {
    await FirebaseFirestore.instance.collection("sec1-lectures").get().then((value) {

      sec1 = value.docs;
    });
    await FirebaseFirestore.instance.collection("sec2-lectures").get().then((value) {

      sec2 = value.docs;

    });
    await FirebaseFirestore.instance.collection("sec3-lectures").get().then((value) {

      sec3=value.docs;
    });
    await FirebaseFirestore.instance.collection("prep1-lectures").get().then((value) {
      prep1=value.docs;
    });
    await FirebaseFirestore.instance.collection("prep2-lectures").get().then((value) {
      prep2=value.docs;
    });
    await FirebaseFirestore.instance.collection("prep3-lectures").get().then((value) {
      prep3=value.docs;
    });


    return true;
  }
  static Future<bool> get_subject_data() async {
    await FirebaseFirestore.instance.collection("${selectedYear}-lectures").doc('${selectedSubject}').collection('videos').get().then((value) {
      subjectData=value.docs;
    });
    return true;
  }
  static Future<bool> get_lecture_codes(index) async {
    lectureID=subjectData[index]['id'];
    await FirebaseFirestore.instance.collection("codes").doc('${subjectData[index]['id']}').get().then((value) {
      lectureCodes=value.data() as Map<String,dynamic>;
    });
    return true;
  }



}