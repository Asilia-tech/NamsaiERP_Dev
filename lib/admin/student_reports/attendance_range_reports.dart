import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:numsai/constants.dart';
import 'package:numsai/utils/custom_datatable.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthlyAttendanceReportScreen extends StatefulWidget {
  const MonthlyAttendanceReportScreen({Key? key}) : super(key: key);

  @override
  _MonthlyAttendanceReportScreenState createState() =>
      _MonthlyAttendanceReportScreenState();
}

class _MonthlyAttendanceReportScreenState
    extends State<MonthlyAttendanceReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateText =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _endDateText = TextEditingController();
  bool _isLoading = false;
  bool isFind = false;
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  String udise = "";
  List<String> attendDate = [];
  List<String> status = [];
  List<String> studentId = [];
  List<String> studentName = [];
  String msg = 'Please choose date range to generate report';
  List<dynamic> blockList = [];
  String blockName = "";
  List<dynamic> clusterList = [];
  String clusterName = "";
  List<dynamic> schoolList = [];
  List<dynamic> schoolId = [];
  String schoolName = "";
  Map<String, dynamic> blockData = {};
  List level2List = [];
  String level2Name = "";
  DataTableSource _data = StudentAttendance([]);

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.48,
                          child: UtilsWidgets.buildDatePicker(
                            'Choose Start Date',
                            'Choose Start Date',
                            _startDateText,
                            (val) {
                              setState(() {
                                _endDateText.text = _startDateText.text;
                              });
                            },
                            firstDate: DateTime(DateTime.now().year - 1),
                            lastDate: DateTime(DateTime.now().year + 1),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: UtilsWidgets.buildDatePicker('Choose End Date',
                              'Choose End Date', _endDateText, (val) {},
                              firstDate: DateTime.parse(_startDateText.text)
                                  .subtract(Duration(days: 0)),
                              lastDate: DateTime(
                                  DateTime.parse(_startDateText.text).year +
                                      1)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.48,
                            child: UtilsWidgets.dropDownButton(
                                context,
                                'Choose level',
                                'Choose level',
                                level2Name,
                                level2List, (p0) {
                              setState(() {
                                level2Name = p0;
                              });
                            }, validator: (p0) {
                              // if (level2Name == '') {
                              //   return "Please choose level";
                              // }
                            })),
                        userLevel == 'district'
                            ? level2Name == 'block' ||
                                    level2Name == 'cluster' ||
                                    level2Name == 'udise'
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.48,
                                    child: UtilsWidgets.searchAbleDropDown(
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
                                        }))
                                : Container()
                            : Container(),
                      ],
                    ),
                    Row(
                      children: [
                        userLevel == 'block' || userLevel == 'district'
                            ? level2Name == 'cluster' || level2Name == 'udise'
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.48,
                                    child: UtilsWidgets.searchAbleDropDown(
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
                                              tempMap = blockData[blockName]
                                                  [clusterName];
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
                                        }))
                                : Container()
                            : Container(),
                        userLevel == 'cluster' ||
                                userLevel == 'block' ||
                                userLevel == 'district'
                            ? level2Name == 'udise'
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.48,
                                    child: UtilsWidgets.searchAbleDropDown(
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
                                              udise = schoolId[schoolList
                                                  .indexOf(schoolName)];
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
                                        }))
                                : Container()
                            : Container()
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
                                'Search',
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
                                'Download',
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
                          "Student Attendance ${Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd') + ' to ' + Utils.formatDate(DateTime.parse(_endDateText.text), 'yyyy-MM-dd')}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        horizontalMargin: 10,
                        columnSpacing: 15,
                        arrowHeadColor: Colors.black,
                        columns: const [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Class')),
                          DataColumn(label: Text('Status')),
                        ],
                        rowsPerPage: 10,
                      ),
                    )
                  : Center(child: UtilsWidgets.msgDecor(context, msg)),
              // isFind
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           Text('Date',
              //               style: TextStyle(
              //                   color: Colors.black,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold)),
              //           Text('Student',
              //               style: TextStyle(
              //                   color: Colors.black,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold)),
              //           Text('Status',
              //               style: TextStyle(
              //                   color: Colors.black,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold)),
              //         ],
              //       )
              //     : SizedBox(),
              // Divider(
              //     thickness: 3, indent: 10, endIndent: 10, color: Colors.black),
              // isFind
              //     ? ListView.builder(
              //         itemCount: status.length,
              //         shrinkWrap: true,
              //         itemBuilder: (BuildContext context, int index) {
              //           return Column(
              //             children: [
              //               ListTile(
              //                 leading: Text(
              //                   attendDate[index],
              //                   style: TextStyle(
              //                       color: Colors.black, fontSize: 14),
              //                 ),
              //                 title: Center(
              //                   child: Text(
              //                     studentName[index],
              //                     style: TextStyle(
              //                       fontSize: 14,
              //                       color: Colors.black,
              //                     ),
              //                   ),
              //                 ),
              //                 subtitle: Center(
              //                   child: Text(
              //                     "Roll No. " + studentId[index],
              //                     style: TextStyle(
              //                       fontSize: 14,
              //                       color: Colors.black,
              //                     ),
              //                   ),
              //                 ),
              //                 trailing: Container(
              //                   color: status[index] == 'Present'
              //                       ? Colors.green
              //                       : Colors.red,
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: Text(
              //                       status[index],
              //                       style: TextStyle(
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w500,
              //                           fontSize: 14),
              //                     ),
              //                   ),
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
              const SizedBox(height: 10)
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
      if (userLevel == 'district') {
        level2List.add('block');
        level2List.add('cluster');
        level2List.add('udise');
      } else if (userLevel == 'block') {
        level2List.add('cluster');
        level2List.add('udise');
        blockName = userID;
        clusterList.clear();
        Map tempMap = {};
        tempMap = blockData[blockName];
        tempMap.forEach((clust, value) {
          clusterList.add(clust);
        });
      } else if (userLevel == 'cluster') {
        blockName = pref.getString('block') ?? '';
        level2List.add('udise');
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

  Future getHistory() async {
    setState(() {
      attendDate.clear();
      status.clear();
      studentId.clear();
      studentName.clear();
      msg = 'Please wait...';
      isFind = false;
    });
    try {
      String sDate =
          Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd');
      String eDate =
          Utils.formatDate(DateTime.parse(_endDateText.text), 'yyyy-MM-dd');
      String uri = Constants.REPORT_URL + '/levelwisestudentattendance';
      Map params = {
        "sDate": sDate,
        "eDate": eDate,
        "level": level2Name == '' ? userLevel : level2Name,
        "id": level2Name == 'block'
            ? blockName
            : level2Name == 'cluster'
                ? clusterName
                : level2Name == 'udise'
                    ? udise
                    : userID
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
              studentId.add(data['studentId']);
              attendDate.add(data['date']);
              status.add(data['status']);
              studentName.add(data['studentName']);
              abc['studentId'] = data['studentId'];
              abc['name'] = data['studentName'];
              abc['date'] = data['date'];
              abc['class'] = data['sclass'];
              abc['status'] = data['status'];
              tempData.add(abc);
            });
            _data = StudentAttendance(tempData);
            isFind = true;
          } else {
            msg = 'Something missing!!';
            isFind = false;
          }
        });
      } else {
        setState(() {
          msg = 'No History Found!!';
          isFind = false;
        });
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future<void> reportGenerate() async {
    List<List<String>> userData = [
      ["Student Id", "Student Name", "Date", "Status"]
    ];
    for (var index = 0; index < status.length; index++) {
      List<String> abc = [];
      abc.add(studentId[index]);
      abc.add(studentName[index]);
      abc.add(attendDate[index]);
      abc.add(status[index]);
      userData.add(abc);
    }
    Utils.downloadCSV(userData, 'range.csv');
  }
}
