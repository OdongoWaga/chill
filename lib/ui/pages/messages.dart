import 'package:chill/bloc/message/bloc.dart';
import 'package:chill/repositories/messageRepository.dart';
import 'package:chill/ui/widgets/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Messages extends StatefulWidget {
  final String userId;

  Messages({this.userId});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  MessageRepository _messagesRepository = MessageRepository();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(messageRepository: _messagesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _messageBloc,
      builder: (BuildContext context, MessageState state) {
        if (state is MessageInitialState) {
          _messageBloc.add(ChatStreamEvent(currentUserId: widget.userId));
        }
        if (state is ChatLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;

          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("No data");
              }

              if (snapshot.data.documents.isNotEmpty) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatWidget(
                        creationTime:
                            snapshot.data.documents[index].data['timestamp'],
                        userId: widget.userId,
                        selectedUserId:
                            snapshot.data.documents[index].documentID,
                      );
                    },
                  );
                }
              } else
                return Text(
                  " You don't have any conversations",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                );
            },
          );
        }
        return Container();
      },
    );
  }
}
