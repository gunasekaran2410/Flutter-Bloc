import 'package:altais/provider/login_api_provider.dart';

class LoginRepository{

  LoginProvider lp = LoginProvider();

  Future<dynamic> login(String token){

    return lp.getHttp(token);
    
    
  }
 



}