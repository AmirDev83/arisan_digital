part of 'update_group_cubit.dart';

enum UpdateGroupStatus { initial, loading, success, failure }

class UpdateGroupState extends Equatable {
  const UpdateGroupState(
      {this.status = UpdateGroupStatus.initial, this.message});

  final UpdateGroupStatus status;
  final String? message;

  UpdateGroupState copyWith({UpdateGroupStatus? status, String? message}) {
    return UpdateGroupState(
        status: status ?? this.status, message: message ?? this.message);
  }

  @override
  List<Object> get props => [status, (message ?? '')];
}
