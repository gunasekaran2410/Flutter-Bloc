import 'dart:convert';

import 'package:altais/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Participant extends StatefulWidget {
  final list;
  Participant({Key? key, this.list}) : super(key: key);

  @override
  _ParticipantState createState() => _ParticipantState();
}

class _ParticipantState extends State<Participant> {
  List data = [];
  late SharedPreferences pref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    inbox(token).then((value) {
      var body = value.body;
  
      setState(() {
        data = json.decode(body)["participants"];
      });
    });
  }

  Future<http.Response> inbox(token) {
    var conversation_id = widget.list['id'].toString();
    var conversation_result_url =
        "https://api.devplatform.uw2.alth.us/api/messaging/v1/conversations/" +
            conversation_id;
    print("calling external api request need internet");
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
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => Home()));
              },
            ),
          ],
          title: Container(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                    child: Text(
                  widget.list['subject'],
                  style: TextStyle(fontSize: 15),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                    child: Text(
                  "${data.length} Members",
                  style: TextStyle(fontSize: 12),
                )),
              ),
            ],
          )),
        ),
        body: new Builder(builder: (BuildContext context) {
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var profileInfo = data[index]["userType"] == "PATIENT"
                    ? data[index]['patientProfile']
                    : data[index]['providerProfile'];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 12,
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  profileInfo['firstName'] +
                                      " " +
                                      profileInfo['lastName'],
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
                                  data[index]["userType"],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }));
  }
}
