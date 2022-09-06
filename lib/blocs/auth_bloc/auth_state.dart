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
    return AuthUser(user: this.user, authStatus: this.authStatus);
  }

  @override
  List<Object> get props => [user!, authStatus];
}
