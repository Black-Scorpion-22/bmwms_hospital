import 'dart:convert';
import 'package:bmwms_hospital/model/bag_color.dart';
import 'package:bmwms_hospital/screen/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:bmwms_hospital/model/waste_types.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utility/Alerts.dart';
import '../utility/ApiUrl.dart';

class PreTreatmentScreen extends StatefulWidget {
  const PreTreatmentScreen({Key? key}) : super(key: key);

  @override
  State<PreTreatmentScreen> createState() => _PreTreatmentScreenState();
}

class _PreTreatmentScreenState extends State<PreTreatmentScreen> {

  List<WasteTypeModel> waste_type_model = [];
  List<BagColor> bag_color_model = [];
  var selected_bag, w_length, new_list, wstdtls_items, waste_value;
  String? selected_waste;
  String genid = "";
  int click = 0;
  TextEditingController qty_gen_controller = TextEditingController();
  TextEditingController qty_pre_controller = TextEditingController();
  TextEditingController bags_controller = TextEditingController();

  getWasteTypes() async {
    // Alerts.showProgressDialog(context, "Processing, Please wait...");
    try {
      final response = await http.get(Uri.parse(ApiUrl.GET_PRE_TREATMENT+"1"));
      print("resp.." + response.body.toString());

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var status = data['Stat'];
        if(status == "YP"){
          wstdtls_items = data['wstdtls'];
          wstdtls_items.forEach((data) {
            waste_value = WasteTypeModel();
            waste_value.id = data['id'];
            waste_value.w_name = data['w_name'];
            setState(() {
              waste_type_model.add(waste_value);
            });
          });
        }else{
          _showSuccessDialog(context);
        }
        w_length = waste_type_model.length;
        print(w_length);
      } else {
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }

  getBags() async {
    // Alerts.showProgressDialog(context, "Processing, Please wait...");
    try {
      final response = await http.get(Uri.parse(ApiUrl.GET_PRE_TREATMENT+"1"));
      print("resp.." + response.body.toString());

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var items = data['bagcolor'];
        items.forEach((data) {
          var color = BagColor();
          color.id = data['id'];
          color.bag_color = data['bag_color'];
          setState(() {
            bag_color_model.add(color);
          });
        });
        // Navigator.of(context).pop();

      } else {
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }

  waste_submission() async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var hId = sharedPreferences!.getString("hospital_id");
    try {
      var jsonMap = jsonEncode(
          {
            "hid":hId,
            "genid":genid,
            "type_of_waste":selected_waste,
            "qty_generated":qty_gen_controller.text.toString(),
            "qty_pre_treated":qty_pre_controller.text.toString(),
            "no_of_bags":bags_controller.text.toString(),
            "type_of_bags":selected_bag
          }
      );
      print(jsonMap);
      final response = await http.post(Uri.parse(ApiUrl.PRE_TREATMENT_SUBMISSION),
        body: jsonMap);
      print("resp.." + response.body.toString());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // waste_type_model.clear();
        genid = data["Uniq"];
        setState(() {
          selected_waste = null;
          qty_pre_controller.text = "";
          qty_gen_controller.text = "";
          bags_controller.text = "";
          selected_bag = null;
        });
        Navigator.of(context).pop();
        if(click == waste_type_model.length){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        }
        /*wstdtls_items = data['wstdtls'];
        wstdtls_items.forEach((data) {
          waste_value = WasteTypeModel();
          waste_value.id = data['id'];
          waste_value.w_name = data['w_name'];
          setState(() {
            waste_type_model.add(waste_value);
          });
        });*/
        print(genid+" success");
      } else {
        Navigator.of(context).pop();
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    getWasteTypes();
    getBags();
  }

  @override
  Widget build(BuildContext context) {
    final etSkillScore1Key = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff114382),
        title: Text("Pre Treatment"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            Text("Types Of Wastage",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),textAlign: TextAlign.start),
                            SizedBox(height: 10),
                            Container(
                              height: 55,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black, //
                                  ),
                                  items: waste_type_model.map((itemone){
                                    return DropdownMenuItem(
                                        value: itemone.id,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text(itemone.w_name!),
                                        )
                                    );
                                  }).toList(),
                                  value: selected_waste,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_waste = value!;
                                    });
                                  },
                                  buttonHeight: 40,
                                  buttonWidth: 500,
                                  itemHeight: 40,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(0xFFffffff),
                                  ),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Quantity Generated",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),textAlign: TextAlign.start,),
                            SizedBox(height: 10),
                            SizedBox(width: double.infinity,
                              child: TextField(
                                controller: qty_gen_controller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder()),
                                cursorColor: Colors.blue,
                                cursorWidth: 2.0,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.black,fontSize: 17
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Quantity Pre Treated",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),textAlign: TextAlign.start,),
                            SizedBox(height: 10),
                            SizedBox(width: double.infinity,
                              child: TextField(
                                controller: qty_pre_controller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder()),
                                cursorColor: Colors.blue,
                                cursorWidth: 2.0,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.black,fontSize: 17
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("No of Bags Used",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),textAlign: TextAlign.start,),
                            SizedBox(height: 10),
                            SizedBox(width: double.infinity,
                              child: TextField(
                                controller: bags_controller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder()),
                                cursorColor: Colors.blue,
                                cursorWidth: 2.0,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.black,fontSize: 17
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Types Of Bag",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),textAlign: TextAlign.start),
                            SizedBox(height: 10),
                            Container(
                              height: 55,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black, //
                                  ),
                                  items: bag_color_model.map((itemone){
                                    return DropdownMenuItem(
                                        value: itemone.id,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text(itemone.bag_color!),
                                        )
                                    );
                                  }).toList(),
                                  value: selected_bag,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_bag = value;
                                    });
                                  },
                                  buttonHeight: 40,
                                  buttonWidth: 500,
                                  itemHeight: 40,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(0xFFffffff),
                                  ),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    click = click+1;
                                    if(selected_waste == null || qty_gen_controller.text == "" || qty_pre_controller.text == "" || bags_controller.text == "" || selected_bag == null){
                                      Alerts.show(context, "Error", "You need to fill all the fields");
                                    }else{
                                      waste_submission();
                                    }
                                  },
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
                                      backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 17),
                                  )),
                            ),
                            SizedBox(height: 20)
                          ],
                        ),

                      ),
                    ]
                ),
              ),
            ]

        ),
      ),
    );
  }
}

_showSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert !!!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('You Are Not Able To Generate Pre Treatment',style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold)),
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