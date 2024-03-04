import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:get/get.dart';
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
      appBar: UtilsWidgets.buildAppBar(context, 'updateschool'.tr),
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
                              'tbasicinfo'.tr,
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
                                    "tmobiletf".tr,
                                    'Eg. 9876543211',
                                    textInputType: TextInputType.phone,
                                    (p0) {
                                      if (p0 == null || p0.isEmpty)
                                        return 'please'.tr + "tmobiletf".tr;
                                      else if (Utils.validateMobile(
                                          p0.toString())) {
                                        return "mobilevtf".tr;
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
                                    'schooladdress'.tr,
                                    "Eg. Namsai",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + 'schooladdress'.tr;
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
                              'tgeographicinfo'.tr,
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
                                    'latitude'.tr,
                                    'Eg. 19.09371',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + 'latitude'.tr;
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
                                    'longitude'.tr,
                                    'Eg. 72.9164333',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + 'longitude'.tr;
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
                                    'georadius'.tr,
                                    'Eg. 120',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + 'georadius'.tr;
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
                                    "district".tr,
                                    "Eg. Namsai",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return "please".tr + "district".tr;
                                      }
                                    },
                                    _districtText,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: UtilsWidgets.textFormField(
                                    context,
                                    'pincode'.tr,
                                    "Eg. 792103",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + 'pincode'.tr;
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
                              'tschooltime'.tr,
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
                                    'intime'.tr,
                                    'Eg. 9:00 AM',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + 'intime'.tr;
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
                                    'outtime'.tr,
                                    'Eg. 3:00 AM',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + 'outtime'.tr;
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
                                    'totalhours'.tr,
                                    'Eg. 7',
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please' + 'totalhours'.tr;
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
                              'tacademicinfo'.tr,
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
                                    'chooseclass'.tr,
                                    'chooseclass'.tr,
                                    classList,
                                    (value) {
                                      setState(() {
                                        classList
                                            .clear(); //clear list for each new form submission
                                        classList = value;
                                      });
                                    },
                                    'chooseclass'.tr,
                                    Colors.black,
                                    'chooseclass'.tr,
                                    (value) {
                                      if (value == 'chooseclass'.tr ||
                                          value == null ||
                                          value.toString().isEmpty) {
                                        return 'please'.tr + 'chooseclass'.tr;
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
                                    'choosedivision'.tr,
                                    'choosedivision'.tr,
                                    divisionList,
                                    (value) {
                                      setState(() {
                                        divisionList.clear(); //clear list for each new form submission
                                        divisionList = value;
                                      });
                                    },
                                    'choosedivision'.tr,
                                    Colors.black,
                                    'choosedivision'.tr,
                                    (value) {
                                      if (value == 'choosedivision'.tr ||
                                          value == null ||
                                          value.toString().isEmpty) {
                                        return 'please'.tr + 'choosedivision'.tr;
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
                                    'choosesubject'.tr,
                                    'choosesubject'.tr,
                                    subjectList,
                                    (value) {
                                      setState(() {
                                        subjectList
                                            .clear(); //clear list for each new form submission
                                        subjectList = value;
                                      });
                                    },
                                    'choosesubject'.tr,
                                    Colors.black,
                                    'choosesubject'.tr,
                                    (value) {
                                      if (value == 'choosesubject'.tr ||
                                          value == null ||
                                          value.toString().isEmpty) {
                                        return 'please'.tr + 'choosesubject'.tr;
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
                              'genderother'.tr,
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
                              'totalteacherlicense'.tr,
                              "Eg. 10",
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'please'.tr + 'totalteacherlicense'.tr;
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
                          : UtilsWidgets.buildRoundBtn("updateschool".tr,
                              () async {
                              if (_formKey.currentState!.validate()) {
                                UtilsWidgets.bottomDialogs(
                                    'addalert'.tr, 
                                    'alert'.tr,
                                    'cancel'.tr, 
                                    'submit'.tr,
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
