import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:numsai/admin/notice/notice_details.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeReceive extends StatefulWidget {
  const NoticeReceive({super.key});

  @override
  State<NoticeReceive> createState() => _NoticeReceiveState();
}

class _NoticeReceiveState extends State<NoticeReceive> {
  String userID = "";
  bool _isFind = false;
  String msg = "please".tr + "wait".tr;
  List noticeList = [];
  Map<String, List<Map<String, dynamic>>> groupedData = {};

  @override
  void initState() {
    getOfflineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: UtilsWidgets.buildAppBar(context, 'viewnotice'.tr),
      body: _isFind
          ? ListView.builder(
              itemCount: groupedData.length,
              itemBuilder: (context, index) {
                String month = groupedData.keys.elementAt(index);
                List<Map<String, dynamic>> items = groupedData[month]!;
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      month,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.040,
                          fontWeight: FontWeight.bold),
                    ),
                    children: items.map((item) {
                      return ListTile(
                          tileColor:
                              item['view'] ? Colors.grey[50] : Colors.grey[200],
                          onTap: () {
                            viewNotice(item['noticeId'], item['date'])
                                .whenComplete(() =>
                                    Get.to(NoticeDetails(noticeMap: item)));
                          },
                          leading: const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 193, 216, 223),
                            child: Icon(Icons.book),
                          ),
                          title: Text(item['title'],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: item['view']
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                              maxLines: 2),
                          subtitle: Text(item['description'],
                              style: TextStyle(
                                  fontWeight: item['view']
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035),
                              maxLines: 2),
                          trailing: Text(
                            item['date'],
                            style: TextStyle(
                                fontWeight: item['view']
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035),
                          ));
                    }).toList(),
                  ),
                );
              },
            )
          : Center(child: UtilsWidgets.msgDecor(context, msg)),
    );
  }

  getOfflineData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString('id') ?? '';
    });
    getNoticeReceive();
  }

  Future viewNotice(String noticeId, String date) async {
    try {
      String uri = Constants.NOTIFY_URL + '/viewnotice';
      Map params = {"noticeId": noticeId, "date": date, "userId": userID};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        print('View Notice');
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      // UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getNoticeReceive() async {
    setState(() {
      noticeList.clear();
      _isFind = false;
    });
    try {
      String uri = Constants.NOTIFY_URL + '/noticereceive';
      Map params = {"level": "userId", "id": userID};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        if (tempMap['isValid']) {
          setState(() {
            noticeList = tempMap['info'];
            noticeList.sort((a, b) =>
                DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
            for (var item in noticeList) {
              DateTime dateTime = DateTime.parse(item['date']);
              String month = DateFormat('MMMM yy').format(dateTime);
              if (!groupedData.containsKey(month)) {
                groupedData[month] = [];
              }
              groupedData[month]!.add(item);
            }
            if (noticeList.isNotEmpty) {
              _isFind = true;
            } else {
              msg = 'nohistoryfound'.tr;
              _isFind = false;
            }
          });
        } else {
          setState(() {
            msg = 'nohistoryfound'.tr;
            _isFind = false;
          });
        }
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      // UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
