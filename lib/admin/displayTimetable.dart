import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final Map<String, dynamic> tt;

  TableWidget({required this.tt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DataTable(
            columnSpacing: MediaQuery.of(context).size.width * 0.03,
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: SizedBox(width: 60, child: Text('Class-Section'))),
      for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
        DataColumn(label: SizedBox(width: 170, child: Text(day))),
    ];
  }

  List<DataRow> _buildRows() {
  List<DataRow> rows = [];
  tt.forEach((className, classData) {
    classData.forEach((sectionName, sectionData) {
      List<DataCell> cells = [];
      cells.add(DataCell(Container(
        width: 160, // Adjust the width of the cell
        height: 160, // Adjust the height of the cell
        child: Center(
          child: Text('$className - $sectionName'),
        ),
      )));
      for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']) {
        String cellContent = '';
        if (sectionData.containsKey(day)) {
          // Displaying text one below the other
          sectionData[day].forEach((time, data) {
            cellContent += 'Time: $time-${data['endTime']} \n Subject: ${data['subject']} \n Room: ${data['room']} \nTeacher: ${data['teacher']}';
          });
        } else {
          cellContent = 'No classes';
        }
        cells.add(DataCell(Container(
          width: 160, // Adjust the width of the cell
          height: 160, // Adjust the height of the cell
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Text(cellContent),
            ),
          ),
        )));
      }
      rows.add(DataRow(cells: cells));
    });
  });
  return rows;
}

}
