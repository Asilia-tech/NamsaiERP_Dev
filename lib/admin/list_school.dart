import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:numsai/admin/update_school.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolList extends StatefulWidget {
  const SchoolList({super.key});

  @override
  State<SchoolList> createState() => _SchoolListState();
}

class _SchoolListState extends State<SchoolList> {
  int? sortColumnIndex;
  bool isAscending = false;
  String userLevel = "";
  String userID = "";
  List<dynamic> finalMap = [];
  bool _isLoading = false;
  bool _isFind = false;
  String msg = "Please Wait...";

  @override
  void initState() {
    getOfflineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'All School'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              _isFind
                  ? UtilsWidgets.drawTable(
                      [
                          DataColumn(
                            label: Text('Name'),
                            onSort: (int columnIndex, bool ascending) {
                              finalMap.sort((user1, user2) => compareString(
                                  isAscending,
                                  user1['schoolName'],
                                  user2['schoolName']));
                              setState(() {
                                isAscending = ascending;
                              });
                            },
                          ),
                          DataColumn(label: Text('udise'.toUpperCase())),
                          DataColumn(label: Text('Edit'))
                        ],
                      finalMap
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e['schoolName'])),
                                DataCell(Text(e['udise'])),
                                DataCell(TextButton.icon(
                                    onPressed: () {
                                      Get.to(UpdateSchool(
                                        id: e['udise'],
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.mode_edit,
                                      color: Colors.blue,
                                    ),
                                    label: const Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.blue,
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
    await getSchoolList();
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Future getSchoolList() async {
    setState(() {
      finalMap.clear();
      _isFind = false;
      msg = 'Please Wait...';
    });
    try {
      String uri = Constants.SCHOOL_URL + '/schoollist';
      Map params = {"level": userLevel, "id": userID};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> tempMap = jsonDecode(response.body);
          finalMap = tempMap['info'];
          if (finalMap.isEmpty) {
            _isFind = false;
            msg = 'No school found!!';
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
