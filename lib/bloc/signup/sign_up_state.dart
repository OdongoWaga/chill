import 'package:meta/meta.dart';

@immutable
class SignUpState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  SignUpState(
      {@required this.isEmailValid,
      @required this.isPasswordValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  //initial state
  factory SignUpState.empty() {
    return SignUpState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
    );
  }

  factory SignUpState.loading() {
    return SignUpState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isFailure: false,
      isSuccess: false,
    );
  }

  factory SignUpState.failure() {
    return SignUpState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isFailure: true,
      isSuccess: false,
    );
  }

  factory SignUpState.success() {
    return SignUpState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: true,
    );
  }

  SignUpState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
    );
  }

  SignUpState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return SignUpState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isSubmitting: isSubmitting ?? this.isPasswordValid,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }
}
