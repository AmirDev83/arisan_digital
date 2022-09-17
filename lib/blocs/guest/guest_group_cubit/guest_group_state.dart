part of 'guest_group_cubit.dart';

enum GuestGroupStatus { initial, loading, success, failure }

abstract class GuestGroupState extends Equatable {
  const GuestGroupState();

  @override
  List<Object> get props => [];
}

class GuestGroupDataState extends GuestGroupState {
  const GuestGroupDataState(
      {this.group,
      this.message,
      this.guestGroupStatus = GuestGroupStatus.initial});

  final GroupModel? group;
  final String? message;
  final GuestGroupStatus guestGroupStatus;

  GuestGroupDataState copyWith(
      {GroupModel? group,
      String? message,
      GuestGroupStatus? guestGroupStatus}) {
    return GuestGroupDataState(
        group: group ?? this.group,
        message: message ?? this.message,
        guestGroupStatus: guestGroupStatus!);
  }

  @override
  List<Object> get props => [group ?? [], message ?? '', guestGroupStatus];
}

class GuestGroupLoadingState extends GuestGroupState {}
