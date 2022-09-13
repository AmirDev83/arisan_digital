import 'package:arisan_digital/models/arisan_history_model.dart';
import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/arisan_history_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'shuffle_state.dart';

class ShuffleCubit extends Cubit<ShuffleState> {
  ShuffleCubit() : super(const ShuffleDataState());

  final ArisanHistoryRepository _arisanHistoryRepo = ArisanHistoryRepository();

  Future<void> saveShuffleResult(ArisanHistoryModel arisanHistoryModel) async {
    emit(const ShuffleDataState(shuffleStatus: ShuffleStatus.loading));
    try {
      ResponseModel? response =
          await _arisanHistoryRepo.createArisanHistory(arisanHistoryModel);

      if (response == null) {
        return emit(const ShuffleDataState(
            shuffleStatus: ShuffleStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      if (response.status == 'failure') {
        return emit(ShuffleDataState(
            shuffleStatus: ShuffleStatus.failure, message: response.message));
      }

      return emit(ShuffleDataState(
          shuffleStatus: ShuffleStatus.success, message: response.message));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const ShuffleDataState(
          shuffleStatus: ShuffleStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }
}
