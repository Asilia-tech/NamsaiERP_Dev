import 'package:flutter/material.dart';
import 'package:numsai/admin/student_reports/attendance_range_reports.dart';
import 'package:numsai/admin/student_reports/exam_range_reports.dart';
import 'package:numsai/admin/student_reports/single_student_reports.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:get/get.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({Key? key}) : super(key: key);

  @override
  _StudentReportScreenState createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  @override
  Widget build(BuildContext context) {
    return UtilsWidgets.tabBar(
      'studentreport'.tr,
      [
        // Tab(icon: Icon(Icons.people), text: 'Student Attendance'),
        Tab(icon: Icon(Icons.calendar_month_outlined), text: 'attendancereport'.tr),
        Tab(icon: Icon(Icons.school_outlined), text: 'examreport'.tr),
      ],
      [
        // SingleStudentReport(),
        MonthlyAttendanceReportScreen(),
        MonthlyExamReportScreen(),
      ],
    );
  }
}
