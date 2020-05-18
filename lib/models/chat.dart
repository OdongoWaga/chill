import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String name, photoUrl, lastMessagePhoto, lastMessage;
  Timestamp timestamp;

  Chat(
      {this.name,
      this.photoUrl,
      this.lastMessagePhoto,
      this.lastMessage,
      this.timestamp});
}
