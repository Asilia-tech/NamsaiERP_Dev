import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numsai/utils/local_string.dart';
import 'package:numsai/utils/widget_utils.dart';

class TableWidget extends StatefulWidget {
  final Map<String, dynamic> tt;
  const TableWidget({required this.tt, Key? key}) : super(key: key);

  @override
  State<TableWidget> createState() => _TableState(tt: tt);
}

class _TableState extends State<TableWidget> {
  final _formKey = GlobalKey<FormState>();
  List classList = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'];
  List sectionList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  String _class = "";
  String section = "";
  final Map<String, dynamic> tt;

  _TableState({required this.tt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'timetable'.tr),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(width: 10),
                UtilsWidgets.searchAbleDropDown(
                  context,
                  classList,
                  'class'.tr,
                  'chooseclass'.tr,
                  'class'.tr,
                  const Icon(Icons.search),
                  (value) {
                    if (value != null) {
                      setState(() {
                        _class = value;
                      });
                    }
                  },
                  'chooseclass'.tr,
                  Colors.black,
                  'chooseclass'.tr,
                  (value) {
                    if (value == 'chooseclass'.tr ||
                        value == null ||
                        value.toString().isEmpty) {
                      return 'please'.tr + 'chooseclass'.tr;
                    }
                    return null;
                  }
                ),
                SizedBox(width: 10),
                UtilsWidgets.searchAbleDropDown(
                  context,
                  sectionList,
                  'section'.tr,
                  'choosesection'.tr,
                  'section'.tr,
                  const Icon(Icons.search),
                  (value) {
                    if (value != null) {
                      setState(() {
                        section = value;
                      });
                    }
                  },
                  'choosesection'.tr,
                  Colors.black,
                  'choosesection'.tr,
                  (value) {
                    if (value == 'choosesection'.tr ||
                        value == null ||
                        value.toString().isEmpty) {
                      return 'please'.tr + 'choosesection'.tr;
                    }
                    return null;
                  }
                ),
                SizedBox(width: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: DataTable(
                      dataRowHeight:100,
                      columnSpacing: MediaQuery.of(context).size.width * 0.03,
                      columns: _buildColumns(),
                      rows: _buildRows(),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: SizedBox( child: Text('Time'))),
      for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
        DataColumn(label: SizedBox(child: Text(day))),
    ];
  }

  List<DataRow> _buildRows() {
  List<DataRow> rows = [];
  final Map<String, int> dayIndex = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  Map<String, dynamic>? classData = widget.tt[_class];
  if (classData != null && classData.containsKey(section)) {
    Map<String, dynamic>? sectionData = classData[section];
    if (sectionData != null) {
      // Initialize a map to store the row indices for each startTime
      Map<String, int> rowIndex = {};
      // Iterate over each day
      for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']) {
        // Get the timetable data for the current day
        Map<String, dynamic>? dayData = sectionData[day];
        if (dayData != null) {
          // Convert entries to a list, sort it, and then iterate
          List<MapEntry<String, dynamic>> sortedEntries = dayData.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));
          sortedEntries.forEach((entry) {
            String startTime = entry.key;
            Map<String, dynamic> info = entry.value;
            if (!rowIndex.containsKey(startTime)) {
              // If the startTime doesn't exist in the rowIndex, create a new row
              List<DataCell> cells = List.filled(_buildColumns().length, DataCell(Container())); // Fill cells list with empty cells
              // Add the startTime-endTime to the first cell
              cells[0] = DataCell(Container(
                child: Text('$startTime - ${info['endTime']}'),
              ));
              // Add the remaining information to the cell corresponding to the day
              String subject = info['subject'] ?? 'Unknown';
              String room = info['room']?.toString() ?? 'Unknown';
              String teacher = info['teacher'] ?? 'Unknown';
              String cellContent = 'Subject: $subject\nRoom: $room\nTeacher: $teacher';
              // Add cellContent to the cell corresponding to the day
              cells[dayIndex[day]!] = DataCell(Container(
                child: Text(cellContent),
              ));
              // Add the cells for the current day to the row
              rows.add(DataRow(cells: cells));
              // Store the index of the row for the current startTime
              rowIndex[startTime] = rows.length - 1;
            } else {
              // If the startTime already exists in rowIndex, update the existing row
              int existingRowIndex = rowIndex[startTime]!;
              // Get the existing cells for the row
              List<DataCell> cells = rows[existingRowIndex].cells.toList();
              // Add the remaining information to the cell corresponding to the day
              String subject = info['subject'] ?? 'Unknown';
              String room = info['room']?.toString() ?? 'Unknown';
              String teacher = info['teacher'] ?? 'Unknown';
              String cellContent = 'Subject: $subject\nRoom: $room\nTeacher: $teacher';
              // Add cellContent to the cell corresponding to the day
              cells[dayIndex[day]!] = DataCell(Container(
                child: Text(cellContent),
              ));
              // Update the existing row with the new cells
              rows[existingRowIndex] = DataRow(cells: cells);
            }
          });
        }
      }
    }
  }
  return rows;
}


}
