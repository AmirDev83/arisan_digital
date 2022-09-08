import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_group_state.dart';

class DeleteGroupCubit extends Cubit<DeleteGroupState> {
  DeleteGroupCubit() : super(const DeleteGroupState());

  final GroupRepository _groupRepo = GroupRepository();

  Future<void> deleteGroup(int id) async {
    emit(state.copyWith(status: DeleteGroupStatus.loading));
    try {
      ResponseModel? responseModel = await _groupRepo.deleteGroup(id);
      if (responseModel == null) {
        return emit(state.copyWith(
            status: DeleteGroupStatus.failure,
            message: "Group gagal dihapus, silahkan coba kembali!"));
      }

      if (responseModel.status == 'failed') {
        return emit(state.copyWith(
            status: DeleteGroupStatus.failure, message: responseModel.message));
      }

      return emit(state.copyWith(
          status: DeleteGroupStatus.success, message: responseModel.message));
    } catch (e) {
      return emit(state.copyWith(
          status: DeleteGroupStatus.failure,
          message: "Maaf terjadi kesalahan sistem, mohon coba kembali!"));
    }
  }
}
