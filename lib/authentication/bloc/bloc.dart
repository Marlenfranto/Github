import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github/authentication/bloc/state.dart';
import 'package:github/utils/config.dart';
import 'package:github/utils/constant.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';

import '../../utils/shared_preferences.dart';
import '../../utils/strings.dart';
import 'event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignInWithGitHubEvent>(signInWithGitHub);
  }

  signInWithGitHub(SignInWithGitHubEvent event, Emitter<AuthState> emit) async {
    emit(GithubAuthLoading());
    final GitHubSignInResult gitHubSignInResult = await GitHubSignIn(
      clientId: Config.clientId,
      redirectUrl: Config.redirectUrl,
      clientSecret: Config.clientSecret,
      title: Strings.signInTitle,
      centerTitle: true,
    ).signIn(event.context);
    if (gitHubSignInResult.status == GitHubSignInResultStatus.ok) {
      final AuthCredential credential = GithubAuthProvider.credential(
        gitHubSignInResult.token!,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await SharedPreferencesService.saveString(
          user.additionalUserInfo?.username ?? '', Constants.username);
      await SharedPreferencesService.saveString(
          user.credential?.accessToken ?? '', Constants.token);
      await SharedPreferencesService.saveString(
          user.additionalUserInfo?.profile?['login'] ?? '', Constants.login);
      await SharedPreferencesService.saveString(
          user.additionalUserInfo?.profile?['avatar_url'] ?? '',
          Constants.profile);
      emit(AuthSignedIn());
    } else {
      emit(AuthError(Strings.signInFailed));
    }
  }
}
