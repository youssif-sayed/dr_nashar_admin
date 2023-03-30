import 'package:equatable/equatable.dart';

import '../../../models/lecture_model.dart';

abstract class LectureEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchData extends LectureEvent {}

class ChangeLectureDetails extends LectureEvent {
  final LectureModel lecture;

  ChangeLectureDetails(this.lecture);
}

class DeleteLecture extends LectureEvent {
  final LectureModel lecture;
  DeleteLecture(this.lecture);
}
