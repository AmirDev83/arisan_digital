part of 'group_bloc.dart';

enum GroupStatus { initial, success, failure }

class GroupState extends Equatable {
  const GroupState(
      {this.groups = const <GroupModel>[],
      this.status = GroupStatus.initial,
      this.hasReachedMax = false});

  final GroupStatus status;
  final List<GroupModel> groups;
  final bool hasReachedMax;

  GroupState copyWith({
    List<GroupModel>? groups,
    GroupStatus? status,
    bool? hasReachedMax,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${groups.length} }''';
  }

  @override
  List<Object> get props => [status, groups, hasReachedMax];
}
