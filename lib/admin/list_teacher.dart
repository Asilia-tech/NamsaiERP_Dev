import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:numsai/admin/update_teacher.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherList extends StatefulWidget {
  const TeacherList({super.key});

  @override
  State<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  int? sortColumnIndex;
  bool isAscending = false;
  String userLevel = "";
  String userID = "";
  List<dynamic> finalMap = [];
  bool _isLoading = false;
  bool _isFind = false;
  String msg = 'please'.tr + 'wait'.tr;

  @override
  void initState() {
    getOfflineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'allteachers'.tr),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              _isFind
                  ? UtilsWidgets.drawTable(
                      [
                          DataColumn(
                            label: Text('teachername'.tr),
                            onSort: (int columnIndex, bool ascending) {
                              finalMap.sort((user1, user2) => compareString(
                                  isAscending,
                                  user1['teacherName'],
                                  user2['teacherName']));
                              setState(() {
                                isAscending = ascending;
                              });
                            },
                          ),
                          DataColumn(label: Text('mobile'.tr)),
                          DataColumn(label: Text('edit'.tr)),
                          DataColumn(label: Text('transfer'.tr)),
                        ],
                      finalMap
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e['teacherName'])),
                                DataCell(Text(e['mobile'])),
                                DataCell(TextButton.icon(
                                    onPressed: () {
                                      Get.to(UpdateTeacher(
                                          id: e['userId'], transfer: false));
                                    },
                                    icon: Icon(
                                      Icons.mode_edit,
                                      color: Colors.blue,
                                    ),
                                    label: Text(
                                      'edit'.tr,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ))),
                                DataCell(TextButton.icon(
                                    onPressed: () {
                                      Get.to(UpdateTeacher(
                                          id: e['userId'], transfer: true));
                                    },
                                    icon: Icon(
                                      Icons.change_circle,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      'transfer'.tr,
                                      style: TextStyle(
                                          color: Colors.red,
                                          decoration: TextDecoration.underline),
                                    ))),
                              ]))
                          .toList(),
                      sort: isAscending,
                      columnIndex: 0)
                  : Center(child: UtilsWidgets.msgDecor(context, msg)),
            ],
          ),
        ),
      ),
    );
  }

  getOfflineData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userLevel = pref.getString('level') ?? '';
      userID = pref.getString('id') ?? '';
    });
    await getTeacherList();
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Future getTeacherList() async {
    setState(() {
      finalMap.clear();
      _isFind = false;
      msg = 'please'.tr + 'wait'.tr;
    });
    try {
      String uri = Constants.TEACHER_URL + '/teacherlist';
      Map params = {"level": userLevel, "id": userID};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> tempMap = jsonDecode(response.body);
          finalMap = tempMap['info'];
          if (finalMap.isEmpty) {
            _isFind = false;
            msg = 'No teacher found!!';
          } else {
            _isFind = true;
          }
        });
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      // UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
