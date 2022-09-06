part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class GroupFetched extends GroupEvent {
  const GroupFetched({this.isRefresh = false});

  final bool isRefresh;

  @override
  List<Object> get props => [isRefresh];
}
