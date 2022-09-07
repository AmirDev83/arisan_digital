import 'package:arisan_digital/models/user_model.dart';
import 'package:arisan_digital/repositories/auth_repository.dart';
import 'package:arisan_digital/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepo = UserRepository();
  final AuthRepository _authRepo = AuthRepository();

  AuthBloc() : super(AuthLoading()) {
    on<AuthUserFetched>(_onUserFetched);
    on<AuthOnLogout>(_onLogout);
  }

  Future<void> _onUserFetched(
      AuthUserFetched event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserModel? user = await _userRepo.user();
      if (user == null) {
        return emit(
            const AuthUser().copyWith(authStatus: AuthStatus.unauthenticated));
      } else {
        return emit(const AuthUser()
            .copyWith(user: user, authStatus: AuthStatus.authenticated));
      }
    } catch (_) {
      return emit(const AuthUser().copyWith(authStatus: AuthStatus.failure));
    }
  }

  Future<void> _onLogout(AuthOnLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepo.logout();
      emit(const AuthLogout().copyWith(authStatus: AuthStatus.unauthenticated));
    } catch (_) {
      emit(const AuthLogout().copyWith(authStatus: AuthStatus.failure));
    }
  }
}
