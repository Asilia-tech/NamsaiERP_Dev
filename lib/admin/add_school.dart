import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
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
      appBar: UtilsWidgets.buildAppBar(context, 'Add School'),
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
                      const Text(
                        'Basic Information',
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
                              'Enter Mobile Number',
                              'Eg. 9876543211',
                              textInputType: TextInputType.phone,
                              (p0) {
                                if (p0 == null || p0.isEmpty)
                                  return 'Please Enter mobile number';
                                else if (Utils.validateMobile(p0.toString())) {
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
                            flex: 1,
                            child: UtilsWidgets.textFormField(
                              context,
                              "Enter school type",
                              "Eg. GUPS",
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter school type";
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
                                  'Choose block',
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
                                  'Choose block',
                                  Colors.black,
                                  'Choose block',
                                  (value) {
                                    if (value == 'Choose block' ||
                                        value == null ||
                                        value.toString().isEmpty) {
                                      return 'Please Choose block';
                                    }
                                    return null;
                                  })
                              : Container(),
                          userLevel == 'district' || userLevel == 'block'
                              ? UtilsWidgets.searchAbleDropDown(
                                  context,
                                  clusterList,
                                  clusterName,
                                  'Choose cluster',
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
                                  'Choose cluster',
                                  Colors.black,
                                  'Choose cluster',
                                  (value) {
                                    if (value == 'Choose cluster' ||
                                        value == null ||
                                        value.toString().isEmpty) {
                                      return 'Please Choose cluster';
                                    }
                                    return null;
                                  })
                              : Container(),
                          UtilsWidgets.searchAbleDropDown(
                              context,
                              schoolList,
                              schoolName,
                              'Choose school',
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
                              'Choose school',
                              Colors.black,
                              'Choose school',
                              (value) {
                                if (value == 'Choose school' ||
                                    value == null ||
                                    value.toString().isEmpty) {
                                  return 'Please Choose school';
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
                              inputFormatter: Utils.onlyFloatNumber(),
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
                              inputFormatter: Utils.onlyFloatNumber(),
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
                              null,
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
                              null,
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
                      const Text(
                        'Academic information',
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
                              "temp",
                              'Choose class(es)',
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
                              divisionList,
                              "Choose division(s)",
                              'Choose division(s)',
                              selectedDivisionList,
                              (value) {
                                setState(() {
                                  selectedDivisionList.clear();
                                  selectedDivisionList = value;
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
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: UtilsWidgets.mutliSelectDropDown(
                              subjectList,
                              "Choose subject(s)",
                              'Choose subject(s)',
                              selectedSubjectList,
                              (value) {
                                setState(() {
                                  selectedSubjectList.clear();
                                  selectedSubjectList = value;
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
                      const Text(
                        'Other',
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
                              "Enter total teachers licence required",
                              "Eg. 10",
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter total teachers licence required";
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
                              "Enter total holiday",
                              "Eg. 10",
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter total holiday";
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
                                'Add', Icon(Icons.add_box), () {
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
                                                "Enter date",
                                                "Enter date",
                                                holidayDate[index],
                                                (val) {},
                                                firstDate: DateTime(2022),
                                                lastDate: DateTime(2101),
                                                date: DateTimePickerType.date,
                                                dateMask: "yyyy-MM-dd")),
                                        SizedBox(
                                            width: 250,
                                            child: UtilsWidgets.textFormField(
                                              context,
                                              "Enter Holiday Name",
                                              "Enter Holiday Name",
                                              (p0) {
                                                if (p0 == null || p0.isEmpty) {
                                                  return "Please Enter Holiday Name";
                                                }
                                              },
                                              holidayName[index],
                                            )),
                                      ],
                                    ),
                                  ],
                                );
                              })
                          : const Center(
                              child: Text(
                                'Please Choose Total Holiday',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : UtilsWidgets.buildRoundBtn("Add School", () async {
                        if (_formKey.currentState!.validate()) {
                          UtilsWidgets.bottomDialogs(
                              "Please review the information",
                              'Alert',
                              'Cancel',
                              'Submit',
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
