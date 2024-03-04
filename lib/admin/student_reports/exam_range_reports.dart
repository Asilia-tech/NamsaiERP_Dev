import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthlyExamReportScreen extends StatefulWidget {
  const MonthlyExamReportScreen({Key? key}) : super(key: key);

  @override
  _MonthlyExamReportScreenState createState() =>
      _MonthlyExamReportScreenState();
}

class _MonthlyExamReportScreenState extends State<MonthlyExamReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String msg = 'enterdetails'.tr;
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  List<dynamic> studentData = [];
  List classList = [];
  String className = "";
  List divisionList = [];
  String divisionName = "";
  List examList = ['SEMESTER-1', 'SEMESTER-2'];
  String examName = "";
  List examYearList = [
    '2021-2022',
    '2022-2023',
    '2023-2024',
    '2024-2025',
    '2025-2026',
    '2026-2027'
  ];
  String examYearName = "";
  bool _isConnected = false;
  bool _isLoading = false;
  bool _isFind = false;
  List<String> headers = [];
  // List<String> reportHeaders = [];
  // List<dynamic> reportData = [];
  String udise = "";

  List<dynamic> blockList = [];
  String blockName = "";
  List<dynamic> clusterList = [];
  String clusterName = "";
  List<dynamic> schoolList = [];
  List<dynamic> schoolId = [];
  String schoolName = "";
  Map<String, dynamic> blockData = {};

  @override
  void initState() {
    loadBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                        userLevel == 'block' || userLevel == 'district'
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
                                  udise =
                                      schoolId[schoolList.indexOf(schoolName)];
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
                                return 'Please'.tr + 'chooseschool'.tr;
                              }
                              return null;
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.48,
                          child: UtilsWidgets.dropDownButton(
                            context,
                            'class'.tr,
                            'class'.tr,
                            className,
                            classList,
                            (p0) => setState(() {
                              className = p0;
                            }),
                            validator: (p0) {
                              if (className == '') {
                                return 'class'.tr;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: UtilsWidgets.dropDownButton(
                            context,
                            'division'.tr,
                            'division'.tr,
                            divisionName,
                            divisionList,
                            (p0) => setState(() {
                              divisionName = p0;
                            }),
                            validator: (p0) {
                              if (divisionName == '') {
                                return 'division'.tr;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.48,
                          child: UtilsWidgets.dropDownButton(
                            context,
                            'chooseexamname'.tr,
                            'chooseexamname'.tr,
                            examName,
                            examList,
                            (value) {
                              setState(() {
                                examName = value;
                              });
                            },
                            validator: (p0) {
                              if (divisionName == '') {
                                return 'chooseexamname'.tr;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: UtilsWidgets.dropDownButton(
                            context,
                            'chooseexamyear'.tr,
                            'chooseexamyear'.tr,
                            examYearName,
                            examYearList,
                            (value) {
                              setState(() {
                                examYearName = value;
                              });
                            },
                            validator: (p0) {
                              if (divisionName == '') {
                                return 'chooseexamyear'.tr;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : UtilsWidgets.buildSqureBtn(
                                'search'.tr,
                                () {
                                  if (_formKey.currentState!.validate()) {
                                    // getHistory();
                                    getReport();
                                  }
                                },
                                Colors.white,
                                Constants.primaryColor,
                              ),
                        SizedBox(width: 10),
                        _isFind
                            ? UtilsWidgets.buildSqureBtn(
                                'download'.tr,
                                () async {
                                  reportGenerate();
                                },
                                Constants.primaryColor,
                                Colors.white,
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(height: 10),
                    _isFind
                        ? UtilsWidgets.drawTable(
                            List.generate(headers.length, (index) {
                              return DataColumn(label: Text(headers[index]));
                            }),
                            studentData
                                .map((e) => DataRow(
                                      cells: List.generate(headers.length,
                                          (index) {
                                        return DataCell(
                                          Text(
                                            e[headers[index]],
                                            style: TextStyle(),
                                          ),
                                        );
                                      }),
                                    ))
                                .toList(),
                          )
                        : Center(child: UtilsWidgets.msgDecor(context, msg)),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  // Future getHistory() async {
  //   setState(() {
  //     _isFind = false;
  //     headers.clear();
  //     studentData.clear();
  //   });
  //   try {
  //     String uri = Constants.REPORT_URL + '/studentexamreportlist';
  //     Map params = {
  //       "level": userLevel,
  //       "id": userID,
  //       "examType": examName,
  //       "academicYear": examYearName,
  //       "sClass": className,
  //       "division": divisionName,
  //     };
  //     var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> tempMap = jsonDecode(response.body);
  //       if (tempMap['isValid']) {
  //         setState(() {
  //           studentData = tempMap['info'];
  //           if (studentData.isNotEmpty) {
  //             Map<String, dynamic> tempData = studentData[0];
  //             tempData.forEach((key, value) {
  //               headers.add(key);
  //             });
  //             _isFind = true;
  //           } else {
  //             msg = 'No History Found!!';
  //             _isFind = false;
  //           }
  //         });
  //       } else {
  //         setState(() {
  //           msg = tempMap['message'];
  //           _isFind = false;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     UtilsWidgets.showToastFunc(e.toString());
  //   }
  // }

  Future getReport() async {
    setState(() {
      _isFind = false;
      studentData.clear();
      headers.clear();
    });
    try {
      String uri = Constants.REPORT_URL + '/studentexamreportdownload';
      Map params = {
        "level": "udise",
        "id": udise,
        "examType": examName,
        "academicYear": examYearName,
        "sClass": className,
        "division": divisionName,
      };
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        if (tempMap['isValid']) {
          setState(() {
            studentData = tempMap['info'];
            if (studentData.isNotEmpty) {
              Map<String, dynamic> tempData = studentData[0];
              tempData.forEach((key, value) {
                headers.add(key);
              });
              _isFind = true;
            } else {
              setState(() {
                msg = tempMap['message'];
                _isFind = false;
              });
            }
          });
        } else {
          msg = tempMap['message'];
          _isFind = false;
        }
      } else {
        msg = 'Something missing!!';
        _isFind = false;
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future<void> reportGenerate() async {
    List<List<String>> userData = [];
    userData.add(headers);
    studentData.forEach((element) {
      Map<String, dynamic> tempData = element;
      List<String> abc = [];
      tempData.forEach((key, value) {
        abc.add(value);
      });
      userData.add(abc);
    });
    Utils.downloadCSV(userData, 'exam.csv');
  }
}
