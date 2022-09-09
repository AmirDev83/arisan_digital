import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'update_group_state.dart';

class UpdateGroupCubit extends Cubit<UpdateGroupState> {
  UpdateGroupCubit() : super(const UpdateGroupState());

  final GroupRepository _groupRepo = GroupRepository();

  Future<void> updateNoteGroup(int id, String note) async {
    emit(state.copyWith(status: UpdateGroupStatus.loading));
    try {
      ResponseModel? responseModel =
          await _groupRepo.updateNotesGroup(id, notes: note);
      if (responseModel == null) {
        return emit(state.copyWith(
            status: UpdateGroupStatus.failure,
            message: "Info group gagal di ubah, silahkan coba kembali!"));
      }

      if (responseModel.status == 'failed') {
        return emit(state.copyWith(
            status: UpdateGroupStatus.failure, message: responseModel.message));
      }

      return emit(state.copyWith(
          status: UpdateGroupStatus.success, message: responseModel.message));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(state.copyWith(
          status: UpdateGroupStatus.failure,
          message: "Maaf terjadi kesalahan sistem, mohon coba kembali!"));
    }
  }

  Future<void> updateDateGroup(int id, String date) async {
    emit(state.copyWith(status: UpdateGroupStatus.loading));
    try {
      ResponseModel? responseModel =
          await _groupRepo.updateDateGroup(id, date: date);
      if (responseModel == null) {
        return emit(state.copyWith(
            status: UpdateGroupStatus.failure,
            message: "Tanggal group gagal di ubah, silahkan coba kembali!"));
      }

      if (responseModel.status == 'failed') {
        return emit(state.copyWith(
            status: UpdateGroupStatus.failure, message: responseModel.message));
      }

      return emit(state.copyWith(
          status: UpdateGroupStatus.success, message: responseModel.message));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(state.copyWith(
          status: UpdateGroupStatus.failure,
          message: "Maaf terjadi kesalahan sistem, mohon coba kembali!"));
    }
  }
}
