import 'package:bmwms_hospital/model/handover_item.dart';
import 'package:bmwms_hospital/screen/handover_screen.dart';
import 'package:bmwms_hospital/screen/login_screen.dart';
import 'package:bmwms_hospital/screen/pre_treatment_screen.dart';
import 'package:bmwms_hospital/screen/staff_screen.dart';
import 'package:bmwms_hospital/screen/training_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String? hospital_name, hname;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState ((){
      hospital_name = sharedPreferences!.getString("hospital_name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff114382),
        title: Text("BMWMS"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.clear();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: const Color(0xff114382),
              child: Padding(
                padding: const EdgeInsets.only(top: 50,bottom: 30),
                child: Column(
                  children: [
                    Text("BMWMS",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 10),
                    Text(hospital_name != null ? hospital_name! : "",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                    // Image.asset("assets/images/logo_dash.png",scale: 1.5),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home), title: Text("Home"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.local_hospital), title: Text("Pre Treatment"),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => PreTreatmentScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety_sharp), title: Text("Handover"),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => HandOverScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.model_training), title: Text("Training"),
              onTap: () async {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => TrainingScreen()));
              },
            ),
            /*ListTile(
              leading: Icon(Icons.face), title: Text("My Profile"),
              onTap: () async {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),*/
            ListTile(
              leading: Icon(Icons.account_box_outlined), title: Text("About"),
              onTap: () async {
                /*SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()));*/
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height:  MediaQuery.of(context).size.height,
                  color: Colors.black12,
                ),
                Container(
                  width:  MediaQuery.of(context).size.width,
                  height: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                      color: const Color(0xff114382)
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(left: 18,right: 18,bottom: 18,top: 5),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 3,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(color: const Color(0xff2F455C),width: 1)

                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.local_hospital,size: 30,color: const Color(0xff2F455C)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text("Pre Treatment",style: TextStyle(color: const Color(0xff2F455C), fontSize: 15)),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PreTreatmentScreen()));
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 3,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(color: const Color(0xff2F455C),width: 1)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.health_and_safety_sharp,size: 30,color: const Color(0xff2F455C)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text("Handover",style: TextStyle(color: const Color(0xff2F455C), fontSize: 15)),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HandOverScreen()));
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 3,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(color: const Color(0xff2F455C),width: 1)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.model_training,size: 30,color: const Color(0xff2F455C)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text("Training",style: TextStyle(color: const Color(0xff2F455C), fontSize: 15)),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrainingScreen()));
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 3,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(color: const Color(0xff2F455C),width: 1)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person,size: 30,color: const Color(0xff2F455C)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text("Staff Members",style: TextStyle(color: const Color(0xff2F455C), fontSize: 15)),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaffScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],

            ),

          ],
        ),

      ),
    );
  }
}


