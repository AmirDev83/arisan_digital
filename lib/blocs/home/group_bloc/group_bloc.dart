import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepo = GroupRepository();

  GroupBloc() : super(const GroupState()) {
    on<GroupFetched>(_onGroupFetched);
  }

  Future<void> _onGroupFetched(
      GroupFetched event, Emitter<GroupState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == GroupStatus.initial) {
        final groups = await _groupRepo.getGroups();
        return emit(state.copyWith(
          status: GroupStatus.success,
          groups: groups,
          hasReachedMax: false,
        ));
      }
      final groups = await _groupRepo.getGroups();
      emit(groups!.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: GroupStatus.success,
              groups: List.of(state.groups)..addAll(groups),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: GroupStatus.failure));
    }
  }
}
