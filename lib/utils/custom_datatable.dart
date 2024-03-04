import 'package:flutter/material.dart';

class TeacherAttendance extends DataTableSource {
  final List<Map<String, dynamic>> data;
  TeacherAttendance(this.data);
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index]["name"])),
      DataCell(Text(data[index]["date"])),
      DataCell(Text(data[index]["inTime"])),
      DataCell(Text(data[index]["outTime"])),
      DataCell(Text(data[index]["totalTime"])),
    ]);
  }
}

class TeacherLeave extends DataTableSource {
  final List<Map<String, dynamic>> data;
  TeacherLeave(this.data);
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index]["name"])),
      DataCell(Text(data[index]["leaveType"])),
      DataCell(Text(data[index]["startDate"])),
      DataCell(Text(data[index]["endDate"])),
      DataCell(Text(data[index]["totalLeave"])),
    ]);
  }
}

class StudentAttendance extends DataTableSource {
  final List<Map<String, dynamic>> data;
  StudentAttendance(this.data);
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index]["date"])),
      DataCell(Text(data[index]["studentId"])),
      DataCell(Text(data[index]["name"])),
      DataCell(Text(data[index]["class"])),
      DataCell(Text(data[index]["status"])),
    ]);
  }
}
