import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class LoadingState extends MatchesState {}

class LoadUserState extends MatchesState {
  final Stream<QuerySnapshot> matchedList;
  final Stream<QuerySnapshot> selectedList;

  LoadUserState({this.matchedList, this.selectedList});

  @override
  List<Object> get props => [matchedList, selectedList];
}
