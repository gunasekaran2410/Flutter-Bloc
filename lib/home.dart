import 'dart:convert';
import 'dart:developer';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:altais/login.dart';
import 'package:altais/participant.dart';
import 'package:altais/toaster.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List data = [];
  late SharedPreferences prefs;
  Toaster toaster = Toaster();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    log("token from storage");
    log(token.toString());
    inbox(token).then((value) {
      var body = value.body;
      print(body.toString());
      // log(body);
      
      if (value.statusCode != 200 || value.statusCode == 401) {
        toaster.Errors_msg("Token Expire Home");
        Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Login())
        );
      }

      setState(() {
        data = json.decode(body);
      });
    });
  }
  refreshData() {
    init();
  //  prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString("token");
  //   log("token from storage");
  //   log(token.toString());
  //   inbox(token).then((value) {
  //     var body = value.body;
  //     print(body.toString());
  //     // log(body);
  //     print("loaded");
  //     if (value.statusCode != 200 || value.statusCode == 401) {
  //       print('Token Expire');
  //       toaster.Errors_msg("Token Expire");
  //       Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (_) => Login())
  //       );
  //     }

  //     setState(() {
  //       data = json.decode(body);
  //     });
  //   });
  }

  Future<http.Response> inbox(token) {
    const conversation_result_url =
        "https://api.devplatform.uw2.alth.us/api/messaging/v1/conversations/profile/3fa102fa-5f59-4b34-b426-4b1ba638c800/PATIENT";
    return http.get(
      Uri.parse(conversation_result_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token"
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("All Messages"))),
        body: RefreshIndicator(child: 
        (data != null)
            ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Participant(list: data[index])));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data[index]['participants'][0]
                                              ['providerProfile']['firstName'] +
                                          " " +
                                          data[index]['participants'][0]
                                              ['providerProfile']['lastName'],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data[index]['subject'],
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      )),
                                ),
                              ]),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Badge(
                                      badgeColor: Colors.deepPurple,
                                      badgeContent: Text('1',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Tue',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                ): Text("LOADING"),
               onRefresh: () {
                    return Future.delayed(
                      Duration(seconds: 1),
                      () {
                        init();
                      },
                    );
               }
               )
    );
  }
}
