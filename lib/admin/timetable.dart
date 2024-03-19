import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numsai/admin/displayTimetable.dart';
import 'dart:convert';

class TimetableScreen extends StatefulWidget {
  // const TimetableScreen({super.key});
  //newpg
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  State<TimetableScreen> createState() => _TimetableState();
}

class _TimetableState extends State<TimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _classText = TextEditingController(text: '');
  final TextEditingController _sectionText = TextEditingController(text: '');
  final TextEditingController _subjectText = TextEditingController(text: '');
  final TextEditingController _startTimeText = TextEditingController(text: '');
  final TextEditingController _endTimeText = TextEditingController(text: '');
  final TextEditingController _roomText = TextEditingController(text: '');
  final TextEditingController _teacherText = TextEditingController(text: '');
  final TextEditingController _dayText = TextEditingController(text: '');
  // String _class = "";
  // String section = "";
  // String subject = "";
  // String startTime = "";
  // String endTime = "";
  // String room = "";
  // String teacher = "";
  // String day = "";
  bool _isLoading = false;
  // Map<String, Map<String, Map<String, Map<String, String>>>> tt = {};
  Map<String, dynamic> tt = {};
  //newpg
  void updateTT(Map<String, dynamic> updatedTT) {
    setState(() {
      tt = updatedTT;
    });
  }
  
  @override
  void initState() {
    // loadBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'timetable'.tr),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: 
                  Container(
                    constraints: BoxConstraints(minHeight: 0, minWidth: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Add a cell",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: UtilsWidgets.textFormField(
                                context,
                                "Enter the class",
                                'Eg. VI',
                                (p0) {
                                  if (p0 == null || p0.isEmpty)
                                    return 'please'.tr + "enter the class";
                                },
                                _classText,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: UtilsWidgets.textFormField(
                                context,
                                "Enter the section",
                                "Eg. A",
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please'.tr + "enter the section";
                                  }
                                },
                                _sectionText,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              // flex: 1,
                              child: UtilsWidgets.textFormField(
                                context,
                                "Enter the start time",
                                'Eg. 9:00 AM',
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please'.tr + "enter the start time";
                                  }
                                },
                                _startTimeText,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              // flex: 1,
                              child: UtilsWidgets.textFormField(
                                context,
                                'Enter the end time',
                                'Eg. 3:00 AM',
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please'.tr + "enter the end time";
                                  }
                                },
                                _endTimeText,
                              ),
                            ),
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              // flex: 1,
                              child: UtilsWidgets.textFormField(
                                context,
                                "Enter the subject",
                                'Eg. Science',
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please' + "enter the subject";
                                  }
                                },
                                _subjectText,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              // flex: 1,
                              child: UtilsWidgets.textFormField(
                                context,
                                "Enter the room",
                                'Eg. 5',
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please' + "enter the room";
                                  }
                                },
                                _roomText,
                              ),
                            ),
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              // flex: 1,
                              child: UtilsWidgets.textFormField(
                                context,
                                "Enter the teacher",
                                'Eg. Manoj',
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please' + "enter the teacher";
                                  }
                                },
                                _teacherText,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              // flex: 1,
                              child: UtilsWidgets.textFormField(
                                context,
                                "Enter the day",
                                'Eg. Monday',
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please' + "enter the day";
                                  }
                                },
                                _dayText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : UtilsWidgets.buildRoundBtn('add'.tr + "/" + 'update'.tr, () async {
                        if (_formKey.currentState!.validate()) {
                          UtilsWidgets.bottomDialogs(
                              'addalert'.tr + '/' + 'update'.tr, 
                              'alert'.tr,
                              'cancel'.tr, 
                              'submit'.tr,
                              context, () {
                            Navigator.of(context).pop();
                          }, () {
                            addCell();
                            Navigator.of(context).pop();
                          });
                        }
                      }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableWidget(tt: tt),
                      ),
                    );
                  },
                  child: Text('Print Table'),
                ),
              ],
            )),
      ),
    );
  }

  // Future<String> loadBlock() async {
    
  // }

  // getOfflineData() async {
    
  // }

  void addCell() {
    
    String className = _classText.text;
    String sectionName = _sectionText.text;
    String dayName = _dayText.text;
    String intimeKey = _startTimeText.text;
    
    // Create a new map for the cell data
    Map<String, String> cellData = {
      'subject': _subjectText.text,
      'endTime': _endTimeText.text,
      'room': _roomText.text,
      'teacher': _teacherText.text,
    };

      setState(() {
      // Check if the class already exists in the tt map
      if (tt.containsKey(className)) {
        // If the class already exists, get its corresponding section map
        Map<String, dynamic> classMap = tt[className]!;
        
        // Check if the section already exists in the class map
        if (classMap.containsKey(sectionName)) {
          // If the section already exists, get its corresponding day map
          Map<String, dynamic> sectionMap = classMap[sectionName]!;
          
          // Check if the day already exists in the section map
          if (sectionMap.containsKey(dayName)) {
            // If the day already exists, get its corresponding intime map
            Map<String, dynamic> intimeMap = sectionMap[dayName]![intimeKey] ?? {};
            
            // Update or add the cell data to the intime map
            intimeMap.addAll(cellData);
            
            // Update the intime map in the section map
            sectionMap[dayName]![intimeKey] = intimeMap;
          } else {
            // If the day doesn't exist, create a new day map and add it to the section map
            Map<String, dynamic> dayMap = {intimeKey: cellData};
            sectionMap[dayName] = dayMap;
          }
        } else {
          // If the section doesn't exist, create a new section map and add it to the class map
          Map<String, dynamic> dayMap = {intimeKey: cellData};
          Map<String, dynamic> sectionMap = {dayName: dayMap};
          classMap[sectionName] = sectionMap;
        }
      } else {
        // If the class doesn't exist, create a new class map and add it to tt
        Map<String, dynamic> dayMap = {intimeKey: cellData};
        Map<String, dynamic> sectionMap = {dayName: dayMap};
        tt[className] = {sectionName: sectionMap};
      }
    });
    updateTT(tt);
    print("$tt");
  }


}

//////////////////////////////////////////////////////////////////////////////////////////////

















// import 'package:flutter/material.dart';
// import 'package:numsai/utils/widget_utils.dart';
// import 'package:numsai/utils/local_string.dart';
// import 'package:get/get.dart';

// class TimetableScreen extends StatefulWidget {
//   const TimetableScreen({super.key});
//   @override
//   State<TimetableScreen> createState() => _TimetableState();
// }
// class _TimetableState extends State<TimetableScreen> {

//   List<Map> _books = [
//     {
//       'id': 100,
//       'title': 'Flutter Basics',
//       'author': 'David John'
//     },
//     {
//       'id': 102,
//       'title': 'Git and GitHub',
//       'author': 'Merlin Nick'
//     },
//     {
//       'id': 101,
//       'title': 'Flutter Basics',
//       'author': 'David John'
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: UtilsWidgets.buildAppBar(context, 'timetable'.tr),
//         body: ListView(
//           children: [
//             _createDataTable()
//           ],
//         ),
//       ),
//     );
//   }
// DataTable _createDataTable() {
//     return DataTable(columns: _createColumns(), rows: _createRows());
//   }
// List<DataColumn> _createColumns() {
//     return [
//       DataColumn(label: Text('ID')),
//       DataColumn(label: Text('Book')),
//       DataColumn(label: Text('Author')),
//       DataColumn(label: Text('Category'))
//     ];
//   }
// List<DataRow> _createRows() {
//     return _books
//         .map((book) => DataRow(cells: [
//               DataCell(Text('#' + book['id'].toString())),
//               DataCell(Text(book['title'])),
//               DataCell(Text(book['author'])),
//               DataCell(FlutterLogo())
//             ]))
//         .toList();
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:numsai/utils/widget_utils.dart';
// import 'package:numsai/constants.dart';

// class TimetableScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Example data for columns and rows
//     List<DataColumn> columns = [
//       DataColumn(label: Text('Monday', style: TextStyle(fontSize: 12))),
//       DataColumn(label: Text('Tuesday', style: TextStyle(fontSize: 12))),
//       DataColumn(label: Text('Wednesday', style: TextStyle(fontSize: 12))),
//       DataColumn(label: Text('Thursday', style: TextStyle(fontSize: 12))),
//       DataColumn(label: Text('Friday', style: TextStyle(fontSize: 12))),
//       DataColumn(label: Text('Saturday', style: TextStyle(fontSize: 12))),
//       DataColumn(label: Text('Sunday', style: TextStyle(fontSize: 12))),
//     ];

//     List<DataRow> rows = List.generate(5, (index) {
//       List<DataCell> cells = List.generate(7, (index) {
//         // This function generates a cell with edit icon and opens a dialog on icon tap
//         return DataCell(
//           InkWell(
//             onTap: () {
//               _showEditDialog(context);
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Intime',
//                   style: TextStyle(fontSize: 12), // Text size changed to 12px
//                 ),
//                 Text(
//                   'Outtime',
//                   style: TextStyle(fontSize: 12), // Text size changed to 12px
//                 ),
//                 Text(
//                   'Subject',
//                   style: TextStyle(fontSize: 12), // Text size changed to 12px
//                 ),
//                 Text(
//                   'Room',
//                   style: TextStyle(fontSize: 12), // Text size changed to 12px
//                 ),
//                 Text(
//                   'Teacher',
//                   style: TextStyle(fontSize: 12), // Text size changed to 12px
//                 ),
//                 Icon(Icons.edit),
//               ],
//             ),
//           ),
//         );
//       });

//       return DataRow(cells: cells);
//     });

//     return drawTable(columns, rows, columnIndex: 0);
//   }

//   // Function to show the edit dialog
//   void _showEditDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Timetable Entry'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Intime'),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Outtime'),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Subject'),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Room'),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Teacher'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// Widget drawTable(List<DataColumn> columns, List<DataRow> rows,
//       {bool sort = true, int columnIndex = 0}) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: DataTable(
//             sortColumnIndex: columnIndex,
//             sortAscending: sort,
//             showBottomBorder: true,
//             dataTextStyle: const TextStyle(
//               color: Colors.black,
//             ),
//             headingTextStyle: const TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.bold),
//             columnSpacing: 15,
//             headingRowColor: MaterialStateColor.resolveWith((states) {
//               return Constants.primaryColor;
//             }),
//             columns: columns,
//             rows: rows.map((row) {
//               return DataRow(
//                 cells: row.cells.map((cell) {
//                   return DataCell(
//                     Container(
//                       width: 200,
//                       constraints: BoxConstraints(
// 						minHeight: 200,
// 					  ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: cell.child is Widget
//                             ? [cell.child as Widget]
//                             : [Text(cell.child.toString())],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               );
//             }).toList()),
//       ),
//     );
//   }