part of 'arisan_history_cubit.dart';

enum ArisanHistoryStatus { initial, loading, success, failure }

abstract class ArisanHistoryState extends Equatable {
  const ArisanHistoryState();

  @override
  List<Object> get props => [];
}

class ArisanHistoryDataState extends ArisanHistoryState {
  const ArisanHistoryDataState(
      {this.arisanHistories,
      this.message,
      this.arisanHistoryStatus = ArisanHistoryStatus.initial});

  final List<ArisanHistoryModel>? arisanHistories;
  final String? message;
  final ArisanHistoryStatus arisanHistoryStatus;

  @override
  List<Object> get props =>
      [arisanHistories ?? [], message ?? '', arisanHistoryStatus];
}
