import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:numsai/admin/notice/notice_details.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeSend extends StatefulWidget {
  const NoticeSend({super.key});

  @override
  State<NoticeSend> createState() => _NoticeSendState();
}

class _NoticeSendState extends State<NoticeSend> {
  String userLevel = "";
  String userId = "";
  String userNumber = "";
  bool _isFind = false;
  String msg = 'Please Wait...';
  bool _isConnected = false;
  List noticeList = [];

  @override
  void initState() {
    getNoticeSend();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: UtilsWidgets.buildAppBar(context, 'Notice History'),
      body: _isFind
          ? ListView.builder(
              itemCount: noticeList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Colors.grey[200],
                    onTap: () {
                      Get.to(NoticeDetails(noticeMap: noticeList[index]));
                    },
                    leading: Text(
                      noticeList[index]['date'],
                      style: TextStyle(fontSize: 14),
                    ),
                    title: Text(noticeList[index]['title'],
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 2),
                    subtitle: Text(noticeList[index]['description'],
                        style: TextStyle(fontSize: 14), maxLines: 2),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        UtilsWidgets.bottomDialogs(
                            'Do you really want to delete this notice?',
                            'Delete Notice',
                            'No',
                            'Yes',
                            context, () {
                          Navigator.of(context).pop();
                        }, () async {
                          deleteNotice(
                            noticeList[index]['noticeId'],
                            noticeList[index]['date'],
                          );
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                );
              })
          : Center(child: UtilsWidgets.msgDecor(context, msg)),
    );
  }

  Future deleteNotice(String noticeId, String date) async {
    try {
      String uri = Constants.NOTIFY_URL + '/deletenotice';
      Map params = {"noticeId": noticeId, "date": date, "userId": userId};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        UtilsWidgets.showGetDialog(context, tempMap['message'], Colors.green);
        await getNoticeSend();
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getNoticeSend() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userNumber = pref.getString('number') ?? '';
      userLevel = pref.getString('level') ?? '';
      userId = pref.getString('id') ?? '';
      noticeList.clear();
      _isFind = false;
    });
    try {
      String uri = Constants.NOTIFY_URL + '/noticesend';
      Map params = {"sendBy": userNumber};
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        if (tempMap['isValid']) {
          setState(() {
            noticeList = tempMap['info'];
            if (noticeList.isNotEmpty) {
              _isFind = true;
            } else {
              msg = 'No History Found!!';
              _isFind = false;
            }
          });
        } else {
          setState(() {
            msg = tempMap['message'];
            _isFind = false;
          });
        }
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
