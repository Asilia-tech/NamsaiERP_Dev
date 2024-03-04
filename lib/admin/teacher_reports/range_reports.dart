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

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({Key? key}) : super(key: key);

  @override
  _MonthlyReportScreenState createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateText =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _endDateText = TextEditingController();
  bool _isLoading = false;
  bool isFind = false;
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  List<dynamic> finalMap = [];
  List<String> attendDate = [];
  List<String> attendInTime = [];
  List<String> attendOutTime = [];
  List<String> attendTotalTime = [];
  List<String> teacherId = [];
  List<String> teacherName = [];
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
  DataTableSource _data = TeacherAttendance([]);

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
                                    getHistory();
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
                          "Teacher Attendance ${Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd') + ' to ' + Utils.formatDate(DateTime.parse(_endDateText.text), 'yyyy-MM-dd')}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        horizontalMargin: 10,
                        columnSpacing: 15,
                        arrowHeadColor: Colors.black,
                        columns: [
                          DataColumn(label: Text('teachername'.tr)),
                          DataColumn(label: Text('date'.tr)),
                          DataColumn(label: Text('In'.tr)),
                          DataColumn(label: Text('Out'.tr)),
                          DataColumn(label: Text('totaltime'.tr)),
                        ],
                        rowsPerPage: 10,
                      ),
                    )
                  : Center(child: UtilsWidgets.msgDecor(context, msg)),
              // isFind
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           Text('Name',
              //               style: TextStyle(
              //                   color: Colors.black,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold)),
              //           Text('In/Out Time',
              //               style: TextStyle(
              //                   color: Colors.black,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold)),
              //           Text('Total Time',
              //               style: TextStyle(
              //                   color: Colors.black,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold)),
              //         ],
              //       )
              //     : SizedBox(),
              // const Divider(
              //     thickness: 3, indent: 10, endIndent: 10, color: Colors.black),
              // isFind
              //     ? ListView.builder(
              //         itemCount: attendInTime.length,
              //         shrinkWrap: true,
              //         itemBuilder: (BuildContext context, int index) {
              //           return Column(
              //             children: [
              //               ListTile(
              //                 title: Center(
              //                   child: Column(
              //                     children: [
              //                       Row(
              //                         children: [
              //                           Text(
              //                             attendInTime[index],
              //                             style: TextStyle(
              //                                 color: Colors.black,
              //                                 fontSize: 14),
              //                           ),
              //                           Icon(Icons.arrow_forward),
              //                           IconButton(
              //                               onPressed: () async {
              //                                 String tt = Utils
              //                                     .replaceSpaceWithUnderscore(
              //                                         attendOutTime[index]);
              //                                 webImage = await MethodUtils
              //                                     .getSelfie('/' +
              //                                         '${udise + '/attendance/' + teacherId[index] + '/' + '${attendDate[index]}' + '/' + tt + '.png'}');
              //                                 UtilsWidgets.zoomDialog(
              //                                     context, webImage);
              //                               },
              //                               icon: Icon(
              //                                 Icons.inbox,
              //                                 color: Colors.red,
              //                               )),
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Text(
              //                             attendOutTime[index],
              //                             style: TextStyle(
              //                                 color: Colors.black,
              //                                 fontSize: 14),
              //                           ),
              //                           Icon(Icons.arrow_forward),
              //                           IconButton(
              //                               onPressed: () async {
              //                                 String tt = Utils
              //                                     .replaceSpaceWithUnderscore(
              //                                         attendOutTime[index]);
              //                                 webImage = await MethodUtils
              //                                     .getSelfie('/' +
              //                                         '${udise + '/attendance/' + teacherId[index] + '/' + '${attendDate[index]}' + '/' + tt + '.png'}');
              //                                 UtilsWidgets.zoomDialog(
              //                                     context, webImage);
              //                               },
              //                               icon: Icon(Icons.inbox,
              //                                   color: Colors.blue))
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 trailing: Column(
              //                   children: [
              //                     Text(
              //                       attendTotalTime[index] + " Hours",
              //                       style: TextStyle(
              //                           color: Colors.black, fontSize: 14),
              //                     ),
              //                     Text(
              //                       attendDate[index],
              //                       style: TextStyle(
              //                           color: Colors.black, fontSize: 14),
              //                     ),
              //                   ],
              //                 ),
              //                 leading: Column(
              //                   children: [
              //                     Text(
              //                       teacherName[index],
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         color: Colors.black,
              //                       ),
              //                     ),
              //                     Text(
              //                       teacherId[index],
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         color: Colors.black,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               const Divider(
              //                 color: Colors.grey,
              //                 thickness: 2,
              //                 endIndent: 20,
              //                 indent: 20,
              //               ),
              //             ],
              //           );
              //         })
              //     : Center(child: UtilsWidgets.msgDecor(context, msg)),
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
    await getTeacherList();
  }

  Future getTeacherList() async {
    setState(() {
      finalMap.clear();
    });
    try {
      String uri = Constants.TEACHER_URL + '/teacherlist';
      Map params = {"level": userLevel, "id": userID};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> tempMap = jsonDecode(response.body);
          finalMap = tempMap['info'];
        });
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      // UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getHistory() async {
    setState(() {
      attendDate.clear();
      attendInTime.clear();
      attendOutTime.clear();
      attendTotalTime.clear();
      teacherId.clear();
      teacherName.clear();
      isFind = false;
    });
    try {
      String sDate =
          Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd');
      String eDate =
          Utils.formatDate(DateTime.parse(_endDateText.text), 'yyyy-MM-dd');
      String uri = Constants.REPORT_URL + '/attendancereport';
      Map params = {
        "startDate": sDate,
        "endDate": eDate,
        "level": userLevel,
        "id": userID
      };
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        setState(() {
          List<Map<String, dynamic>> tempData = [];
          List tempList = tempMap['info'];
          if (tempList.isNotEmpty) {
            tempList.forEach((element) {
              Map<String, dynamic> abc = {};
              Map<String, dynamic> data = element;
              teacherId.add(data['userId']);
              finalMap.forEach((element) {
                Map tempMap = element;
                if (tempMap['userId'] == data["userId"]) {
                  teacherName.add(tempMap['teacherName']);
                  abc['name'] = tempMap['teacherName'];
                }
              });
              attendDate.add(data['date']);
              attendInTime.add(data['inTime']);
              attendOutTime.add(data['outTime'] ?? data['inTime']);
              Duration difference =
                  Utils.parseTimeE(data['outTime'] ?? data['inTime'])
                      .difference(Utils.parseTimeE(data['inTime']));
              attendTotalTime.add(Utils.formatDuration(difference));
              abc['date'] = data['date'];
              abc['inTime'] = data['inTime'];
              abc['outTime'] = data['outTime'];
              abc['totalTime'] = Utils.formatDuration(difference);
              tempData.add(abc);
            });
            _data = TeacherAttendance(tempData);
            isFind = true;
          } else {
            msg = 'No History Found!!';
            isFind = false;
          }
        });
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future<void> reportGenerate() async {
    List<List<String>> userData = [
      ["Name", "teacherId", "Date", "In Time", "Out Time", "Total Time"]
    ];
    for (var index = 0; index < attendInTime.length; index++) {
      List<String> abc = [];
      abc.add(teacherName[index]);
      abc.add(teacherId[index]);
      abc.add(attendDate[index]);
      abc.add(attendInTime[index]);
      abc.add(attendOutTime[index]);
      Duration difference = Utils.parseTimeE(attendOutTime[index])
          .difference(Utils.parseTimeE(attendInTime[index]));
      abc.add(Utils.formatDuration(difference));
      userData.add(abc);
    }
    Utils.downloadCSV(userData, 'range.csv');
  }
}
