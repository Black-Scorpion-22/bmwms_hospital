import 'package:bmwms_hospital/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Alerts{
  static Future<void> show(context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLogin(context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  static showAlertDialog(BuildContext context, String title, String message){
    Widget onPositiveButton = TextButton(
        onPressed: (){},
        child: Text("OK")
    );
    Widget onNegativeButton = TextButton(
        onPressed: (){},
        child: Text("CANCEL")
    );
    AlertDialog dialog = new AlertDialog(
      actions: [onNegativeButton, onPositiveButton],
      title: Text(title),
      content: Text(message),
    );  
    showDialog(
        context: context,
        builder: (BuildContext context){
          return dialog;
        });
  }
  
}