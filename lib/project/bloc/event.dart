import 'package:flutter/material.dart';

abstract class ProjectEvent {}

class InitEvent extends ProjectEvent {
  String owner,repo;
  BuildContext context;
  InitEvent(this.owner,this.repo,this.context);
}

class GetCommitLogs extends ProjectEvent{
  String owner,repo,branch;
  GetCommitLogs(this.owner,this.repo,this.branch);
}