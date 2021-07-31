part of 'login_cubit.dart';


class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginDataInitial extends LoginState {
  @override
  String toString() => "LoginDataInitial";
}

class LoginStart extends LoginState {
  final LoginStart loginDataResponse;
  LoginStart(this.loginDataResponse);
  @override
  String toString() => "LoginStart";
}

class LoginDataSuccess extends LoginState {
  final dynamic loginDataResponse;

  LoginDataSuccess(this.loginDataResponse);

 
  @override
  String toString() => "LoginDataSuccess";
}

class LoginDataValidation extends LoginState {
  final dynamic loginDataResponse;

  LoginDataValidation(this.loginDataResponse);

  @override
  String toString() => "Login Validations Error";
}

class LoginDataFailure extends LoginState {
  final dynamic loginDataResponse;

  LoginDataFailure(this.loginDataResponse);

  @override
  String toString() => "LoginDataFailure";
}
