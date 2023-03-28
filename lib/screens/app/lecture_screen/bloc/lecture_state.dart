import 'package:dr_nashar_admin/screens/models/lecture_model.dart';
import 'package:equatable/equatable.dart';

enum LectureStatus { initial, success, failure }

class LectureState extends Equatable {
  const LectureState({
    this.status = LectureStatus.initial,
    this.lectures = const <LectureModel>[],
  });

  final LectureStatus status;
  final List<LectureModel> lectures;

  LectureState copyWith({LectureStatus? status, List<LectureModel>? lectures}) {
    return LectureState(
      status: status ?? this.status,
      lectures: lectures ?? this.lectures,
    );
  }

  @override
  String toString() {
    return '''LectureState { status: $status} }''';
  }

  @override
  List<Object> get props => [status, lectures];
}
