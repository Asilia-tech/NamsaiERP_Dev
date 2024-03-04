import 'package:flutter/material.dart';
import 'package:numsai/admin/teacher_reports/leave_range_reports.dart';
import 'package:numsai/admin/teacher_reports/range_reports.dart';
import 'package:numsai/admin/teacher_reports/single_teacher_reports.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:get/get.dart';

class TeacherReportScreen extends StatefulWidget {
  const TeacherReportScreen({Key? key}) : super(key: key);

  @override
  _TeacherReportScreenState createState() => _TeacherReportScreenState();
}

class _TeacherReportScreenState extends State<TeacherReportScreen> {
  @override
  Widget build(BuildContext context) {
    return UtilsWidgets.tabBar(
      'teacherreports'.tr,
      [
        Tab(icon: Icon(Icons.people), text: 'userreport'.tr),
        Tab(icon: Icon(Icons.calendar_month_outlined), text: 'monthlyreport'.tr),
        Tab(icon: Icon(Icons.calendar_today_rounded), text: 'leavereport'.tr),
      ],
      [SingleTeacherReport(), MonthlyReportScreen(), MonthlyLeaveScreen()],
    );
  }
}
