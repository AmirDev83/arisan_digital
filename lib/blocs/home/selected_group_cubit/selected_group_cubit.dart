import 'package:arisan_digital/models/group_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'selected_group_state.dart';

class SelectedGroupCubit extends Cubit<SelectedGroupState> {
  SelectedGroupCubit() : super(const SelectedGroupState(isInit: true));

  void setSelectedIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("selectedIndexGroup", index);
    return emit(SelectedGroupState(selectedIndex: index));
  }

  void initSelectedIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("selectedIndexGroup");
    return emit(SelectedGroupState(selectedIndex: index ?? 0, isInit: true));
  }

  void showBalance() async {
    return emit(const SelectedGroupState()
        .copyWith(isShowBalance: state.isShowBalance ? false : true));
  }
}
