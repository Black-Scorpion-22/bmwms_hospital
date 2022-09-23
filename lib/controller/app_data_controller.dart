import 'dart:convert';
import 'package:bmwms_hospital/model/staff_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utility/ApiUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataController extends GetxController {
  List<StaffModel> staffData = [];
  List<MultiSelectItem> dropDownData = [];

  getSubjectData() {
    staffData.clear();
    dropDownData.clear();
    getStaffs();
  }

  getStaffs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var hId = sharedPreferences.getString("hospital_id");
    try {
      final response = await http.get(Uri.parse(ApiUrl.GET_STAFFS+hId!));
      // print("resp.." + response.body.toString());

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        staffData.clear();
        var staffs = data['sttf'];
        staffs.forEach((data) {
          staffData.add(
            StaffModel(
              staffId: data['id'],
              staffName: data['staff_name'],
            ),
          );
        });

        dropDownData = staffData.map((staffdata) {
          return MultiSelectItem(staffdata, staffdata.staffName!);
        }).toList();

        update();

      } else {
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }
}
