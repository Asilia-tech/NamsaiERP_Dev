import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/custom_datatable.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SingleTeacherReport extends StatefulWidget {
  const SingleTeacherReport({Key? key}) : super(key: key);

  @override
  _SingleTeacherReportState createState() => _SingleTeacherReportState();
}

class _SingleTeacherReportState extends State<SingleTeacherReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateText =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _endDateText = TextEditingController();
  bool _isLoading = false;
  String userRole = "";
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  bool _isConnected = false;
  List<String> attendDate = [];
  List<String> attendInTime = [];
  List<String> attendOutTime = [];
  List<String> attendTotalTime = [];
  List<dynamic> teacherNameList = [];
  List<dynamic> teacherIdList = [];
  String teacherName = "";
  String teacherId = "";
  String msg = 'Please choose teacher name to generate report';
  List<dynamic> finalMap = [];
  bool _isFind = false;
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
                    UtilsWidgets.buildDatePicker('Choose End Date',
                        'Choose End Date', _endDateText, (val) {},
                        firstDate: DateTime.parse(_startDateText.text)
                            .subtract(Duration(days: 0)),
                        lastDate: DateTime(
                            DateTime.parse(_startDateText.text).year + 1)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: UtilsWidgets.searchAbleDropDown(
                          context,
                          teacherNameList,
                          teacherName,
                          'Choose Teacher Name',
                          'Choose Teacher Name',
                          const Icon(Icons.search),
                          (value) {
                            setState(() {
                              teacherName = value;
                              teacherId = teacherIdList[
                                  teacherNameList.indexOf(teacherName)];
                            });
                          },
                          'Choose Teacher Name',
                          Colors.black,
                          'Choose Teacher Name',
                          (value) {
                            if (value == 'Choose Teacher Name' ||
                                value == null ||
                                value.toString().isEmpty) {
                              return 'Please Choose Teacher Name';
                            }
                            return null;
                          }),
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
                        _isFind
                            ? UtilsWidgets.buildSqureBtn(
                                'Download',
                                () async {
                                  reportGenerate();
                                },
                                Constants.primaryColor,
                                Colors.white,
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _isFind
                  ? Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: PaginatedDataTable(
                        source: _data,
                        header: Text(
                          "$teacherName Attendance ${Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd') + ' to ' + Utils.formatDate(DateTime.parse(_endDateText.text), 'yyyy-MM-dd')}",
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
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('In Time')),
                          DataColumn(label: Text('Out Time')),
                          DataColumn(label: Text('Total Time')),
                        ],
                        rowsPerPage: 10,
                      ),
                    )
                  : Center(child: UtilsWidgets.msgDecor(context, msg)),
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
    });
    //   if (userLevel == 'block') {
    //     blockName = userID;
    //     clusterList.clear();
    //     Map tempMap = {};
    //     tempMap = blockData[blockName];
    //     tempMap.forEach((clust, value) {
    //       clusterList.add(clust);
    //     });
    //   } else if (userLevel == 'cluster') {
    //     blockName = pref.getString('block') ?? '';
    //     clusterName = userID;
    //     schoolList.clear();
    //     schoolList.clear();
    //     Map tempMap = {};
    //     tempMap = blockData[blockName][clusterName];
    //     tempMap.forEach((id, name) {
    //       schoolList.add(name);
    //       schoolId.add(id);
    //     });
    //   } else {}
    getTeacherList();
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
          finalMap.forEach((element) {
            teacherIdList.add(element['userId']);
            teacherNameList.add(element['teacherName']);
          });
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
      _isFind = false;
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
        "level": "user",
        "id": teacherId
      };
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        setState(() {
          List<Map<String, dynamic>> tempData = [];
          List tempList = tempMap['info'];
          if (tempList.isNotEmpty) {
            for (var element in tempList) {
              Map<String, dynamic> abc = {};
              Map<String, dynamic> data = element;
              attendDate.add(data['date']);
              attendInTime.add(data['inTime']);
              attendOutTime.add(data['outTime'] ?? data['inTime']);
              Duration difference =
                  Utils.parseTimeE(data['outTime'] ?? data['inTime'])
                      .difference(Utils.parseTimeE(data['inTime']));
              attendTotalTime.add(Utils.formatDuration(difference));
              abc['name'] = teacherName;
              abc['date'] = data['date'];
              abc['inTime'] = data['inTime'];
              abc['outTime'] = data['outTime'];
              abc['totalTime'] = Utils.formatDuration(difference);
              tempData.add(abc);
            }
            _data = TeacherAttendance(tempData);
            _isFind = true;
          } else {
            msg = 'No History Found!!';
            _isFind = false;
          }
        });
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future<void> reportGenerate() async {
    List<List<String>> userData = [
      ["Date", "In Time", "Out Time", "Total Time"]
    ];
    for (var index = 0; index < attendInTime.length; index++) {
      List<String> abc = [];
      abc.add(attendDate[index]);
      abc.add(attendInTime[index]);
      abc.add(attendOutTime[index]);
      Duration difference = Utils.parseTimeE(attendOutTime[index])
          .difference(Utils.parseTimeE(attendInTime[index]));
      abc.add(Utils.formatDuration(difference));
      userData.add(abc);
    }
    Utils.downloadCSV(userData, '$teacherName.csv');
  }
}
