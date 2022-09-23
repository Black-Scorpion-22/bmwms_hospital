import 'dart:convert';
import 'package:bmwms_hospital/model/staff_type.dart';
import 'package:bmwms_hospital/model/staffs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import '../model/staff_model.dart';
import '../utility/Alerts.dart';
import '../utility/ApiUrl.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {

  List<StaffDetailsModel> staff_d_model = [];
  List<StaffModel> staff_model = [];
  List<StaffModel> s_model = [];
  List<StaffType> staff_type = [];
  String? s_id_num, s_name, s_adrs, s_contat, s_type, s_status;
  var selected_staff, selected_type, selected_status, staff_id;
  TextEditingController staffName_controller = TextEditingController();
  TextEditingController staffIdNum_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  bool card_visible = false;

  getStaffs() async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var hId = sharedPreferences.getString("hospital_id");
    print(hId);
    try {
      final response = await http.get(Uri.parse(ApiUrl.GET_ALL_STAFFS+hId!));
      // print("resp.." + response.body.toString());

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var staffs = data['sttf'];

        staffs.forEach((data) {
          var staff = StaffModel();
          staff.staffId = data['id'];
          staff.staffName = data['staff_name'];
          setState(() {
            staff_model.add(staff);
          });
        });


        Navigator.of(context).pop();

      } else {
        Navigator.of(context).pop();
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }

  getStaffDetails(String staff_id) async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    try {
      final response = await http.get(Uri.parse(ApiUrl.GET_STAFF_DETAILS+staff_id));
      // print("resp.." + response.body.toString());
      print("staff:"+staff_id);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var staffs = data['staff'][0];
        setState(() {
          card_visible = true;
          s_name = staffs['staff_name'];
          s_id_num = staffs['staff_id_number'];
          s_contat = staffs['staff_contact'];
          s_adrs = staffs['staff_address'];
          s_type = staffs['staff_type'];
          s_status = staffs['status'];

          staffName_controller.text = s_name!;
          staffIdNum_controller.text = s_id_num!;
          contact_controller.text = s_contat!;
          address_controller.text = s_adrs!;
          selected_type = s_type;
          selected_status = s_status;

        });
        Navigator.of(context).pop();
        // print(s_name+''+s_contat+''+staff_id);

      } else {
        Navigator.of(context).pop();
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }

  update_staff_details() async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    try {
      var jsonMap = jsonEncode(
          {
            "address":address_controller.text,
            "contact":contact_controller.text,
            "idcard":staffIdNum_controller.text,
            "stfftyp":selected_type,
            "stfstat":selected_status,
            "stfid":selected_staff
          }
      );
      print(jsonMap);
      final response = await http.post(Uri.parse(ApiUrl.UPDATE_STAFF_DETAILS),
          body: jsonMap);
      print("profile.." + response.body.toString());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var status = data['Stat'];
        if(status == "Success"){
          setState(() {
            staffName_controller.text = "";
            staffIdNum_controller.text = "";
            contact_controller.text = "";
            address_controller.text = "";
            selected_staff = null;
            selected_type = null;
            selected_status = null;
            card_visible = false;
            Navigator.of(context).pop();
            _showSuccessDialog(context);
          });
        }
        // Navigator.of(context).pop();

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getStaffs();
    });
    staff_type.add(new StaffType(id: "1", s_type: "Permanent", type: "P"));
    staff_type.add(new StaffType(id: "2", s_type: "Contractual", type: "C"));

    s_model.add(new StaffModel(staffStatus: "1", s_Status: "Enable"));
    s_model.add(new StaffModel(staffStatus: "0", s_Status: "Disable"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff114382),
        title: Text("Staff Members"),
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
                            SizedBox(height: 20),
                            Text("Select Staff",
                                style: TextStyle(color: const Color(0xff114382),
                                    fontSize: 17, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start),
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
                                  items: staff_model.map((itemone){
                                    return DropdownMenuItem(
                                        value: itemone.staffId,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text(itemone.staffName!),
                                        )
                                    );
                                  }).toList(),
                                  value: selected_staff,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_staff = value!;
                                      print("selected:"+selected_staff);
                                      getStaffDetails(selected_staff);
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
                            SizedBox(height: 10),
                            Visibility(
                              visible: card_visible,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Edit Staff Details",
                                            style: TextStyle(color: const Color(0xff114382),
                                                fontSize: 17, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start),
                                        SizedBox(height: 10),
                                        Text("Staff Name:",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                            textAlign: TextAlign.start),
                                        SizedBox(height: 10),
                                        SizedBox(width: double.infinity,
                                          child: TextField(
                                            controller: staffName_controller,
                                            enabled: false,
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
                                        SizedBox(height: 10),
                                        Text("Staff ID Number:",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                            textAlign: TextAlign.start),
                                        SizedBox(height: 10),
                                        SizedBox(width: double.infinity,
                                          child: TextField(
                                            controller: staffIdNum_controller,
                                            enabled: false,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder()),
                                            cursorColor: Colors.blue,
                                            cursorWidth: 2.0,
                                            textInputAction: TextInputAction.done,
                                            style: TextStyle(
                                                color: Colors.black,fontSize: 17
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Contact:",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                            textAlign: TextAlign.start),
                                        SizedBox(height: 10),
                                        SizedBox(width: double.infinity,
                                          child: TextField(
                                            controller: contact_controller,
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
                                        SizedBox(height: 10),
                                        Text("Address:",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                            textAlign: TextAlign.start),
                                        SizedBox(height: 10),
                                        SizedBox(width: double.infinity,
                                          child: TextField(
                                            controller: address_controller,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder()),
                                            cursorColor: Colors.blue,
                                            cursorWidth: 2.0,
                                            textInputAction: TextInputAction.done,
                                            style: TextStyle(
                                                color: Colors.black,fontSize: 17
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Staff Type",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),textAlign: TextAlign.start),
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
                                              items: staff_type.map((itemone){
                                                return DropdownMenuItem(
                                                    value: itemone.type,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8),
                                                      child: Text(itemone.s_type!),
                                                    )
                                                );
                                              }).toList(),
                                              value: selected_type,
                                              onChanged: (value) {
                                                setState(() {
                                                  selected_type = value!;
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
                                        SizedBox(height: 10),
                                        Text("Status",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),textAlign: TextAlign.start),
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
                                              items: s_model.map((itemone){
                                                return DropdownMenuItem(
                                                    value: itemone.staffStatus,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8),
                                                      child: Text(itemone.s_Status!),
                                                    )
                                                );
                                              }).toList(),
                                              value: selected_status,
                                              onChanged: (value) {
                                                setState(() {
                                                  selected_status = value!;
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
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 45,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                update_staff_details();
                                              },
                                              style: ButtonStyle(
                                                  overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
                                                  backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
                                              child: const Text(
                                                'Update',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
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
        title: const Text('Success !!!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('You Have Successfully Edited Staff Details',style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => DashboardScreen()));
            },
          ),
        ],
      );
    },
  );
}
