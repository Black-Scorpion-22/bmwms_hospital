import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:bmwms_hospital/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/handover_item.dart';
import '../utility/Alerts.dart';
import '../utility/ApiUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandOverScreen extends StatefulWidget {
  const HandOverScreen({Key? key}) : super(key: key);

  @override
  State<HandOverScreen> createState() => _HandOverScreenState();
}

class _HandOverScreenState extends State<HandOverScreen> {

  List<HandoverItems> handover_items = [];
  bool list_Visible = false;
  bool alert_Visible = false;
  String? status, uniq_genId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getHandOverItems();
    });
  }

  getHandOverItems() async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var hId = sharedPreferences!.getString("hospital_id");
    try {
      final response = await http.get(Uri.parse(ApiUrl.GET_HANDOVER_ITEMS+hId!));
      print("resp.." + response.body.toString());

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String status = data['Stat'];

        if(status == "DN"){
          String pres = data['pres'];
          if(pres == "Y"){
            uniq_genId = data['Unik'];
            var waste_items = data['garb'];
            waste_items.forEach((data) {
              var handover_value = HandoverItems();
              handover_value.bag_color = data['bag_color'];
              handover_value.qty_generated = data['Gent'];
              handover_value.qty_pre_treated = data['pret'];
              handover_value.bags = data['bagged'];
              setState(() {
                handover_items.add(handover_value);
              });
            });
            setState(() {
              list_Visible = true;
              Navigator.of(context).pop();
            });
          }else{
            Navigator.of(context).pop();
            _showSuccessMessage(context);
          }
        }else{
          Navigator.of(context).pop();
          _showSuccessMessage(context);
        }
      } else {
        Navigator.of(context).pop();
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }

  generate_token() async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    try {
      final response = await http.get(Uri.parse(ApiUrl.GENERATE_TOKEN+uniq_genId!));
      print("resp.." + response.body.toString());

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var status = data['Stat'];
        var url = status;
        if (await canLaunch(url)) {
          await launch(url);
          print(url);
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          throw 'Could not launch $url';
        }
        /*if(status == "Success"){
          Navigator.of(context).pop();
          _showSuccessDialog(context);
        }*/
      } else {
        Navigator.of(context).pop();
        print("Error");
      }
    } catch (exception) {
      Navigator.of(context).pop();
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff114382),
        title: Text('Handover Items'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xffeeebeb),
          child: Column(
            children: [
              Visibility(
                visible: list_Visible,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Unique Generated ID:",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,fontWeight: FontWeight.bold)),
                            SizedBox(width: 10),
                            Text(uniq_genId != null ? uniq_genId! : "",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: handover_items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
                            child: Card(
                              color: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('Type Of Bag:',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black54),
                                              textAlign: TextAlign.center),
                                          SizedBox(width: 5),
                                          Text(handover_items[index].bag_color!,
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('Quantity Generated:',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black54),
                                              textAlign: TextAlign.center),
                                          SizedBox(width: 5),
                                          Text(handover_items[index].qty_generated != null ? handover_items[index].qty_generated! : "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('Quantity Pre-Treated:',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black54),
                                              textAlign: TextAlign.center),
                                          SizedBox(width: 5),
                                          Text(handover_items[index].qty_pre_treated != null ? handover_items[index].qty_pre_treated! : "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('No Of Bags:',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black54),
                                              textAlign: TextAlign.center),
                                          SizedBox(width: 5),
                                          Text(handover_items[index].bags != null ? handover_items[index].bags! : "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generate_token();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}

_showSuccessMessage(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert !!!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Please Contact To Your Hospital Administration',style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Back'),
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

_showSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success !!!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('You Have Successfully Generated QR Code',style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
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
