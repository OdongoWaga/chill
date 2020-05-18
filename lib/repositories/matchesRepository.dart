import 'package:chill/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesRepository {
  final Firestore _firestore;

  MatchesRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Stream<QuerySnapshot> getMatchedList(userId) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection('matchedList')
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedList(userId) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection('selectedList')
        .snapshots();
  }

  Future<User> getUserDetails(userId) async {
    User _user = User();

    await _firestore.collection('users').document(userId).get().then((user) {
      _user.uid = user.documentID;
      _user.name = user['name'];
      _user.photo = user['photoUrl'];
      _user.age = user['age'];
      _user.location = user['location'];
      _user.gender = user['gender'];
      _user.interestedIn = user['interestedIn'];
    });

    return _user;
  }

  Future openChat({currentUserId, selectedUserId}) async {
    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chats')
        .document(selectedUserId)
        .setData({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chats')
        .document(currentUserId)
        .setData({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('matchedList')
        .document(selectedUserId)
        .delete();

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('matchedList')
        .document(currentUserId)
        .delete();
  }

  void deleteUser(currentUserId, selectedUserId) async {
    return await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('selectedList')
        .document(selectedUserId)
        .delete();
  }

  Future selectUser(currentUserId, selectedUserId, currentUserName,
      currentUserPhotoUrl, selectedUserName, selectedUserPhotoUrl) async {
    deleteUser(currentUserId, selectedUserId);

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('matchedList')
        .document(selectedUserId)
        .setData({
      'name': selectedUserName,
      'photoUrl': selectedUserPhotoUrl,
    });

    return await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('matchedList')
        .document(currentUserId)
        .setData({
      'name': currentUserName,
      'photoUrl': currentUserPhotoUrl,
    });
  }
}
