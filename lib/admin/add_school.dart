import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSchool extends StatefulWidget {
  const AddSchool({super.key});

  @override
  State<AddSchool> createState() => _AddSchoolState();
}

class _AddSchoolState extends State<AddSchool> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _latText = TextEditingController(text: '');
  final TextEditingController _longText = TextEditingController(text: '');
  final TextEditingController _geoRadiusText = TextEditingController(text: '');
  final TextEditingController _mobileText = TextEditingController(text: '');
  final TextEditingController _pincodeText = TextEditingController(text: '');
  final TextEditingController _holidayNumberText =
      TextEditingController(text: '');
  final TextEditingController _schoolAddressText =
      TextEditingController(text: '');
  final TextEditingController _schoolTypeText = TextEditingController(text: '');
  final TextEditingController _totalTeacherText =
      TextEditingController(text: '');
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  String udise = "";
  String district = '';
  bool _isLoading = false;
  Map programData = {};
  List blockList = [];
  List classList = [];
  List divisionList = [];
  List selectedClassList = [];
  List selectedDivisionList = [];
  List subjectList = [
    "Maths",
    "English",
    "Science",
    "Hindi",
    "Social Science",
    "Other"
  ];
  List selectedSubjectList = [];
  Map schoolTime = {
    'regular': {'in': '', 'out': '', 'total': ''}
  };
  String blockName = "";
  List<dynamic> clusterList = [];
  String clusterName = "";
  List<dynamic> schoolList = [];
  List<dynamic> schoolId = [];
  String schoolName = "";
  Map<String, dynamic> blockData = {};
  Map holidaysList = {};
  List<TextEditingController> holidayName = [];
  List<TextEditingController> holidayDate = [];
  int count = 0;
  bool isAdd = false;

  @override
  void initState() {
    loadBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'schooladd'.tr),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
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
                        'tbasicinfo'.tr,
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
                              "tmobiletf".tr,
                              'Eg. 9876543211',
                              textInputType: TextInputType.phone,
                              (p0) {
                                if (p0 == null || p0.isEmpty)
                                  return 'please'.tr + "tmobiletf".tr;
                                else if (Utils.validateMobile(p0.toString())) {
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
                            flex: 1,
                            child: UtilsWidgets.textFormField(
                              context,
                              'tschooltype'.tr,
                              "Eg. GUPS",
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'please'.tr + 'tschooltype'.tr;
                                }
                              },
                              _schoolTypeText,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          userLevel == 'district'
                              ? UtilsWidgets.searchAbleDropDown(
                                  context,
                                  blockList,
                                  blockName,
                                  'chooseblock'.tr,
                                  blockName,
                                  const Icon(Icons.search),
                                  (value) {
                                    if (value != null) {
                                      setState(() {
                                        blockName = value;
                                        clusterList.clear();
                                        Map tempMap = {};
                                        tempMap = blockData[blockName];
                                        tempMap.forEach((clust, value) {
                                          clusterList.add(clust);
                                        });
                                      });
                                    }
                                  },
                                  'chooseblock'.tr,
                                  Colors.black,
                                  'chooseblock'.tr,
                                  (value) {
                                    if (value == 'chooseblock'.tr ||
                                        value == null ||
                                        value.toString().isEmpty) {
                                      return 'please'.tr + 'chooseblock'.tr;
                                    }
                                    return null;
                                  })
                              : Container(),
                          userLevel == 'district' || userLevel == 'block'
                              ? UtilsWidgets.searchAbleDropDown(
                                  context,
                                  clusterList,
                                  clusterName,
                                  'choosecluster'.tr,
                                  clusterName,
                                  const Icon(Icons.search),
                                  (value) {
                                    if (value != null) {
                                      setState(() {
                                        clusterName = value;
                                        schoolList.clear();
                                        schoolList.clear();
                                        Map tempMap = {};
                                        tempMap =
                                            blockData[blockName][clusterName];
                                        tempMap.forEach((id, name) {
                                          schoolList.add(name);
                                          schoolId.add(id);
                                        });
                                      });
                                    }
                                  },
                                  'choosecluster'.tr,
                                  Colors.black,
                                  'choosecluster'.tr,
                                  (value) {
                                    if (value == 'choosecluster'.tr ||
                                        value == null ||
                                        value.toString().isEmpty) {
                                      return 'please'.tr + 'choosecluster'.tr;
                                    }
                                    return null;
                                  })
                              : Container(),
                          UtilsWidgets.searchAbleDropDown(
                              context,
                              schoolList,
                              schoolName,
                              'chooseschool'.tr,
                              schoolName,
                              const Icon(Icons.search),
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    schoolName = value;
                                    udise = schoolId[
                                        schoolList.indexOf(schoolName)];
                                  });
                                }
                              },
                              'chooseschool'.tr,
                              Colors.black,
                              'chooseschool'.tr,
                              (value) {
                                if (value == 'chooseschool'.tr ||
                                    value == null ||
                                    value.toString().isEmpty) {
                                  return 'please'.tr + 'chooseschool'.tr;
                                }
                                return null;
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(10),
                //   margin: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: Colors.grey[200],
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: ),
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
                              inputFormatter: Utils.onlyFloatNumber(),
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
                              inputFormatter: Utils.onlyFloatNumber(),
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
                              null,
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
                              null,
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
                              null,
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
                      borderRadius: BorderRadius.circular(8)),
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: UtilsWidgets.mutliSelectDropDown(
                              classList,
                              'chooseclass'.tr,
                              'chooseclass'.tr,
                              selectedClassList,
                              (value) {
                                setState(() {
                                  selectedClassList.clear();
                                  selectedClassList = value;
                                  // selectedDivisionList = List.generate(
                                  //     selectedClassList.length, (index) => []);
                                  // selectedSubjectList = List.generate(
                                  //     selectedClassList.length, (index) => []);
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
                              divisionList,
                              'choosedivision'.tr,
                              'choosedivision'.tr,
                              selectedDivisionList,
                              (value) {
                                setState(() {
                                  selectedDivisionList.clear();
                                  selectedDivisionList = value;
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
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: UtilsWidgets.mutliSelectDropDown(
                              subjectList,
                              'choosesubject'.tr,
                              'choosesubject'.tr,
                              selectedSubjectList,
                              (value) {
                                setState(() {
                                  selectedSubjectList.clear();
                                  selectedSubjectList = value;
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
                      // Column(
                      //     children: selectedClassList.map((e) {
                      //   return Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.all(10.0),
                      //         child: Text(
                      //           e,
                      //           style: const TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(width: 10),
                      //       Expanded(
                      //         flex: 1,
                      //         child: UtilsWidgets.mutliSelectDropDown(
                      //           divisionList,
                      //           "Choose division(s)",
                      //           'Choose division(s)',
                      //           selectedDivisionList[
                      //               selectedClassList.indexOf(e)],
                      //           (value) {
                      //             setState(() {
                      //               selectedDivisionList[
                      //                   selectedClassList.indexOf(e)] = value;
                      //             });
                      //           },
                      //           'Choose division',
                      //           Colors.black,
                      //           'Choose division',
                      //           (value) {
                      //             if (value == 'Choose the division' ||
                      //                 value == null ||
                      //                 value.toString().isEmpty) {
                      //               return 'Please choose the division';
                      //             }
                      //             return null;
                      //           },
                      //         ),
                      //       ),
                      //       const SizedBox(width: 10),
                      //       Expanded(
                      //         flex: 2,
                      //         child: UtilsWidgets.mutliSelectDropDown(
                      //           subjectList,
                      //           "Choose subject(s)",
                      //           'Choose subject(s)',
                      //           selectedSubjectList[
                      //               selectedClassList.indexOf(e)],
                      //           (value) {
                      //             setState(() {
                      //               selectedSubjectList[
                      //                   selectedClassList.indexOf(e)] = value;
                      //             });
                      //           },
                      //           'Choose subject',
                      //           Colors.black,
                      //           'Choose subject',
                      //           (value) {
                      //             if (value == 'Choose the subject' ||
                      //                 value == null ||
                      //                 value.toString().isEmpty) {
                      //               return 'Please choose the subject';
                      //             }
                      //             return null;
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   );
                      // }).toList()),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Light grey background color
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: UtilsWidgets.textFormField(
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
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: UtilsWidgets.textFormField(
                              context,
                              'enterholidays'.tr,
                              "Eg. 10",
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'please'.tr + 'enterholidays'.tr;
                                }
                              },
                              _holidayNumberText,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: UtilsWidgets.buildIconBtn(
                                'add'.tr, Icon(Icons.add_box), () {
                              setState(() {
                                isAdd = false;
                                count = int.parse(_holidayNumberText.text);
                                holidayName = List.generate(
                                    count, (index) => TextEditingController());
                                holidayDate = List.generate(
                                    count, (index) => TextEditingController());
                                isAdd = true;
                              });
                            }, Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      isAdd
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: count,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 250,
                                            child: UtilsWidgets.buildDatePicker(
                                                'choosedate'.tr,
                                                'choosedate'.tr,
                                                holidayDate[index],
                                                (val) {},
                                                firstDate: DateTime(2022),
                                                lastDate: DateTime(2101),
                                                date: DateTimePickerType.date,
                                                dateMask: "yyyy-MM-dd")
                                            ),
                                        SizedBox(
                                            width: 250,
                                            child: UtilsWidgets.textFormField(
                                              context,
                                              'holidayname'.tr,
                                              'holidayname'.tr,
                                              (p0) {
                                                if (p0 == null || p0.isEmpty) {
                                                  return 'please'.tr + 'holidayname'.tr;
                                                }
                                              },
                                              holidayName[index],
                                            )),
                                      ],
                                    ),
                                  ],
                                );
                              })
                          : Center(
                              child: Text(
                                'ttotalholiday'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : UtilsWidgets.buildRoundBtn('schooladd'.tr, () async {
                        if (_formKey.currentState!.validate()) {
                          UtilsWidgets.bottomDialogs(
                              'addalert'.tr, 
                              'alert'.tr,
                              'cancel'.tr, 
                              'submit'.tr,
                              context, () {
                            Navigator.of(context).pop();
                          }, () {
                            addSchool();
                            Navigator.of(context).pop();
                          });
                        }
                      }),
                SizedBox(height: 20),
              ],
            )),
      ),
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
    getOfflineData();
    return "success";
  }

  getOfflineData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userLevel = pref.getString('level') ?? '';
      userID = pref.getString('id') ?? '';
      userNumber = pref.getString('number') ?? '';
      district = pref.getString('district') ?? '';
      classList = List.generate(12, (index) => 'Class ${index + 1}');
      divisionList = List.generate(
          26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

      if (userLevel == 'block') {
        blockName = userID;
        clusterList.clear();
        Map tempMap = {};
        tempMap = blockData[blockName];
        tempMap.forEach((clust, value) {
          clusterList.add(clust);
        });
      } else if (userLevel == 'cluster') {
        blockName = pref.getString('block') ?? '';
        clusterName = userID;
        schoolList.clear();
        schoolList.clear();
        Map tempMap = {};
        tempMap = blockData[blockName][clusterName];
        tempMap.forEach((id, name) {
          schoolList.add(name);
          schoolId.add(id);
        });
      } else {}
    });
  }

  Future addSchool() async {
    setState(() {
      _isLoading = true;
      for (var i = 0; i < count; i++) {
        holidaysList[holidayDate[i].text] = holidayName[i].text;
      }
    });
    String uri = Constants.SCHOOL_URL + '/addschool';
    Map params = {
      'udise': udise,
      "district": userLevel == 'district' ? userID : district,
      "block": userLevel == 'block' ? userID : blockName,
      "cluster": userLevel == 'cluster' ? userID : clusterName,
      'classList': selectedClassList,
      'divisionList': selectedDivisionList,
      'subjectList': selectedSubjectList,
      'lat': _latText.text,
      'long': _longText.text,
      'geoRadius': _geoRadiusText.text,
      'holidaysList': holidaysList,
      'mobile': _mobileText.text,
      'pincode': _pincodeText.text,
      'schoolAddress': _schoolAddressText.text,
      'schoolName': schoolName,
      'schoolTime': schoolTime,
      'schoolType': _schoolTypeText.text,
      'state': "Arunachal Pradesh",
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
