import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_screen.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../utils/mixin.dart';
import '../utils/strings.dart';
import '../utils/styles.dart';
import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';


class AuthPage extends StatelessWidget with CommonUi{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthBloc(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
      if (state is AuthSignedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (state is AuthError) {
        showToastMessage(state.errorMessage);
      }
      },
        builder: (BuildContext context, AuthState state) {
if(state is AuthInitial || state is AuthError){
        return Scaffold(
          appBar: null,
          body: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Image.asset(Images.githubLogo),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Image.asset(Images.group),
                  ),
                  Text(
                    Strings.loginTitle,
                    textAlign: TextAlign.center,
                    style: Styles.bodyBold,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      Strings.loginBody,
                      textAlign: TextAlign.center,
                      style: Styles.bodyLight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor,minimumSize:Size(MediaQuery.of(context).size.width/1.5,48),shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),),
                      onPressed: () => bloc.add(SignInWithGitHubEvent(context)),
                      child: const Text(Strings.signIn,style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

    }else{
        return const Scaffold(
          appBar: null,
          body: Center(child: CircularProgressIndicator()),
        );
    }});
  }
}

