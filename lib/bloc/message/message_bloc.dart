import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chill/repositories/messageRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageRepository _messageRepository;

  MessageBloc({@required MessageRepository messageRepository})
      : assert(messageRepository != null),
        _messageRepository = messageRepository;

  @override
  MessageState get initialState => MessageInitialState();

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is ChatStreamEvent) {
      yield* _mapStreamToState(currentUserId: event.currentUserId);
    }
  }

  Stream<MessageState> _mapStreamToState({String currentUserId}) async* {
    yield ChatLoadingState();

    Stream<QuerySnapshot> chatStream =
        _messageRepository.getChats(userId: currentUserId);
    yield ChatLoadedState(chatStream: chatStream);
  }
}
