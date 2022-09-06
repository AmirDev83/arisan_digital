import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit() : super(const CreateGroupState());

  final GroupRepository _groupRepo = GroupRepository();

  Future<void> createGroup(GroupModel groupModel) async {
    emit(state.copyWith(status: CreateGroupStatus.loading));
    try {
      ResponseModel? responseModel = await _groupRepo.createGroup(groupModel);
      if (responseModel == null) {
        return emit(state.copyWith(
            status: CreateGroupStatus.failure,
            message: "Group gagal ditambahkan, silahkan coba kembali!"));
      }

      if (responseModel.status == 'failed') {
        return emit(state.copyWith(
            status: CreateGroupStatus.failure, message: responseModel.message));
      }

      return emit(state.copyWith(
          status: CreateGroupStatus.success, message: responseModel.message));
    } catch (e) {
      return emit(state.copyWith(
          status: CreateGroupStatus.failure,
          message: "Maaf terjadi kesalahan sistem, mohon coba kembali!"));
    }
  }
}
