import 'dart:convert';
import 'dart:developer';

import 'package:altais/home.dart';
import 'package:altais/provider/login_api_provider.dart';
import 'package:altais/provider/login_cubit.dart';

import 'package:altais/provider/login_repository.dart';
import 'package:altais/provider/login_state.dart';

import 'package:flutter/material.dart';
import 'package:altais/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  late SharedPreferences prefs;
  var token;
  var _formKey = GlobalKey<FormState>();
  var body;
  TextEditingController emailController = TextEditingController(text: "");
  Toaster toaster = Toaster();
  LoginCubit? _loginCubit;
  //final getIt = GetIt.instance;


  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    
     _loginCubit = GetIt.I.get<LoginCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
         cubit: GetIt.I.get <LoginCubit>(),
        listener: (context, state) {
        switch (state.runtimeType) {
          case LoginStart:
            {
               print("Login Start");
            }
            break;
              case LoginDataValidation:
            {
              toaster.Errors_msg("Not a Valided");
            }
            break;
            case LoginDataSuccess:
            {
              var token = emailController.value.text.toString();
              prefs.setString("token", token);
              
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Home()));
            }
            break;
            case LoginDataFailure:
            toaster.Errors_msg("Token Expired Login");
            break;
          case LoginDataInitial:
          default:
            return;
        }
      },
      child: loginUI(),
    ));
  }

  Widget loginUI() {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    'altais',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.red,
                    ),
                  )),
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 0),
                    child: Text(
                      'Please Log In Below',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 0),
                    child: Text(
                      'Enter your Altais eNable account email and password in the feilds below',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'JWT TOKEN *',
                    ),
                    // validator: (value) {
                    //   return null;
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter JWT token';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      // print(value);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(_formKey.currentState!.validate());
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Navigator.pushReplacement(
                      //     context, MaterialPageRoute(builder: (_) => Home()));
                      // log(emailController.value.text);
                      // return;

                      if (emailController.value.text.toString() != "") {
                        token = emailController.text;
                      }

                      //LoginRepository lp = LoginRepository();

                      _loginCubit!.getLoginData(token).then((value) {
                      
                        // print(value.body);

                        setState(() {
                          body = json.decode(value.body);
                          // print(body);
                        });

                      }).catchError((onError) {
                        log(onError.toString());
                      });
                    } else {
                      toaster.Errors_msg("Enter a Valid Token");
                    }
                  },
                  child: Text("Submit"),
                )
              ],
            )));
  }
}
