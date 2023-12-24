import 'package:flutter/material.dart';
import 'package:github/utils/colors.dart';

import '../../Model/branch_model.dart';
import '../../Model/commit_model.dart';

class ProjectState {
}
class InitialState extends ProjectState {}

class BranchState extends ProjectState {
  List<BranchModel> branchModel;

  List<CommitsModel> commitModel;

  final selectedColor = AppColors.secondaryColor;
  List<Tab> tabs =[];
  BranchState(this.branchModel,this.tabs,this.commitModel);
}

class CommitUpdatingState extends ProjectState{
}