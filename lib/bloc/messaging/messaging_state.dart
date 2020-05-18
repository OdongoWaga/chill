import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();
  @override
  List<Object> get props => [];
}

class MessagingInitialState extends MessagingState {}

class MessagingLoadingState extends MessagingState {}

class MessagingLoadedState extends MessagingState {
  final Stream<QuerySnapshot> messageStream;

  MessagingLoadedState({this.messageStream});

  @override
  List<Object> get props => [messageStream];
}
