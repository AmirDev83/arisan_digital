import 'package:arisan_digital/models/arisan_history_model.dart';
import 'package:arisan_digital/repositories/arisan_history_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'arisan_history_state.dart';

class ArisanHistoryCubit extends Cubit<ArisanHistoryState> {
  ArisanHistoryCubit()
      : super(const ArisanHistoryDataState(
            arisanHistoryStatus: ArisanHistoryStatus.initial));

  final ArisanHistoryRepository _arisanHistoryRepo = ArisanHistoryRepository();

  Future<void> getArisanHistories(int id) async {
    emit(const ArisanHistoryDataState(
        arisanHistoryStatus: ArisanHistoryStatus.loading));
    try {
      List<ArisanHistoryModel>? data =
          await _arisanHistoryRepo.getArisanHistories(id);
      if (data == null) {
        return emit(const ArisanHistoryDataState(
            arisanHistoryStatus: ArisanHistoryStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      return emit(ArisanHistoryDataState(
          arisanHistoryStatus: ArisanHistoryStatus.success,
          arisanHistories: data,
          message: 'Data history arisan berhasil didapatkan'));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const ArisanHistoryDataState(
          arisanHistoryStatus: ArisanHistoryStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }
}
