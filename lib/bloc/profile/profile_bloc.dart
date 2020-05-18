import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ProfileState get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _userRepository.getUser();
      yield* _mapSubmittedToState(
          photo: event.photo,
          name: event.name,
          gender: event.gender,
          userId: uid,
          age: event.age,
          location: event.location,
          interestedIn: event.interestedIn);
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileState> _mapAgeChangedToState(DateTime age) async* {
    yield state.update(
      isAgeEmpty: age == null,
    );
  }

  Stream<ProfileState> _mapGenderChangedToState(String gender) async* {
    yield state.update(
      isGenderEmpty: gender == null,
    );
  }

  Stream<ProfileState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    yield state.update(
      isInterestedInEmpty: interestedIn == null,
    );
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.update(
      isLocationEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapSubmittedToState(
      {File photo,
      String gender,
      String name,
      String userId,
      DateTime age,
      GeoPoint location,
      String interestedIn}) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.profileSetup(
          photo, userId, name, gender, interestedIn, age, location);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
