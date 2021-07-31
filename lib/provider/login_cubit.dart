
import 'package:altais/provider/login_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';



part 'login_data_state.dart';

class LoginCubit extends Cubit<LoginState> {
 LoginCubit() : super(LoginDataInitial()){
   _loginRepository = GetIt.I.get<LoginRepository>();
 }

  LoginRepository? _loginRepository;

  getLoginData(String token) async {
    try {
      dynamic loginDataResponse = await _loginRepository!.login(token);
      //Emit resuslt after api response
      
      if(loginDataResponse != null){
         print('check');
          emit(LoginDataSuccess(loginDataResponse));
      }
      else{
        emit(LoginDataValidation("Not Valid Token"));
      }
      //emit(LoginDataSuccess(loginDataResponse));
      
    } catch (error) {
      emit(LoginDataFailure(error));
    }
  }
}
 
