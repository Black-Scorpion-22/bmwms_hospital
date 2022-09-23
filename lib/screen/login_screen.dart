import 'dart:convert';
import 'package:bmwms_hospital/screen/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utility/Alerts.dart';
import '../utility/ApiUrl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  var _emailPhone, _password, data, email;

  verifyFormAndSubmit() {
    _emailPhone = email_controller.text.toString();
    _password = password_controller.text.toString();

    print("info"+_emailPhone+''+_password);
    if (_emailPhone == "" || _password == "") {
      Alerts.showLogin(context, "Error", "You need to fill all the fields");
    }else {
      loginUser(_emailPhone, _password);
    }
  }

  loginUser(String emailPhone, String password) async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    try {
      var jsonMap = jsonEncode(
          {
            "username":emailPhone,
            "password":password
          }
      );
      final response = await http.post(Uri.parse(ApiUrl.LOGIN),
          body: jsonMap);
      print("resp.."+response.body.toString());
      if (response.statusCode == 200) {
        data = jsonDecode(response.body.toString());
        var status = data['Stat'];
        if(status == "Success"){
          var h_id = data['id'];
          var h_name = data['hospitalname'];
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('hospital_id', h_id);
          sharedPreferences.setString('hospital_name', h_name);
          var hid = sharedPreferences.getString("hospital_id");
          var hname = sharedPreferences.getString("hospital_name");
          print('$hid $hname');
          print("Login successfully");
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        }else if(status == "Email does not exist."){
          Navigator.of(context).pop();
          Alerts.showLogin(context, "Try Again !", "Email Does Not Exist");
        }else if(status == "Password wrong"){
          print(status);
          Navigator.of(context).pop();
          Alerts.showLogin(context, "Try Again !", "Wrong Password");
        }else{
          Navigator.of(context).pop();
          print("Error");
        }
      }
      else{
        Navigator.of(context).pop();
        print("No Response");
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      child: Image.asset("assets/images/dd.png"),
                      height: 150,
                      width: 150,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Welcome To Login Screen",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff114382)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 90),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                  boxShadow: [BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Color(0xff114382)
                  )],
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: email_controller,
                  cursorColor: Color(0xff114382),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Color(0xff114382),
                      ),
                      hintText: "Enter Email",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                  boxShadow: [BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Color(0xff114382)
                  )],
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: password_controller,
                  obscureText: true,
                  cursorColor: Color(0xff114382),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.vpn_key,
                        color: Color(0xff114382),
                      ),
                      hintText: "Enter Password",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none
                  ),
                )
            ),
            GestureDetector(
              onTap: () {
                 verifyFormAndSubmit();
                /*Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DashboardScreen()
                ));*/
              },
              child: Card(
                elevation: 10,
                color: Color(0xff114382),
                margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                child: Container(
                  alignment: Alignment.center,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Color(0xff114382),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE),
                    )],
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
