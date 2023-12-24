import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:github/project/bloc/state.dart';
import 'package:http/http.dart' as http;

import '../../Model/branch_model.dart';
import '../../Model/commit_model.dart';
import '../../utils/constant.dart';
import '../../utils/shared_preferences.dart';
import 'event.dart';



class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  String? token;
  BranchState branchState = BranchState([],[],[]);
  ProjectBloc() : super(InitialState()) {
    on<InitEvent>(_init);
    on<GetCommitLogs>(_getCommitLogs);
  }

  void _init(InitEvent event, Emitter<ProjectState> emit) async {
    token = await SharedPreferencesService.loadString(Constants.token);

    final response = await http.get(
      Uri.parse('https://api.github.com/repos/${event.owner}/${event.repo}/branches'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<BranchModel> branchModel = List<BranchModel>.from(data.map((repo) => BranchModel.fromJson(repo)));
      List<Tab> tabs =[];
      for (var element in branchModel) {tabs.add(Tab( child: Container(
           padding: const EdgeInsets.all(12.0), child: Text(element.name ?? ''))));}

      branchState..tabs = tabs
      ..branchModel = branchModel;
      add(GetCommitLogs(
          event.owner,
          event.repo,
          branchModel[0].name ?? ''));
      emit(branchState);
    } else {
      throw Exception('Failed to load branches');
    }
  }

  _getCommitLogs(GetCommitLogs event, Emitter<ProjectState> emit) async{
    emit(CommitUpdatingState());
    final response = await http.get(
      Uri.parse('https://api.github.com/repos/${event.owner}/${event.repo}/commits?sha=${event.branch}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<CommitsModel> commitModel = List<CommitsModel>.from(data.map((repo) => CommitsModel.fromJson(repo)));
      branchState.commitModel = commitModel;
      emit(branchState);
    } else {
      throw Exception('Failed to load commits');
    }
  }
}
