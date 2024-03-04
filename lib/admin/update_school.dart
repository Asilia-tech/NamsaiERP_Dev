import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateSchool extends StatefulWidget {
  final String id;
  const UpdateSchool({super.key, required this.id});

  @override
  State<UpdateSchool> createState() => _UpdateSchoolState();
}

class _UpdateSchoolState extends State<UpdateSchool> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _udiseText = TextEditingController(text: '');
  final TextEditingController _clusterText = TextEditingController(text: '');
  final TextEditingController _districtText = TextEditingController(text: '');
  final TextEditingController _latText = TextEditingController(text: '');
  final TextEditingController _longText = TextEditingController(text: '');
  final TextEditingController _geoRadiusText = TextEditingController(text: '');
  final TextEditingController _mobileText = TextEditingController(text: '');
  final TextEditingController _pincodeText = TextEditingController(text: '');
  final TextEditingController _schoolAddressText =
      TextEditingController(text: '');
  final TextEditingController _schoolNameText = TextEditingController(text: '');
  final TextEditingController _schoolTypeText = TextEditingController(text: '');
  final TextEditingController _schoolTimeInText =
      TextEditingController(text: '');
  final TextEditingController _schoolTimeOutText =
      TextEditingController(text: '');
  final TextEditingController _schoolTimeTotalText =
      TextEditingController(text: '');
  final TextEditingController _totalTeacherText =
      TextEditingController(text: '');
  bool _isUploading = false;
  bool _isConnected = false;
  bool _isLoading = false;
  Map blockData = {};
  List blockList = [];
  List classList = [];
  List divisionList = [];
  Map<String, dynamic> holidaysList = {};
  Map schoolTime = {
    'regular': {'in': '', 'out': '', 'total': ''}
  }; //
  List subjectList = [];

  @override
  void initState() {
    super.initState();
    schoolInfo();
    loadBlock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'Update School'),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: _isUploading
              ? Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              Colors.grey[200], // Light grey background color
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add rounded corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Basic Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height:
                                    10), // Adjust spacing between title and row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'Enter Mobile Number',
                                    'Eg. 9876543211',
                                    textInputType: TextInputType.phone,
                                    (p0) {
                                      if (p0 == null || p0.isEmpty)
                                        return 'Please Enter mobile number';
                                      else if (Utils.validateMobile(
                                          p0.toString())) {
                                        return "Please Enter valid mobile number";
                                      }
                                    },
                                    _mobileText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    "Enter school address",
                                    "Eg. Namsai",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter school address";
                                      }
                                    },
                                    _schoolAddressText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Geographic Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'Latitude',
                                    'Eg. 19.09371',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter latitude";
                                      }
                                    },
                                    _latText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'Longitude',
                                    'Eg. 72.9164333',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter longitude";
                                      }
                                    },
                                    _longText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'Enter Geo-radius',
                                    'Eg. 120',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter geo-radius";
                                      }
                                    },
                                    _geoRadiusText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 10),
                                Expanded(
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    "Enter district",
                                    "Eg. Namsai",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter district";
                                      }
                                    },
                                    _districtText,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    "Enter pincode",
                                    "Eg. 792103",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter pincode";
                                      }
                                    },
                                    _pincodeText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'School Time',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'In-time',
                                    'Eg. 9:00 AM',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter in-time";
                                      } else {
                                        setState(() {
                                          schoolTime['regular']['in'] = p0;
                                        });
                                      }
                                    },
                                    _schoolTimeInText,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'Out-time',
                                    'Eg. 3:00 AM',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter out-time";
                                      } else {
                                        setState(() {
                                          schoolTime['regular']['out'] = p0;
                                        });
                                      }
                                    },
                                    _schoolTimeInText,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'Total hours',
                                    'Eg. 7',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "Please enter total hours";
                                      } else {
                                        setState(() {
                                          schoolTime['regular']['total'] = p0;
                                        });
                                      }
                                    },
                                    _schoolTimeTotalText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              Colors.grey[200], // Light grey background color
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add rounded corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Academic information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: UtilsWidgets.mutliSelectDropDown(
                                    [
                                      "Class 1",
                                      "Class 2",
                                      "Class 3",
                                      "Class 4",
                                      "Class 5",
                                      "Class 6",
                                      "Class 7"
                                    ],
                                    "temp",
                                    'Choose class(es)',
                                    classList,
                                    (value) {
                                      setState(() {
                                        classList
                                            .clear(); //clear list for each new form submission
                                        classList = value;
                                      });
                                    },
                                    'Choose classes',
                                    Colors.black,
                                    'Choose classes',
                                    (value) {
                                      if (value == 'Choose the classes' ||
                                          value == null ||
                                          value.toString().isEmpty) {
                                        return 'Please choose the classes';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: UtilsWidgets.mutliSelectDropDown(
                                    ["A", "B", "C", "D"],
                                    "temp",
                                    'Choose division(s)',
                                    divisionList,
                                    (value) {
                                      setState(() {
                                        divisionList
                                            .clear(); //clear list for each new form submission
                                        divisionList = value;
                                      });
                                    },
                                    'Choose division',
                                    Colors.black,
                                    'Choose division',
                                    (value) {
                                      if (value == 'Choose the division' ||
                                          value == null ||
                                          value.toString().isEmpty) {
                                        return 'Please choose the division';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: UtilsWidgets.mutliSelectDropDown(
                                    [
                                      "Maths",
                                      "English",
                                      "Science",
                                      "Hindi",
                                      "Other"
                                    ],
                                    "temp",
                                    'Choose subject(s)',
                                    subjectList,
                                    (value) {
                                      setState(() {
                                        subjectList
                                            .clear(); //clear list for each new form submission
                                        subjectList = value;
                                      });
                                    },
                                    'Choose subject',
                                    Colors.black,
                                    'Choose subject',
                                    (value) {
                                      if (value == 'Choose the subject' ||
                                          value == null ||
                                          value.toString().isEmpty) {
                                        return 'Please choose the subject';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              Colors.grey[200], // Light grey background color
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add rounded corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Other',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Row(children: [
                            //   Expanded(
                            //     child: UtilsWidgets.buildDatePicker(
                            //       'Enter holiday date',
                            //       'Eg. 2024-03-25',
                            //       _holidayDateText,
                            //       (val) {
                            //         // setState(() {
                            //         //   holidaysList[val] = "";
                            //         // });
                            //       },
                            //       firstDate: DateTime(1900),
                            //       lastDate: DateTime(2100),
                            //     ),
                            //   ),
                            //   SizedBox(width: 10),
                            //   Expanded(
                            //     child: UtilsWidgets.textFormField(
                            //       context,
                            //       "Enter holiday name",
                            //       "Eg. Holi",
                            //       (p0) {
                            //         // List keys = holidaysList.keys.toList();
                            //         if (p0 == null || p0.isEmpty) {
                            //           return "Please enter holiday name";
                            //         }
                            //         // else if (keys.isEmpty) {
                            //         //   return "Please enter date first";
                            //         // }
                            //         // else {
                            //         //   setState(() {
                            //         //     holidaysList[_holidayDateText.text] = p0;
                            //         //     print(holidaysList);
                            //         //   });
                            //         // }
                            //       },
                            //       _holidayNameText,
                            //     ),
                            //   ),
                            // ]),
                            UtilsWidgets.textFormField(
                              context,
                              "Enter total teacher licence",
                              "Eg. 10",
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter total teachers licence";
                                }
                              },
                              _totalTeacherText,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ],
                        ),
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : UtilsWidgets.buildRoundBtn("Update School",
                              () async {
                              if (_formKey.currentState!.validate()) {
                                UtilsWidgets.bottomDialogs(
                                    "Please review the information",
                                    'Alert',
                                    'Cancel',
                                    'Submit',
                                    context, () {
                                  Navigator.of(context).pop();
                                }, () {
                                  editSchool();
                                  Navigator.of(context).pop();
                                });
                              }
                            }),
                      SizedBox(height: 20),
                    ],
                  ))
              : UtilsWidgets.showProgressDialog()),
    );
  }

  Future<String> loadBlock() async {
    var data = await rootBundle.loadString("assets/json/HVX.json");
    setState(() {
      blockData = json.decode(data);
      blockData.forEach((key, value) {
        blockList.add(key);
      });
    });
    return "success";
  }

  Future schoolInfo() async {
    setState(() {
      _isUploading = false;
    });
    String uri = Constants.SCHOOL_URL + '/schooldetails';
    Map params = {
      "udise": widget.id,
    };
    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map teacherMap = jsonDecode(response.body);
          Map<String, dynamic> infoMap = teacherMap['info'];
          _udiseText.text = widget.id;
          _mobileText.text = infoMap['mobile'] ?? "";
          _clusterText.text = infoMap['cluster'] ?? "";
          _districtText.text = infoMap['district'] ?? "";
          _latText.text = infoMap['geoLocation']['lat'] ?? "";
          _longText.text = infoMap['geoLocation']['long'] ?? "";
          _geoRadiusText.text = infoMap['geoRadius'] ?? "";
          _pincodeText.text = infoMap['pincode'] ?? "";
          _schoolAddressText.text = infoMap['schoolAddress'] ?? "";
          _schoolNameText.text = infoMap['schoolName'] ?? "";
          _schoolTypeText.text = infoMap['schoolType'] ?? "";
          _totalTeacherText.text = infoMap['totalTeacher'] ?? "";
          _schoolTimeInText.text = infoMap['schoolTime']['regular']['in'] ?? "";
          _schoolTimeOutText.text =
              infoMap['schoolTime']['regular']['out'] ?? "";
          _schoolTimeTotalText.text =
              infoMap['schoolTime']['regular']['total'] ?? "";
          classList = infoMap['classList'] ?? [];
          divisionList = infoMap['divisionList'] ?? [];
          subjectList = infoMap['subjectList'] ?? [];
          holidaysList = infoMap['holidaysList'] ?? {};
          _isUploading = true;
        });
        // print(holidaysList);
        // List keys = holidaysList.keys.toList();
        // print(keys);
        // for (int j = 0; j < keys.length; j++) {
        //   rows.add(
        //     DataRow(cells: [
        //       DataCell(Text(keys[j])),
        //       DataCell(Text(holidaysList[keys[j]])),
        //       DataCell(
        //           // UtilsWidgets.buildIconBtn()
        //           Text('')),
        //     ]),
        //   );
        // }
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  // Future loadHolidays() async {
  //   setState(() {
  //     List keys = holidaysList.keys.toList();
  //     print(keys);
  //     for (int j = 0; j < keys.length; j++) {
  //       rows.add(
  //         DataRow(cells: [
  //           DataCell(Text(keys[j])),
  //           DataCell(Text(holidaysList[keys[j]])),
  //           DataCell(
  //               // UtilsWidgets.buildIconBtn()
  //               Text('')),
  //         ]),
  //       );
  //     }
  //     ;
  //   });
  // }

  Future editSchool() async {
    setState(() {
      _isLoading = true;
    });
    String uri = Constants.SCHOOL_URL + '/editschool';
    Map params = {
      'udise': _udiseText.text,
      'block': "NAMSAI",
      'classList': classList, // List
      'cluster': _clusterText.text,
      'district': _districtText.text,
      'divisionList': divisionList, // List
      'lat': _latText.text,
      'long': _longText.text,
      'geoRadius': _geoRadiusText.text,
      'holidaysList': holidaysList, // Map
      'mobile': _mobileText.text,
      'pincode': _pincodeText.text,
      'schoolAddress': _schoolAddressText.text,
      'schoolName': _schoolNameText.text,
      'schoolTime': schoolTime, // Map
      'schoolType': _schoolTypeText.text,
      'state': "Arunachal Pradesh",
      'subjectList': subjectList, // List
      'totalTeacher': _totalTeacherText.text,
    };
    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map infoMap = jsonDecode(response.body);
          UtilsWidgets.showGetDialog(context, infoMap['message'], Colors.green);
        });
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
