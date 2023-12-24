import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:github/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:github/home/bloc/state.dart';
import 'package:github/utils/constant.dart';

import '../../Model/repos_model.dart';
import '../../utils/shared_preferences.dart';
import 'event.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {
  String? userName,token,login,profile;
  LoadReposDataState loadReposDataState = LoadReposDataState('','','',[],[]);
  HomeBloc() : super(InitialState()) {
    on<InitEvent>(_init);
    on<ChangeRepoEvent>(_updateRepo);
  }

   _init(InitEvent event, Emitter<HomeState> emit) async {
    emit(ReposDataLoading());
    userName = await SharedPreferencesService.loadString(Constants.username);
    token = await SharedPreferencesService.loadString(Constants.token);
    login = await SharedPreferencesService.loadString(Constants.login);
    profile = await SharedPreferencesService.loadString(Constants.profile);

    final response = await http.get(
      Uri.parse(Config.userRepos),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<ReposModel> reposList = List<ReposModel>.from(data.map((repo) => ReposModel.fromJson(repo)));
      List<ReposList> repo = List<ReposList>.from(reposList.map((repo) => ReposList(name: repo.owner?.login ?? '',image:repo.owner?.avatarUrl ?? '' )));
      final ids = repo.map((e) => e.name).toSet();
      repo.retainWhere((x) => ids.remove(x.name));
      loadReposDataState..username = userName ?? ''
      ..login = login ?? ''
      ..profile = profile ?? ''
      ..data = reposList
      ..repos = repo;
      emit(loadReposDataState);
    } else {
      emit(LoadReposDataState(userName ?? '',login ?? '',profile ?? '',[],[]));

    }

  }

   _updateRepo(ChangeRepoEvent event, Emitter<HomeState> emit) {
    emit(ReposDataLoading());
     emit(loadReposDataState..selectedIndex = event.index);

  }
}

class ReposList{
  String? name,image;
  ReposList({this.name,this.image});
}