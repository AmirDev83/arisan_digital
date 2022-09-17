import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'guest_group_state.dart';

class GuestGroupCubit extends Cubit<GuestGroupState> {
  GuestGroupCubit() : super(const GuestGroupDataState());

  final GroupRepository _groupRepo = GroupRepository();

  Future<void> getGuestGroup(String code) async {
    emit(GuestGroupLoadingState());
    try {
      GroupModel? data = await _groupRepo.showGuestGroup(code);

      if (data == null) {
        return emit(const GuestGroupDataState(
            guestGroupStatus: GuestGroupStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      return emit(GuestGroupDataState(
          guestGroupStatus: GuestGroupStatus.success,
          group: data,
          message: 'Data group berhasil didapatkan'));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const GuestGroupDataState(
          guestGroupStatus: GuestGroupStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }
}
