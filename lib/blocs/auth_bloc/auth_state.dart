part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {}

class AuthUser extends AuthState {
  const AuthUser({this.user, this.authStatus = AuthStatus.authenticated});

  final UserModel? user;
  final AuthStatus authStatus;

  AuthUser copyWith({UserModel? user, AuthStatus? authStatus}) {
    return AuthUser(
        user: user ?? this.user, authStatus: authStatus ?? this.authStatus);
  }

  @override
  List<Object> get props => [authStatus];
}

class AuthLogout extends AuthState {
  const AuthLogout({this.authStatus = AuthStatus.authenticated});

  final AuthStatus authStatus;

  AuthLogout copyWith({AuthStatus? authStatus}) {
    return AuthLogout(authStatus: authStatus ?? this.authStatus);
  }

  @override
  List<Object> get props => [authStatus];
}
