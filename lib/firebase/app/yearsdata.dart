import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/components.dart';
import 'package:dr_nashar_admin/screens/models/lecture_model.dart';

class YearsData {
  static var sec1, sec2, sec3, prep1, prep2, prep3;
  static var selectedSubject, selectedYear;
  static List<LectureModel> subjectData = [];
  static var lectureNumber, lectureCodes, lectureID;
  static List<String> lectureLinkNames=[],lectureLinkVideosName=[],lectureLinkVideosUrls=[],lectureLinkDocsName=[],lectureLinkDocsUrls=[];
  static var studentsData, studentWork, studentAssignments, studentQuizzes;

  static Future<bool> get_years_data() async {
    await FirebaseFirestore.instance
        .collection("sec1-lectures")
        .get()
        .then((value) {
      sec1 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("sec2-lectures")
        .get()
        .then((value) {
      sec2 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("sec3-lectures")
        .get()
        .then((value) {
      sec3 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("prep1-lectures")
        .get()
        .then((value) {
      prep1 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("prep2-lectures")
        .get()
        .then((value) {
      prep2 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("prep3-lectures")
        .get()
        .then((value) {
      prep3 = value.docs;
    });

    return true;
  }

  static Future<List<LectureModel>> get_subject_data() async {
    await FirebaseFirestore.instance
        .collection("${selectedYear}-lectures")
        .doc('${selectedSubject}')
        .collection('lectures')
        .get()
        .then((value) {
      try {
        subjectData =
            value.docs.map((e) => LectureModel.fromJson(e.data())).toList();
      } catch (e) {
        print(e);
      }
    });
    return subjectData;
  }

  static Future<bool> get_codes() async {
    await FirebaseFirestore.instance
        .collection("codes")
        .doc('general')
        .get()
        .then((value) {
      lectureCodes = value.data() as Map<String, dynamic>;
    });
    return true;
  }

  static Future getStudentsData() async {
    await FirebaseFirestore.instance
        .collection("userData")
        .get()
        .then((QuerySnapshot value) async {
      studentsData = value.docs;
    }).catchError((error) {
      {
        print(error.toString());
      }
    });
  }

  static Future getUserAssignmentsAndQuizzes({required userID}) async {
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(userID)
        .collection('assignments')
        .get()
        .then((value) {
      studentAssignments = value.docs;
    }).catchError((error) {
      {
        print(error.toString());
      }
    });

    await FirebaseFirestore.instance
        .collection("userData")
        .doc(userID)
        .collection('quizzes')
        .get()
        .then((value) {
      studentQuizzes = value.docs;
    }).catchError((error) {
      {
        print(error.toString());
      }
    });
  }

  static Future updateAssignmentMark(
      {required String userID,
      required String documentID,
      required String totalMarks,
      required String stepsMarks}) async {
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(userID)
        .collection('assignments')
        .doc(documentID)
        .update(
      {'steps_marks': stepsMarks, 'total_marks': totalMarks},
    );
  }

  static Future updateQuizMark(
      {required String userID,
      required String documentID,
      required String totalMarks,
      required String stepsMarks}) async {
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(userID)
        .collection('quizzes')
        .doc(documentID)
        .update(
      {'steps_marks': stepsMarks, 'total_marks': totalMarks},
    );
  }
}
