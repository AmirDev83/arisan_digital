part of 'shuffle_cubit.dart';

enum ShuffleStatus { initial, loading, success, failure }

abstract class ShuffleState extends Equatable {
  const ShuffleState();

  @override
  List<Object> get props => [];
}

class ShuffleDataState extends ShuffleState {
  const ShuffleDataState(
      {this.shuffleStatus = ShuffleStatus.initial, this.message});
  final ShuffleStatus shuffleStatus;
  final String? message;
  @override
  List<Object> get props => [shuffleStatus, (message ?? '')];
}
