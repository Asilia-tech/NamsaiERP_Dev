import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SingleStudentReport extends StatefulWidget {
  const SingleStudentReport({Key? key}) : super(key: key);

  @override
  _SingleStudentReportState createState() => _SingleStudentReportState();
}

class _SingleStudentReportState extends State<SingleStudentReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateText =
      TextEditingController(text: DateTime.now().toString());
  bool _isLoading = false;
  bool _isConnected = false;
  String msg = 'Please choose student name to generate report';
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  // String udise = "";
  // String studentName = "";
  // String studentId = "";
  // List<dynamic> studentMap = [];
  // List<dynamic> studentNameList = [];
  // List<dynamic> studentIdList = [];
  List<dynamic> attendanceMap = [];
  // List classList = [];
  // String className = "";
  // List divisionList = [];
  // String divisionName = "";
  bool _isFind = false;
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
                        userLevel == 'block' || userLevel == 'district'
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
                        // UtilsWidgets.searchAbleDropDown(
                        //     context,
                        //     schoolList,
                        //     schoolName,
                        //     'Choose school',
                        //     schoolName,
                        //     const Icon(Icons.search),
                        //     (value) {
                        //       if (value != null) {
                        //         setState(() {
                        //           schoolName = value;
                        //           udise =
                        //               schoolId[schoolList.indexOf(schoolName)];
                        //         });
                        //       }
                        //     },
                        //     'Choose school',
                        //     Colors.black,
                        //     'Choose school',
                        //     (value) {
                        //       if (value == 'Choose school' ||
                        //           value == null ||
                        //           value.toString().isEmpty) {
                        //         return 'Please Choose school';
                        //       }
                        //       return null;
                        //     }),
                      ],
                    ),
                    UtilsWidgets.buildDatePicker(
                      'Choose Start Date',
                      'Choose Start Date',
                      _startDateText,
                      (val) {},
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                    ),
                    // UtilsWidgets.buildDatePicker('Choose End Date',
                    //     'Choose End Date', _endDateText, (val) {},
                    //     firstDate: DateTime.parse(_startDateText.text)
                    //         .subtract(Duration(days: 0)),
                    //     lastDate: DateTime(
                    //         DateTime.parse(_startDateText.text).year + 1)),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width * 0.48,
                    //       child: UtilsWidgets.dropDownButton(
                    //         context,
                    //         'Choose class',
                    //         'Choose class',
                    //         className,
                    //         classList,
                    //         (p0) => setState(() {
                    //           className = p0;
                    //         }),
                    //         validator: (p0) {
                    //           if (className == '') {
                    //             return "Please Choose class";
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width * 0.52,
                    //       child: UtilsWidgets.dropDownButton(
                    //         context,
                    //         'Choose division',
                    //         'Choose division',
                    //         divisionName,
                    //         divisionList,
                    //         (p0) {
                    //           setState(() {
                    //             divisionName = p0;
                    //           });
                    //           getStudentList();
                    //         },
                    //         validator: (p0) {
                    //           if (divisionName == '') {
                    //             return "Please Choose class";
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: UtilsWidgets.searchAbleDropDown(
                    //       context,
                    //       studentNameList,
                    //       studentName,
                    //       'Choose Student Name',
                    //       'Choose Student Name',
                    //       const Icon(Icons.search),
                    //       (value) {
                    //         setState(() {
                    //           studentName = value;
                    //           studentId = studentIdList[
                    //               studentNameList.indexOf(studentName)];
                    //         });
                    //       },
                    //       'Choose Student Name',
                    //       Colors.black,
                    //       'Choose Student Name',
                    //       (value) {
                    //         if (value == 'Choose Student Name' ||
                    //             value == null ||
                    //             value.toString().isEmpty) {
                    //           return 'Please Choose Student Name';
                    //         }
                    //         return null;
                    //       }),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isLoading
                            ? const Center(
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
                        const SizedBox(width: 10),
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
                  ? UtilsWidgets.drawTable(
                      const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('School Name')),
                        DataColumn(label: Text('No. Present Student')),
                        DataColumn(label: Text('No. Absent Student'))
                      ],
                      attendanceMap
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e['date'])),
                                DataCell(Text(e['schoolName'])),
                                DataCell(Text(e['present'])),
                                DataCell(Text(e['absent'])),
                              ]))
                          .toList(),
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

  // Future getStudentList() async {
  //   setState(() {
  //     studentMap.clear();
  //   });
  //   try {
  //     String uri = Constants.STUDENT_URL + '/studentlist';
  //     Map params = {
  //       'level': userLevel,
  //       'id': userID,
  //     };
  //     var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> tempMap = jsonDecode(response.body);
  //       setState(() {
  //         studentMap = tempMap['info'];
  //         studentNameList
  //             .add(studentMap.where((element) => element['studentName']));
  //         // finalMap
  //         //     .where(
  //         //         (element) => element['userId'] == infoMap["userId"])
  //         //     .map((element) => element['teacherName'])
  //         //     .forEach((teacherName) {
  //         //   userName.add(teacherName);
  //         //   abc['name'] = tempMap['teacherName'];
  //         // });
  //         studentMap.forEach((element) {
  //           studentNameList.add(element['studentName']);
  //           studentIdList.add(element['studentId']);
  //         });
  //       });
  //     } else {
  //       UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // UtilsWidgets.showToastFunc(e.toString());
  //   }
  // }

  Future getHistory() async {
    setState(() {
      _isFind = false;
      msg = 'Please wait...';
    });
    try {
      String sDate =
          Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd');
      String uri = Constants.REPORT_URL + '/schoolstudentattendance';
      Map params = {
        "sDate": sDate,
        "level": userLevel,
        "id": userID,
      };

      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));

      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        setState(() {
          attendanceMap = tempMap['info'];
          if (attendanceMap.isNotEmpty) {
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
      ["Date", "Status", "Marked By"]
    ];
    for (var index = 0; index < attendanceMap.length; index++) {
      List<String> abc = [];
      abc.add(attendanceMap[index]['date']);
      abc.add(attendanceMap[index]['status']);
      abc.add(attendanceMap[index]['teacherName']);
      userData.add(abc);
    }
    Utils.downloadCSV(userData, '$userLevel.csv');
  }
}
