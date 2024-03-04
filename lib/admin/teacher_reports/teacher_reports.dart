import 'package:flutter/material.dart';
import 'package:numsai/admin/teacher_reports/leave_range_reports.dart';
import 'package:numsai/admin/teacher_reports/range_reports.dart';
import 'package:numsai/admin/teacher_reports/single_teacher_reports.dart';
import 'package:numsai/utils/widget_utils.dart';

class TeacherReportScreen extends StatefulWidget {
  const TeacherReportScreen({Key? key}) : super(key: key);

  @override
  _TeacherReportScreenState createState() => _TeacherReportScreenState();
}

class _TeacherReportScreenState extends State<TeacherReportScreen> {
  @override
  Widget build(BuildContext context) {
    return UtilsWidgets.tabBar(
      'Teacher Reports',
      const [
        Tab(icon: Icon(Icons.people), text: 'User Report'),
        Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Monthly Report'),
        Tab(icon: Icon(Icons.calendar_today_rounded), text: 'Leave Report'),
      ],
      [SingleTeacherReport(), MonthlyReportScreen(), MonthlyLeaveScreen()],
    );
  }
}
