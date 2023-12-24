class AuthState {
}
class AuthInitial extends AuthState {}

class AuthSignedIn extends AuthState {

  AuthSignedIn();
}

class AuthError extends AuthState {
  final String errorMessage;

  AuthError(this.errorMessage);
}
class GithubAuthLoading extends AuthState {}
