import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bmwms_hospital/model/staff_model.dart';
import 'package:bmwms_hospital/model/training_type.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../controller/app_data_controller.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utility/Alerts.dart';
import '../utility/ApiUrl.dart';
import 'dashboard_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {

  final AppDataController controller = Get.put(AppDataController());
  DateTime selectedDate = DateTime.now();
  List<TrainingType> training_type = [];
  List subjectData = [];
  var selected_training;
  StaffModel? s_data;
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController organise_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getSubjectData();
    training_type
        .add(new TrainingType(id: "1", training_type: "Corporate training"));
    training_type.add(
        new TrainingType(id: "2", training_type: "Waste management training"));
  }

  post_training_set() async {
    Alerts.showProgressDialog(context, "Processing, Please wait...");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var hId = sharedPreferences!.getString("hospital_id");
    try {
      var jsonMap = jsonEncode(
          {
            "staff_ids":subjectData,
            "typetrn":selected_training,
            "trngdtt":dateInput.text.toString(),
            "trngtme":timeinput.text.toString(),
            "orgg":organise_controller.text.toString(),
            "hid":hId
          }
      );
      print(jsonMap);
      final response = await http.post(Uri.parse(ApiUrl.POST_TRAINING_SESS),
          body: jsonMap);
      print("resp.." + response.body.toString());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var status = data['Stat'];
        if(status == "Success"){
          selected_training = null;
          dateInput.text = "";
          timeinput.text = "";
          organise_controller.text = "";
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        }

        Navigator.of(context).pop();

      } else {
        Navigator.of(context).pop();
        print("Error");
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff114382),
        title: Text("Training"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                  Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50),
                            Text("Staff Members",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.start),
                            SizedBox(height: 10),
                            GetBuilder<AppDataController>(
                            builder: (controller) {
                              return MultiSelectDialogField(
                                items: controller.dropDownData,
                                title: const Text(
                                  "Staff Members",
                                  style: TextStyle(color: Colors.black),
                                ),
                                selectedColor: Colors.black,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 1,
                                  ),
                                ),
                                buttonIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                                buttonText: const Text(
                                  "Select Staffs",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                                onConfirm: (results) {
                                  subjectData.clear();
                                  for (var i = 0; i < results.length; i++) {
                                    s_data = results[i] as StaffModel;
                                    print(s_data!.staffId);
                                    print(s_data!.staffName);
                                    subjectData.add(s_data!.staffId);
                                  }
                                  print("data $subjectData");
                                },
                              );
                            }),
                            SizedBox(height: 20),
                            Text("Type Of Training",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.start),
                            SizedBox(height: 10),
                            Container(
                              height: 60,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45, //
                                  ),
                                  items: training_type.map((itemone) {
                                    return DropdownMenuItem(
                                        value: itemone.id,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(itemone.training_type!),
                                        ));
                                  }).toList(),
                                  value: selected_training,
                                  onChanged: (value) {
                                    setState(() {
                                      selected_training = value;
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
                                      color: Colors.black54,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Select Date",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.start),
                            SizedBox(height: 10),
                            TextField(
                              controller: dateInput,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.calendar_today),
                                  filled: true,
                                  labelText: "Enter Date",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder()),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(pickedDate);
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(formattedDate);
                                  setState(() {
                                    dateInput.text = formattedDate;
                                  });
                                } else {}
                              },
                            ),
                            SizedBox(height: 20),
                            Text("Select Time",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.start),
                            SizedBox(height: 10),
                            TextField(
                              controller: timeinput,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.timer),
                                  filled: true,
                                  labelText: "Enter Time",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder()),
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (pickedTime != null) {
                                  print(pickedTime.format(context));
                                  DateTime parsedTime = DateFormat.jm().parse(
                                      pickedTime.format(context).toString());
                                  print(parsedTime);
                                  String formattedTime =
                                      DateFormat('HH:mm:ss').format(parsedTime);
                                  print(formattedTime);

                                  setState(() {
                                    timeinput.text = formattedTime;
                                  });
                                } else {
                                  print("Time is not selected");
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Organised by",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: TextField(
                                controller: organise_controller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder()),
                                cursorColor: Colors.blue,
                                cursorWidth: 2.0,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    post_training_set();
                                  },
                                  style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black12),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.lightGreen)),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 17),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ]
                  ),
                ),
          )
    );
  }
}
