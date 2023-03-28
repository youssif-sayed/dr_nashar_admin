import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../firebase/app/yearsdata.dart';
import 'lecture_event.dart';
import 'lecture_state.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  LectureBloc() : super(const LectureState(status: LectureStatus.initial)) {
    on<FetchData>(
      (event, emit) async {
        try {
          var lectures = await YearsData.get_subject_data();
          emit(
            LectureState(lectures: lectures, status: LectureStatus.success),
          );
        } catch (e) {
          emit(const LectureState(status: LectureStatus.failure));
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
  }
}
