//reset tt not working

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:numsai/utils/local_string.dart';
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
  List daysList = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List classList = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'];
  List sectionList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  bool _isLoading = false;
  String startTime = "";
  String endTime = "";
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
    super.initState();
    _getStoredTT();
  }

  Future<void> _getStoredTT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ttJson = prefs.getString('tt');

    // Check if ttJson is not null
    if (ttJson != null) {
      // Convert the JSON string back to a nested map
      Map<String, dynamic> fetchedtt = json.decode(ttJson);
      // Now you can use tt as your nested map
      setState(() {
        // Set the retrieved nested map to a state variable for use in your widget
        // Example:
        setState(() {
          tt = fetchedtt;
        });
      });
    }
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
                            child: UtilsWidgets.searchAbleDropDown(
                              context,
                              classList,
                              'class'.tr,
                              'chooseclass'.tr,
                              'class'.tr,
                              const Icon(Icons.search),
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _classText.text = value;
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
                            )
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: UtilsWidgets.searchAbleDropDown(
                              context,
                              sectionList,
                              'section'.tr,
                              'choosesection'.tr,
                              'section'.tr,
                              const Icon(Icons.search),
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _sectionText.text = value;
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
                            )
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 20),
                          Expanded(
                            child: Column(
                              children: [
                                UtilsWidgets.buildSqureBtn(
                                  'starttime'.tr,
                                  () async {
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    setState(() {
                                      _startTimeText.text = Utils.formatTimeOfDay(pickedTime!);
                                    });
                                  },
                                  Constants.primaryColor,
                                  Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _startTimeText.text.isNotEmpty ? _startTimeText.text : 'choosestarttime'.tr,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: Column(
                              children: [
                                UtilsWidgets.buildSqureBtn(
                                  'endtime'.tr,
                                  () async {
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      barrierDismissible: false,
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    setState(() {
                                      _endTimeText.text = Utils.formatTimeOfDay(pickedTime!);
                                    });
                                  },
                                  Constants.primaryColor,
                                  Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _endTimeText.text.isNotEmpty ? _endTimeText.text : 'chooseendtime'.tr,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
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
                              "entersubject".tr,
                              'Eg. Science',
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'please'.tr + "entersubject".tr;
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
                              "enterroom".tr,
                              'Eg. 5',
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'please'.tr + "enterroom".tr;
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
                              "enterteachername".tr,
                              'Eg. Manoj',
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'please'.tr + "enterteachername".tr;
                                }
                              },
                              _teacherText,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            // flex: 1,
                            child: 
                            UtilsWidgets.searchAbleDropDown(
                              context,
                              daysList,
                              'days'.tr,
                              'chooseday'.tr,
                              'days'.tr,
                              const Icon(Icons.search),
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _dayText.text = value;
                                  });
                                }
                              },
                              'chooseday'.tr,
                              Colors.black,
                              'chooseday'.tr,
                              (value) {
                                if (value == 'chooseday'.tr ||
                                    value == null ||
                                    value.toString().isEmpty) {
                                  return 'please'.tr + 'chooseday'.tr;
                                }
                                return null;
                              }
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 40),
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
              UtilsWidgets.buildRoundBtn('print'.tr + 'timetable'.tr, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TableWidget(tt: tt),
                    ),
                  );
                }
              ),
              SizedBox(height: 20),
              // UtilsWidgets.buildRoundBtn('Reset' + ' ' + 'timetable'.tr, () {
              //     UtilsWidgets.bottomDialogs(
              //       'Are you sure', 
              //       'alert'.tr,
              //       'cancel'.tr, 
              //       'submit'.tr,
              //       context, 
              //       () {
              //         Navigator.of(context).pop();
              //       },
              //       () async {
              //         SharedPreferences prefs = await SharedPreferences.getInstance();
              //         await prefs.remove('tt');
              //         Navigator.of(context).pop();
              //       }
              //     );
              //   }
              // ),
            ],
          )
        ),
      ),
    );
  }

  // Future<String> loadBlock() async {
    
  // }

  // getOfflineData() async {
    
  // }

  void addCell() async {
    
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

    // Store the tt string locally using shared preferences
    String ttJson = json.encode(tt);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tt', ttJson);

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