abstract class HomeEvent {}

class InitEvent extends HomeEvent {}

class ChangeRepoEvent extends HomeEvent {
  int index;
  ChangeRepoEvent(this.index);
}