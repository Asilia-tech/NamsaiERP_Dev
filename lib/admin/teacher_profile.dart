import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:numsai/utils/widget_utils.dart';

class TeacherProfile extends StatefulWidget {
  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  late List<Map<String, dynamic>> data;
  final int rowsPerPage = 7;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      data = jsonData.map((user) {
        return {
          "Roll no": user['id'],
          "Teacher name": user['name'],
          "School name": user['company']['name'],
          "Block": user['address']['city'],
          "View": "Details",
        };
      }).toList();

      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    List<dynamic> blockList = ['School 1', 'School 2', 'School 3'];
    String blockName = "";

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Teacher Profile",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.014,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                UtilsWidgets.searchAbleDropDown(context,
                  blockList,
                  blockName,
                  'Select School',
                  'Select School',
                  const Icon(Icons.search),
                  (value) {
                    setState(() {
                      blockName = value;
                    });
                  },
                  'Select School',
                  Colors.black,
                  'Select School',
                  (value) {
                    if (value == 'Select School' ||
                        value == null ||
                        value.toString().isEmpty) {
                      return 'Please Choose block name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: PaginatedDataTable(
                    columnSpacing: 50.0,
                    columns: [
                      DataColumn(
                        label: SizedBox(width: MediaQuery.of(context).size.width * 0.04, child: Text('Roll no')),
                        numeric: true,
                        tooltip: 'Roll number of the student',
                      ),
                      DataColumn(
                        label: SizedBox(width: MediaQuery.of(context).size.width * 0.2, child: Text('Teacher name')),
                        numeric: false,
                        tooltip: 'Teacher name',
                      ),
                      DataColumn(
                        label: SizedBox(width: MediaQuery.of(context).size.width * 0.2, child: Text('School name')),
                        numeric: false,
                        tooltip: 'Name of the school',
                      ),
                      DataColumn(
                        label: SizedBox(width: MediaQuery.of(context).size.width * 0.075, child: Text('Block')),
                        numeric: false,
                        tooltip: 'Block of the school',
                      ),
                      DataColumn(
                        label: SizedBox(width: MediaQuery.of(context).size.width * 0.04, child: Text('View')),
                        numeric: false,
                        tooltip: 'View',
                      ),
                    ],
                    source: _MyDataSource(data, context),
                    rowsPerPage: rowsPerPage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyDataSource extends DataTableSource {
  _MyDataSource(this.data, this.context);

  final List<Map<String, dynamic>> data;
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final rowData = data[index];

    // Adjust the font size based on screen width using media query
    double fontSize = MediaQuery.of(context).size.width * 0.012;

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            rowData['Roll no'].toString(),
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        DataCell(
          Text(
            rowData['Teacher name'],
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        DataCell(
          Text(
            rowData['School name'],
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        DataCell(
          Text(
            rowData['Block'],
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        DataCell(
          Text(
            rowData['View'],
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
