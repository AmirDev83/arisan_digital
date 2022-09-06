part of 'create_group_cubit.dart';

enum CreateGroupStatus { initial, loading, success, failure }

class CreateGroupState extends Equatable {
  const CreateGroupState(
      {this.status = CreateGroupStatus.initial, this.message});

  final CreateGroupStatus status;
  final String? message;

  CreateGroupState copyWith({CreateGroupStatus? status, String? message}) {
    return CreateGroupState(
        status: status ?? this.status, message: message ?? this.message);
  }

  @override
  List<Object> get props => [status, (message ?? '')];
}
