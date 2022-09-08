part of 'selected_group_cubit.dart';

class SelectedGroupState extends Equatable {
  const SelectedGroupState({this.selectedIndex = 0, this.isInit = false});

  final int selectedIndex;
  final bool isInit;

  @override
  List<Object> get props => [selectedIndex, isInit];
}
