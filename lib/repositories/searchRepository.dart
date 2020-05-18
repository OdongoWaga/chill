import 'package:chill/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepository {
  final Firestore _firestore;

  SearchRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<User> chooseUser(currentUserId, selectedUserId, name, photoUrl) async {
    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('selectedList')
        .document(currentUserId)
        .setData({
      'name': name,
      'photoUrl': photoUrl,
    });
    return getUser(currentUserId);
  }

  passUser(currentUserId, selectedUserId) async {
    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});
    return getUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    User currentUser = User();

    await _firestore.collection('users').document(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photoUrl'];
      currentUser.gender = user['gender'];
      currentUser.interestedIn = user['interestedIn'];
    });
    return currentUser;
  }

  Future<List> getChosenList(userId) async {
    List<String> chosenList = [];
    await _firestore
        .collection('users')
        .document(userId)
        .collection('chosenList')
        .getDocuments()
        .then((docs) {
      for (var doc in docs.documents) {
        if (docs.documents != null) {
          chosenList.add(doc.documentID);
        }
      }
    });
    return chosenList;
  }

  Future<User> getUser(userId) async {
    User _user = User();
    List<String> chosenList = await getChosenList(userId);
    User currentUser = await getUserInterests(userId);

    await _firestore.collection('users').getDocuments().then((users) {
      for (var user in users.documents) {
        if ((!chosenList.contains(user.documentID)) &&
            (user.documentID != userId) &&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)) {
          _user.uid = user.documentID;
          _user.name = user['name'];
          _user.photo = user['photoUrl'];
          _user.age = user['age'];
          _user.location = user['location'];
          _user.gender = user['gender'];
          _user.interestedIn = user['interestedIn'];
          break;
        }
      }
    });

    return _user;
  }
}
