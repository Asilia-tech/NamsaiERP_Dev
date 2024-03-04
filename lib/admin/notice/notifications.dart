import 'package:flutter/material.dart';
import 'package:numsai/admin/notice/add_notices.dart';
import 'package:numsai/admin/notice/notice_receive.dart';
import 'package:numsai/admin/notice/notice_send.dart';
import 'package:numsai/constants.dart';
import 'package:get/get.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).padding.top +
              kToolbarHeight, // Use MediaQuery for full height
          alignment: Alignment.center,
          child: Text(
            'notifications'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Constants.primaryColor),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'createnotif'.tr),
            Tab(text: 'sentnotif'.tr),
            Tab(text: 'receivednotif'.tr),
          ],
          indicator: BoxDecoration(
            color: Constants.primaryColor,
          ),
          indicatorWeight: 4.0, // For the full width effect
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NoticePost(),
          NoticeSend(),
          NoticeReceive(),
        ],
      ),
    );
  }
}
