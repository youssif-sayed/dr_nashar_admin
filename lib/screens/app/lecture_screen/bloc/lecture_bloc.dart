import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../firebase/app/yearsdata.dart';
import 'lecture_event.dart';
import 'lecture_state.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  LectureBloc() : super(const LectureState(status: LectureStatus.initial)) {
    final firestoreInstance = FirebaseFirestore.instance;

    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(status: LectureStatus.initial));
        try {
          var lectures = await YearsData.get_subject_data();
          emit(
            state.copyWith(lectures: lectures, status: LectureStatus.success),
          );
        } catch (e) {
          emit(state.copyWith(status: LectureStatus.failure));
        }
      },
    );

    on<ChangeLectureDetails>(
      (event, emit) {
        var indexOfVideo = state.lectures
            .indexWhere((element) => event.lecture.id == element.id);

        state.lectures[indexOfVideo] = event.lecture;

        emit(state.copyWith(status: LectureStatus.initial));

        emit(state.copyWith(
            lectures: state.lectures, status: LectureStatus.success));
      },
    );

    on<DeleteLecture>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true));
        await firestoreInstance
            .collection('${YearsData.selectedYear}-lectures')
            .doc('${YearsData.selectedSubject}')
            .collection('lectures')
            .doc(event.lecture.id.toString())
            .delete();

        await firestoreInstance
            .collection('codes')
            .doc(event.lecture.id.toString())
            .delete();

        state.lectures.remove(event.lecture);

        emit(state.copyWith(lectures: state.lectures, isLoading: false));
      },
    );
  }
}
