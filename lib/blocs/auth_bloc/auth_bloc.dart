import 'package:arisan_digital/models/user_model.dart';
import 'package:arisan_digital/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepo = UserRepository();

  AuthBloc() : super(AuthLoading()) {
    on<AuthUserFetched>(_onUserFetched);
  }

  Future<void> _onUserFetched(
      AuthUserFetched event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserModel? user = await _userRepo.user();
      if (user == null) {
        emit(const AuthUser(authStatus: AuthStatus.unauthenticated));
      }
      emit(AuthUser(user: user, authStatus: AuthStatus.authenticated));
    } catch (_) {
      emit(const AuthUser(authStatus: AuthStatus.failure));
    }
  }
}
