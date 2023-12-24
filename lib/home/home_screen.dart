import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/authentication/login.dart';
import 'package:github/utils/colors.dart';
import 'package:github/utils/styles.dart';

import '../project/project_screen.dart';
import '../utils/images.dart';
import '../utils/shared_preferences.dart';
import '../utils/strings.dart';
import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';

class HomePage extends StatelessWidget {
  HomeBloc? homeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    homeBloc = BlocProvider.of<HomeBloc>(context);

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadReposDataState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                Strings.appName,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {}, child: Image.asset(Images.notification)),
                )
              ],
            ),
            drawer: buildDrawer(state, context),
            body: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              height: 200,
                            ),
                            Container(
                              color: AppColors.primaryColor,
                              height: 120,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 8.0),
                              child: Text(
                                'Hi ${state.username}',
                                style: Styles.textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 12,
                                    offset: Offset(0, 3),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      state.repos[state.selectedIndex].image!),
                                  radius: 20,
                                ),
                                title: Text(
                                  state.repos[state.selectedIndex].name ?? '',
                                  style: Styles.bodyBoldMedium,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          Strings.projects,
                          style: Styles.bodyBoldMedium,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: childProjects(state,
                        state.repos[state.selectedIndex].name ?? '', context),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            appBar: null,
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget buildDrawer(LoadReposDataState state, BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ), //BoxDecoration
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(state.profile),
                radius: 30,
              ),
              title: Text(
                state.username,
                style: Styles.textWhite,
              ),
              subtitle: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF9C37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                  ),
                  child: Text(
                    state.login,
                    style: Styles.textWhiteMedium,
                  )),
              onTap: () {},
            ), //UserAccountDrawerHeader
          ),
          ListView.builder(
              itemCount: state.repos.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    homeBloc!.add(ChangeRepoEvent(index));
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(state.repos[index].image!),
                        radius: 20,
                      ),
                      title: Text(
                        state.repos[index].name ?? '',
                        style: Styles.bodyBoldMedium,
                      ),
                    ),
                  ),
                );
              }), //DrawerHeader

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              leading: CircleAvatar(child: const Icon(Icons.logout)),
              title: Text(
                'LogOut',
                style: Styles.bodyBoldMedium,
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await SharedPreferencesService.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> childProjects(
      LoadReposDataState state, String name, BuildContext context) {
    List<Widget> project = [];
    for (var item in state.data) {
      if (item.owner?.login == name) {
        project.add(
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectPage(item)),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.owner?.avatarUrl ?? ''),
                    radius: 20,
                  ),
                  title: Text(
                    item.name ?? '',
                    style: Styles.bodyBoldMedium,
                  ),
                  subtitle: Text(
                    item.owner?.login ?? '',
                    style: Styles.bodyLight,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
        );
      }
    }
    return project;
  }
}
