import '../../Model/repos_model.dart';
import 'bloc.dart';

class HomeState {
}
class InitialState extends HomeState {}

class LoadReposDataState extends HomeState{
  String username,login,profile;
  int selectedIndex =0;
  List<ReposModel> data;
  List<ReposList> repos;
  LoadReposDataState(this.username,this.login,this.profile,this.data,this.repos,{this.selectedIndex = 0});
}

class ReposDataLoading extends HomeState {}
