import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:numsai/screens/login_page.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/drawer_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = true;
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  String designation = "";
  String email = "";
  String userName = "";
  String currentDate = '';
  Map count = {};

  @override
  void initState() {
    getOfflineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userID == ""
        ? const PhoneLogin()
        : PopScope(
            canPop: false,
            child: Scaffold(
              drawer: BuildDrawer.buildUserDrawer(context, true, true),
              appBar: UtilsWidgets.buildAppBar(context, Constants.APPNAME),
              body: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/clock.gif',
                            width: 200,
                            height: 150,
                          ),
                          Text(
                            "please".tr + "wait".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            Container(
                              width: 350,
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 1.0,
                                    height: 20.0,
                                  ),
                                  Text(
                                    designation,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(width: 10),
                                  UtilsWidgets.buildAdminCount(
                                      "totalschools".tr,
                                      Icons.article,
                                      count["totalSchools"].toString()),
                                  const SizedBox(width: 10),
                                  UtilsWidgets.buildAdminCount(
                                      "totalteachers".tr,
                                      Icons.comment,
                                      count["totalTeacher"].toString()),
                                  const SizedBox(width: 10),
                                  UtilsWidgets.buildAdminCount(
                                      "totalprincipals".tr,
                                      Icons.people,
                                      count["totalHm"].toString()),
                                  const SizedBox(width: 10),
                                  UtilsWidgets.buildAdminCount(
                                      "totalstudents".tr,
                                      Icons.pets_outlined,
                                      count["totalStudent"].toString()),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.grey.shade300,
                                    ),
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'teacheroverview'.tr,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            UtilsWidgets.buildCard(
                                              count["presentTeacher"]
                                                  .toString(),
                                              Text(
                                                'presentteachers'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              null,
                                              Colors.green,
                                            ),
                                            const SizedBox(width: 15.0),
                                            UtilsWidgets.buildCard(
                                              count["absentTeacher"].toString(),
                                              Text(
                                                'absentteachers'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              null,
                                              Colors.red,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.grey.shade300,
                                    ),
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'studentoverview'.tr,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            UtilsWidgets.buildCard(
                                              count["absentStudent"].toString(),
                                              Text(
                                                'presentstudents'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              null,
                                              Colors.red,
                                            ),
                                            const SizedBox(width: 15.0),
                                            UtilsWidgets.buildCard(
                                              count["presentStudent"]
                                                  .toString(),
                                              Text(
                                                'absentstudents'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              null,
                                              Colors.green,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                ],
                              ),
                            ),
                          ],
                        ),
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
      userNumber = pref.getString('number') ?? '';
    });
    if (userID.isNotEmpty) {
      await getAdminInfo();
      await getCount();
    }
  }

  Future getAdminInfo() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> userMap = {};
    String uri =
        'https://4gsb83txs9.execute-api.ap-south-1.amazonaws.com/dev/admindetails';
    Map params = {"mobile": userNumber};
    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          userMap = jsonDecode(response.body);
          designation = userMap["info"]["designation"] ?? '';
          email = userMap["info"]["email"] ?? '';
          userName = userMap["info"]["name"] ?? '';
        });
        final pref = await SharedPreferences.getInstance();
        if (userMap["isValid"]) {
          pref.setString('designation', designation);
          pref.setString('email', email);
          pref.setString('name', userName);
          pref.setString('district', userMap["info"]["district"] ?? '');
          pref.setString('block', userMap["info"]["block"] ?? '');
          pref.setString('cluster', userMap["info"]["cluster"] ?? '');
        } else {
          pref.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneLogin(),
            ),
          );
        }
      } else {
        UtilsWidgets.showToastFunc('Admin Server Error ${response.statusCode}');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getCount() async {
    try {
      String uri = Constants.REPORT_URL + '/count';
      Map params = {"date": currentDate, "level": userLevel, "id": userID};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        if (tempMap['isValid']) {
          setState(() {
            count = tempMap['count'];
          });
        }
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
