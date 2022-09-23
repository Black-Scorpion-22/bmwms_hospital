import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwms_hospital/screen/dashboard_screen.dart';
import 'package:bmwms_hospital/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String? hospital_id;
  var hId;

  @override
  void initState() {
    super.initState();
    getUserData();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, loginRoute);
  }

  loginRoute(){
    if(hId == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    hId = sharedPreferences.getString("hospital_id");
    print('$hId');
    setState((){
      hospital_id = hId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // gradient:  LinearGradient(
              //     colors: [(new Color(0xff1A83C6)), (new Color(0xff4BA3DB))],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // )
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset("assets/images/dd.png"),
                  height: 250.0,
                  width: 250.0,
                ),
                Text(
                  "B M W M S",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff114382)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
