import 'package:dr_nashar_admin/screens/models/lecture_model.dart';
import 'package:equatable/equatable.dart';

enum LectureStatus { initial, success, failure }

class LectureState extends Equatable {
  const LectureState({
    this.status = LectureStatus.initial,
    this.lectures = const <LectureModel>[],
    this.isLoading = false,
  });

  final LectureStatus status;
  final List<LectureModel> lectures;
  final bool isLoading;
  LectureState copyWith(
      {LectureStatus? status, List<LectureModel>? lectures, bool? isLoading}) {
    return LectureState(
      status: status ?? this.status,
      lectures: lectures ?? this.lectures,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return '''LectureState { status: $status} }''';
  }

  @override
  List<Object> get props => [status, lectures, isLoading];
}
