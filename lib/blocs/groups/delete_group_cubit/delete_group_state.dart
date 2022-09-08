part of 'delete_group_cubit.dart';

enum DeleteGroupStatus { initial, loading, success, failure }

class DeleteGroupState extends Equatable {
  const DeleteGroupState(
      {this.status = DeleteGroupStatus.initial, this.message});

  final DeleteGroupStatus status;
  final String? message;

  DeleteGroupState copyWith({DeleteGroupStatus? status, String? message}) {
    return DeleteGroupState(
        status: status ?? this.status, message: message ?? this.message);
  }

  @override
  List<Object> get props => [status, (message ?? '')];
}
