import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Toaster{

void Errors_msg(msg){
Fluttertoast.showToast(
        msg:msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
}

}

