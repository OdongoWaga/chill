import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chill/models/message.dart';
import 'package:chill/repositories/messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingRepository _messagingRepository;

  MessagingBloc({@required MessagingRepository messagingRepository})
      : assert(messagingRepository != null),
        _messagingRepository = messagingRepository;

  @override
  MessagingState get initialState => MessagingInitialState();

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    if (event is MessageStreamEvent) {
      yield* _mapStreamToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    }
    if (event is SendMessageEvent) {
      yield* _mapSendMessageToState(message: event.message);
    }
  }

  Stream<MessagingState> _mapStreamToState(
      {String currentUserId, String selectedUserId}) async* {
    yield MessagingLoadingState();
    Stream<QuerySnapshot> messageStream = _messagingRepository.getMessages(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
    yield MessagingLoadedState(messageStream: messageStream);
  }

  Stream<MessagingState> _mapSendMessageToState({Message message}) async* {
    await _messagingRepository.sendMessage(message: message);
  }
}
