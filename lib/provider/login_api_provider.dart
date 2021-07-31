
import 'package:altais/provider/login_cubit.dart';
import 'package:dio/dio.dart';

 class LoginProvider{
  
   Future getHttp(String token) async {
    try {
    var conversation_result_url = await Dio().get('https://api.devplatform.uw2.alth.us/api/messaging/v1/conversations/profile/3fa102fa-5f59-4b34-b426-4b1ba638c800/PATIENT',
    
    options: Options(
    headers:<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token"
      },
     ),
    );
     
    return conversation_result_url;
    
  } 
  catch (e) {
    print(e);
    
}
  //   Future<http.Response> login(String token) {
  
  //   const conversation_result_url =
  //       "https://api.devplatform.uw2.alth.us/api/messaging/v1/conversations/profile/3fa102fa-5f59-4b34-b426-4b1ba638c800/PATIENT";
  //   print("calling external api request need internet");
  //   return http.get(
  //     Uri.parse(conversation_result_url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       "Authorization": "Bearer $token"
  //     },
  //   );
  // }



 }
 }