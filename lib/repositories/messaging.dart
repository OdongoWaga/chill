import 'package:chill/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class MessagingRepository {
  final Firestore _firestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  MessagingRepository({FirebaseStorage firebaseStorage, Firestore firestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestore = firestore ?? Firestore.instance;

  Future sendMessage({Message message}) async {
    StorageUploadTask storageUploadTask;
    DocumentReference messageRef = _firestore.collection('messages').document();
    CollectionReference senderRef = _firestore
        .collection('users')
        .document(message.senderId)
        .collection('chats')
        .document(message.selectedUserId)
        .collection('messages');

    CollectionReference sendUserRef = _firestore
        .collection('users')
        .document(message.selectedUserId)
        .collection('chats')
        .document(message.senderId)
        .collection('messages');

    if (message.photo != null) {
      StorageReference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.documentID)
          .child(uuid);

      storageUploadTask = photoRef.putFile(message.photo);

      await storageUploadTask.onComplete.then((photo) async {
        await photo.ref.getDownloadURL().then((photoUrl) async {
          await messageRef.setData({
            'senderName': message.senderName,
            'senderId': message.senderId,
            'text': null,
            'photoUrl': photoUrl,
            'timestamp': DateTime.now(),
          });
        });
      });

      senderRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});

      sendUserRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .document(message.senderId)
          .collection('chats')
          .document(message.selectedUserId)
          .updateData({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .document(message.selectedUserId)
          .collection('chats')
          .document(message.senderId)
          .updateData({'timestamp': DateTime.now()});
    }
    if (message.text != null) {
      await messageRef.setData({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photoUrl': null,
        'timestamp': DateTime.now(),
      });

      senderRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});

      sendUserRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .document(message.senderId)
          .collection('chats')
          .document(message.selectedUserId)
          .updateData({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .document(message.selectedUserId)
          .collection('chats')
          .document(message.senderId)
          .updateData({'timestamp': DateTime.now()});
    }
  }

  Stream<QuerySnapshot> getMessages({currentUserId, selectedUserId}) {
    return _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chats')
        .document(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({messageId}) async {
    Message _message = Message();

    await _firestore
        .collection('messages')
        .document(messageId)
        .get()
        .then((message) {
      _message.senderId = message['senderId'];
      _message.senderName = message['senderName'];
      _message.timestamp = message['timestamp'];
      _message.text = message['text'];
      _message.photoUrl = message['photoUrl'];
    });

    return _message;
  }
}
