part of 'selected_group_cubit.dart';

class SelectedGroupState extends Equatable {
  const SelectedGroupState(
      {this.selectedIndex = 0,
      this.isInit = false,
      this.group,
      this.isShowBalance = false});

  final int selectedIndex;
  final bool isInit, isShowBalance;
  final GroupModel? group;

  SelectedGroupState copyWith(
      {int? selectedIndex,
      bool? isInit,
      bool? isShowBalance,
      GroupModel? group}) {
    return SelectedGroupState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        isInit: isInit ?? this.isInit,
        isShowBalance: isShowBalance ?? this.isShowBalance,
        group: group ?? this.group);
  }

  @override
  List<Object> get props => [selectedIndex, isInit, isShowBalance];
}
