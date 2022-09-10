part of 'member_cubit.dart';

enum MemberStatus { initial, loading, success, failure }

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberDataState extends MemberState {
  const MemberDataState(
      {this.listMembers,
      this.memberStatus = MemberStatus.initial,
      this.message});

  final List<MemberModel>? listMembers;
  final MemberStatus memberStatus;
  final String? message;

  MemberDataState copyWith(
      {List<MemberModel>? members,
      MemberStatus? memberStatus,
      String? message}) {
    return MemberDataState(
        listMembers: members ?? listMembers,
        message: message ?? this.message,
        memberStatus: memberStatus ?? this.memberStatus);
  }

  @override
  List<Object> get props => [(listMembers ?? []), memberStatus];
}

class MemberSuccessState extends MemberState {
  const MemberSuccessState({this.message});

  final String? message;

  @override
  List<Object> get props => [message ?? ''];
}
