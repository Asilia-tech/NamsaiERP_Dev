import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoveSchool extends StatefulWidget {
  const RemoveSchool({super.key});

  @override
  State<RemoveSchool> createState() => _RemoveSchoolState();
}

class _RemoveSchoolState extends State<RemoveSchool> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _udiseText = TextEditingController(text: '');
  // final TextEditingController _districtText = TextEditingController(text: '');

  bool _isConnected = false;
  bool _isLoading = false;
  Map programData = {};
  List blockList = [];
  String msg = "";

  String udise = "";
  String endpoint = "";
  String schoolName = "";
  String block = "";
  String schoolAddress = "";
  String district = "";
  List<String> udiseList = [];

  @override
  void initState() {
    // getOfflineData();
    loadProgram();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'Remove School'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Light grey background color
                    borderRadius: BorderRadius.circular(
                        8), // Optional: Add rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Udise',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: UtilsWidgets.textFormField(
                          context,
                          "Enter Udise",
                          "Eg. 12180100101",
                          (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return "Please enter Udise";
                            }
                          },
                          _udiseText,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Schools',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: _formKey2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Expanded(
                                child: UtilsWidgets.textFormField(
                                  context,
                                  "Enter district",
                                  "Eg. Namsai",
                                  (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return "Please enter district";
                                    } else {
                                      setState(() {
                                        district = p0;
                                      });
                                    }
                                  },
                                  null,
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey2.currentState?.validate() ??
                                      false) {
                                    fetchUdiseList();
                                  }
                                },
                                child: Text('Show school list'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : UtilsWidgets.buildRoundBtn("Remove School", () async {
                        if (_formKey.currentState!.validate()) {
                          UtilsWidgets.bottomDialogs("Please review your input",
                              'Alert', 'Cancel', 'Submit', context, () {
                            Navigator.of(context).pop();
                          }, () {
                            removeSchool();
                            Navigator.of(context).pop();
                          });
                        }
                      }),
                SizedBox(height: 20),
              ],
            )),
      ),
    );
  }

  // getOfflineData() async {
  //   final connectivityResult = await Connectivity().checkConnectivity();
  //   final pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isConnected = connectivityResult != ConnectivityResult.none;
  //     district = pref.getString('district') ?? '';
  //   });
  //   loadProgram();
  // }

  loadProgram() async {
    var data = await rootBundle.loadString(".//HVX.json");
    setState(() {
      programData = json.decode(data);
      programData.forEach((key, value) {
        blockList.add(key);
      });
      print(blockList);
      print("                      ");
    });
    return "success";
  }

  Future removeSchool() async {
    setState(() {
      _isLoading = true;
    });
    String uri = Constants.SCHOOL_URL + "/removeschool";
    Map params = {
      'udise': _udiseText.text,
    };
    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map infoMap = jsonDecode(response.body);
          UtilsWidgets.showGetDialog(context, infoMap['message'], Colors.green);
          // print(infoMap['message']);
        });
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
        // print(response.statusCode);
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
      // print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future fetchUdiseList() async {
    setState(() {
      _isLoading = true;
    });
    String uri = Constants.SCHOOL_URL + "/udiselist";
    Map params = {
      'district': district,
    };
    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          if (jsonResponse['isValid'] == true) {
            List<dynamic> infoList = jsonResponse['info'];
            for (var info in infoList) {
              setState(() {
                udiseList.add(info['udise']);
              });
            }
            print(udiseList);
          } else {
            throw Exception('Failed to load Udise list');
          }
        });
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future schoolDetails(_udise) async {
    setState(() {
      _isLoading = true;
      schoolName = "";
      block = "";
      schoolAddress = "";
      // isFind = false;
    });
    try {
      String uri = Constants.SCHOOL_URL + "/schooldetails";
      Map params = {
        "udise": _udise,
      };
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        setState(() {
          Map<String, dynamic> info = tempMap['info'];

          if (info.isNotEmpty) {
            schoolName = info['schoolName'];
            block = info['block'];
            schoolAddress = info['schoolAddress'];
            // isFind = true;
          } else {
            msg = 'No school found. Please check your udise';
            // isFind = false;
          }
        });
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
