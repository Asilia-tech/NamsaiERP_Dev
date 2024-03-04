import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/custom_datatable.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthlyLeaveScreen extends StatefulWidget {
  const MonthlyLeaveScreen({Key? key}) : super(key: key);

  @override
  _MonthlyLeaveScreenState createState() => _MonthlyLeaveScreenState();
}

class _MonthlyLeaveScreenState extends State<MonthlyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateText =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _endDateText = TextEditingController();
  bool _isLoading = false;
  bool isFind = false;
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  // List<dynamic> finalMap = [];
  List<String> attendDate = [];
  List<String> attendInTime = [];
  List<String> attendOutTime = [];
  List<String> attendTotalTime = [];
  List<String> teacherId = [];
  List<String> userName = [];
  String msg = 'teacherreportwarning'.tr;
  Uint8List webImage = Uint8List(8);
  List<dynamic> blockList = [];
  String blockName = "";
  List<dynamic> clusterList = [];
  String clusterName = "";
  List<dynamic> schoolList = [];
  String schoolName = "";
  List<dynamic> schoolId = [];
  String udise = "";
  Map<String, dynamic> blockData = {};
  DataTableSource _data = TeacherLeave([]);
  List<String> leave = [];
  List<String> startDate = [];
  List<String> endDate = [];
  List<String> reason = [];
  List<String> totalLeave = [];
  int count = 0;

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
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Column(
                    //   children: [
                    //     userLevel == 'district'
                    //         ? UtilsWidgets.searchAbleDropDown(
                    //             context,
                    //             blockList,
                    //             blockName,
                    //             'Choose block',
                    //             blockName,
                    //             const Icon(Icons.search),
                    //             (value) {
                    //               if (value != null) {
                    //                 setState(() {
                    //                   blockName = value;
                    //                   clusterList.clear();
                    //                   Map tempMap = {};
                    //                   tempMap = blockData[blockName];
                    //                   tempMap.forEach((clust, value) {
                    //                     clusterList.add(clust);
                    //                   });
                    //                 });
                    //               }
                    //             },
                    //             'Choose block',
                    //             Colors.black,
                    //             'Choose block',
                    //             (value) {
                    //               if (value == 'Choose block' ||
                    //                   value == null ||
                    //                   value.toString().isEmpty) {
                    //                 return 'Please Choose block';
                    //               }
                    //               return null;
                    //             })
                    //         : Container(),
                    //     userLevel == 'block' || userLevel == 'district'
                    //         ? UtilsWidgets.searchAbleDropDown(
                    //             context,
                    //             clusterList,
                    //             clusterName,
                    //             'Choose cluster',
                    //             clusterName,
                    //             const Icon(Icons.search),
                    //             (value) {
                    //               if (value != null) {
                    //                 setState(() {
                    //                   clusterName = value;
                    //                   schoolList.clear();
                    //                   schoolList.clear();
                    //                   Map tempMap = {};
                    //                   tempMap =
                    //                       blockData[blockName][clusterName];
                    //                   tempMap.forEach((id, name) {
                    //                     schoolList.add(name);
                    //                     schoolId.add(id);
                    //                   });
                    //                 });
                    //               }
                    //             },
                    //             'Choose cluster',
                    //             Colors.black,
                    //             'Choose cluster',
                    //             (value) {
                    //               if (value == 'Choose cluster' ||
                    //                   value == null ||
                    //                   value.toString().isEmpty) {
                    //                 return 'Please Choose cluster';
                    //               }
                    //               return null;
                    //             })
                    //         : Container(),
                    //     UtilsWidgets.searchAbleDropDown(
                    //         context,
                    //         schoolList,
                    //         schoolName,
                    //         'Choose school',
                    //         schoolName,
                    //         const Icon(Icons.search),
                    //         (value) {
                    //           if (value != null) {
                    //             setState(() {
                    //               schoolName = value;
                    //               udise =
                    //                   schoolId[schoolList.indexOf(schoolName)];
                    //             });
                    //           }
                    //         },
                    //         'Choose school',
                    //         Colors.black,
                    //         'Choose school',
                    //         (value) {
                    //           if (value == 'Choose school' ||
                    //               value == null ||
                    //               value.toString().isEmpty) {
                    //             return 'Please Choose school';
                    //           }
                    //           return null;
                    //         }),
                    //   ],
                    // ),

                    UtilsWidgets.buildDatePicker(
                      'choosestartdate'.tr,
                      'choosestartdate'.tr,
                      _startDateText,
                      (val) {
                        setState(() {
                          _endDateText.text = _startDateText.text;
                        });
                      },
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                    ),
                    UtilsWidgets.buildDatePicker(
                      'chooseenddate'.tr,
                      'chooseenddate'.tr, 
                      _endDateText, 
                      (val) {},
                      firstDate: DateTime.parse(_startDateText.text).subtract(Duration(days: 0)),
                      lastDate: DateTime(DateTime.parse(_startDateText.text).year + 1)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : UtilsWidgets.buildSqureBtn(
                                'search'.tr,
                                () {
                                  if (_formKey.currentState!.validate()) {
                                    getLeaveInfo();
                                  }
                                },
                                Colors.white,
                                Constants.primaryColor,
                              ),
                        SizedBox(width: 10),
                        isFind
                            ? UtilsWidgets.buildSqureBtn(
                                'download'.tr,
                                () async {
                                  reportGenerate();
                                },
                                Constants.primaryColor,
                                Colors.white,
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              isFind
                  ? Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: PaginatedDataTable(
                        source: _data,
                        header: Text(
                          "Teacher Leave ${Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd') + ' to ' + Utils.formatDate(DateTime.parse(_endDateText.text), 'yyyy-MM-dd')}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        horizontalMargin: 10,
                        columnSpacing: 10,
                        arrowHeadColor: Colors.black,
                        columns: [
                          DataColumn(label: Text('teachername'.tr)),
                          DataColumn(label: Text('leavetype'.tr)),
                          DataColumn(label: Text('startdate'.tr)),
                          DataColumn(label: Text('enddate'.tr)),
                          DataColumn(label: Text('totalleave'.tr)),
                        ],
                        rowsPerPage: 10,
                      ),
                    )
                  : Container(),
              SizedBox(height: 10)
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
    });
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
    // getTeacherList();
  }

  // Future getTeacherList() async {
  //   try {
  //     String uri = Constants.TEACHER_URL + '/teacherlist';
  //     Map params = {"level": userLevel, "id": userID};
  //     var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         Map<String, dynamic> tempMap = jsonDecode(response.body);
  //         finalMap = tempMap['info'];
  //       });
  //     } else {
  //       UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // UtilsWidgets.showToastFunc(e.toString());
  //   }
  // }

  Future getLeaveInfo() async {
    setState(() {
      userName.clear();
      leave.clear();
      startDate.clear();
      endDate.clear();
      reason.clear();
      totalLeave.clear();
      count = 0;
      isFind = false;
    });
    try {
      String sDate =
          Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd');
      String eDate =
          Utils.formatDate(DateTime.parse(_endDateText.text), 'yyyy-MM-dd');
      String uri = Constants.LEAVE_URL + '/leavereport';
      Map params = {
        "startDate": sDate,
        "endDate": eDate,
        "level": userLevel,
        "id": userID
      };
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        if (tempMap['isValid']) {
          setState(() {
            List<Map<String, dynamic>> tempData = [];
            List tempList = [];
            tempList = tempMap['info'];
            if (tempList.isNotEmpty) {
              tempList.forEach((element) {
                Map<String, dynamic> abc = {};
                Map<String, dynamic> infoMap = element;
                Map<String, dynamic> validMap = infoMap["leaveData"];
                validMap['dayList'] = infoMap['dayList'];
                if (validMap['dayList'].length == 1 ||
                    startDate.isEmpty ||
                    validMap["startDate"] != startDate.last) {
                  // finalMap.forEach((element) {
                  //   Map tempMap = element;
                  //   if (tempMap['userId'] == infoMap["userId"]) {
                  //     userName.add(tempMap['teacherName']);
                  //     abc['name'] = tempMap['teacherName'];
                  //   }
                  // });
                  // finalMap
                  //     .where(
                  //         (element) => element['userId'] == infoMap["userId"])
                  //     .map((element) => element['teacherName'])
                  //     .forEach((teacherName) {
                  //   userName.add(teacherName);
                  //   abc['name'] = tempMap['teacherName'];
                  // });
                  userName.add(infoMap["teacherName"] ?? '');
                  leave.add(validMap["leaveType"] ?? '');
                  reason.add(validMap["applyReason"] ?? '');
                  startDate.add(validMap["startDate"] ?? '');
                  endDate.add(validMap["endDate"] ?? '');
                  totalLeave.add(validMap["totalLeave"] ?? '');
                  count++;
                  abc['name'] = infoMap["teacherName"];
                  abc['leaveType'] = validMap['leaveType'];
                  abc['startDate'] = validMap['startDate'];
                  abc['endDate'] = validMap['endDate'];
                  abc['totalLeave'] = validMap['totalLeave'];
                  tempData.add(abc);
                }
              });
              _data = TeacherLeave(tempData);
              isFind = true;
            } else {
              msg = 'No History Found!!';
              isFind = false;
            }
          });
        } else {
          setState(() {
            msg = tempMap['message'];
            isFind = false;
          });
        }
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future<void> reportGenerate() async {
    List<List<String>> userData = [
      ["Name", "Leave Type", "Start Date", "End Date", "Total Leave"]
    ];

    for (var index = 0; index < startDate.length; index++) {
      List<String> abc = [];
      abc.add(userName[index]);
      abc.add(leave[index]);
      abc.add(startDate[index]);
      abc.add(endDate[index]);
      abc.add(totalLeave[index]);
      userData.add(abc);
    }
    Utils.downloadCSV(userData, 'leave.csv');
  }
}
