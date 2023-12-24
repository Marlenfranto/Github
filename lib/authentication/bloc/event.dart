import 'package:flutter/material.dart';

abstract class AuthEvent {}

class InitEvent extends AuthEvent {}

class SignInWithGitHubEvent extends AuthEvent {
  BuildContext context;
  SignInWithGitHubEvent(this.context);
}
