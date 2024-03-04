import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';

class UpdateTeacher extends StatefulWidget {
  final String id;
  final bool transfer;
  const UpdateTeacher({super.key, required this.id, required this.transfer});

  @override
  State<UpdateTeacher> createState() => _UpdateTeacherState();
}

class _UpdateTeacherState extends State<UpdateTeacher> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameText = TextEditingController(text: '');
  final TextEditingController _mobileText = TextEditingController(text: '');
  final TextEditingController _aadharText = TextEditingController(text: '');
  final TextEditingController _categoryText = TextEditingController(text: '');
  final TextEditingController _religionText = TextEditingController(text: '');
  final TextEditingController _casteText = TextEditingController(text: '');
  final TextEditingController _subcasteText = TextEditingController(text: '');
  final TextEditingController _addressText = TextEditingController(text: '');
  final TextEditingController _bankNameText = TextEditingController(text: '');
  final TextEditingController _accountNameText =
      TextEditingController(text: '');
  final TextEditingController _accountNoText = TextEditingController(text: '');
  final TextEditingController _IFSCText = TextEditingController(text: '');
  final TextEditingController _dobDateText =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _serviceJoinText =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _schoolJoinText =
      TextEditingController(text: DateTime.now().toString());
  List jobList = ["Contract", "Permanant", "Guest"];
  String jobName = "";
  // List statusList = ["active", "droped", "transfer", "alumia"];
  // String statusName = "";
  String gender = "Male";
  String userID = "";
  List blockList = [];
  String blockName = "";
  List clusterList = [];
  String clusterName = "";
  List schoolList = [];
  List schoolId = [];
  String schoolName = "";
  String udise = "";
  String district = "";
  String schoolTime = "";
  bool _isConnected = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _istransfer = false;
  Map programData = {};

  @override
  void initState() {
    _istransfer = widget.transfer;
    getOfflineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(
          context, _istransfer ? 'transferteacher'.tr : 'updateteacher'.tr),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Form(
              key: _formKey,
              child: _isUploading
                  ? Column(
                      children: [
                        SizedBox(height: 10),
                        _istransfer
                            ? Column(
                                children: [
                                  UtilsWidgets.kayValueWidget(
                                      'teachername'.tr, _nameText.text, context),
                                  UtilsWidgets.kayValueWidget(
                                      'mobile'.tr, _mobileText.text, context),
                                  UtilsWidgets.searchAbleDropDown(
                                      context,
                                      blockList,
                                      blockName,
                                      'chooseblock'.tr,
                                      blockName,
                                      const Icon(Icons.search),
                                      (value) {
                                        if (value != null) {
                                          setState(() {
                                            blockName = value;
                                            clusterList.clear();
                                            Map tempMap = {};
                                            tempMap = programData[blockName];
                                            tempMap.forEach((clust, value) {
                                              clusterList.add(clust);
                                            });
                                          });
                                        }
                                      },
                                      'chooseblock'.tr,
                                      Colors.black,
                                      'chooseblock'.tr,
                                      (value) {
                                        if (value == 'chooseblock'.tr ||
                                            value == null ||
                                            value.toString().isEmpty) {
                                          return 'please'.tr + 'chooseblock'.tr;
                                        }
                                        return null;
                                      }),
                                  UtilsWidgets.searchAbleDropDown(
                                      context,
                                      clusterList,
                                      clusterName,
                                      'choosecluster'.tr,
                                      clusterName,
                                      const Icon(Icons.search),
                                      (value) {
                                        if (value != null) {
                                          setState(() {
                                            clusterName = value;
                                            schoolList.clear();
                                            schoolList.clear();
                                            Map tempMap = {};
                                            tempMap = programData[blockName]
                                                [clusterName];
                                            tempMap.forEach((id, name) {
                                              schoolList.add(name);
                                              schoolId.add(id);
                                            });
                                          });
                                        }
                                      },
                                      'choosecluster'.tr,
                                      Colors.black,
                                      'choosecluster'.tr,
                                      (value) {
                                        if (value == 'choosecluster'.tr ||
                                            value == null ||
                                            value.toString().isEmpty) {
                                          return 'please'.tr + 'choosecluster'.tr;
                                        }
                                        return null;
                                      }),
                                  UtilsWidgets.searchAbleDropDown(
                                      context,
                                      schoolList,
                                      schoolName,
                                      'chooseschool'.tr,
                                      schoolName,
                                      const Icon(Icons.search),
                                      (value) {
                                        if (value != null) {
                                          setState(() {
                                            schoolName = value;
                                            udise = schoolId[
                                                schoolList.indexOf(schoolName)];
                                          });
                                        }
                                      },
                                      'chooseschool'.tr,
                                      Colors.black,
                                      'chooseschool'.tr,
                                      (value) {
                                        if (value == 'chooseschool'.tr ||
                                            value == null ||
                                            value.toString().isEmpty) {
                                          return 'please'.tr + 'chooseschool'.tr;
                                        }
                                        return null;
                                      }),
                                ],
                              )
                            : Column(
                                children: [
                                  UtilsWidgets.textFormField(
                                    context,
                                    'tnametf'.tr,
                                    "Eg. Rohan Thakur",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + "tnametf".tr;
                                      }
                                    },
                                    _nameText,
                                  ),
                                  UtilsWidgets.textFormField(
                                    context,
                                    "tmobiletf".tr,
                                    'Eg. 9876543211',
                                    textInputType: TextInputType.phone,
                                    (p0) {
                                      if (p0 == null || p0.isEmpty)
                                        return 'please'.tr + "tmobiletf".tr;
                                      else if (Utils.validateMobile(
                                          p0.toString())) {
                                        return "mobilevtf".tr;
                                      }
                                    },
                                    _mobileText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  UtilsWidgets.textFormField(
                                    context,
                                    "taadhaartf".tr,
                                    "Eg. 1234 1234 1234",
                                    (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'please'.tr + "taadhaartf".tr;
                                      } else if (_aadharText.text.length != 12) {
                                        return "aadhaarvtf".tr;
                                      }
                                    },
                                    _aadharText,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  UtilsWidgets.buildDatePicker(
                                    'dobtf'.tr,
                                    'dobtf'.tr,
                                    _dobDateText,
                                    (val) {},
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  ),
                                  UtilsWidgets.decorContainer('choosegender'.tr, [
                                    Row(
                                      children: [
                                        Radio(
                                            value: "Male",
                                            groupValue: gender,
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            }),
                                        Text('gendermale'.tr)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                            value: "Female",
                                            groupValue: gender,
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            }),
                                        Text('genderfemale'.tr)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                            value: "Other",
                                            groupValue: gender,
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            }),
                                        Text('genderother'.tr)
                                      ],
                                    ),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      maintainState: true,
                                      title: Text(
                                        'castedetails'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      leading: const Icon(
                                        Icons.trip_origin,
                                        color: Colors.black,
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.40,
                                                child:
                                                    UtilsWidgets.textFormField(
                                                  context,
                                                  'choosecategory'.tr,
                                                  'choosecategory'.tr,
                                                  (p0) {
                                                    if (p0 == null ||
                                                        p0.isEmpty) {
                                                      return "please".tr + "choosecategory".tr;
                                                    }
                                                  },
                                                  _categoryText,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.40,
                                                child:
                                                    UtilsWidgets.textFormField(
                                                  context,
                                                  'choosereligion'.tr,
                                                  'choosereligion'.tr,
                                                  (p0) {
                                                    if (p0 == null ||
                                                        p0.isEmpty) {
                                                      return "please".tr + 'choosereligion'.tr;
                                                    }
                                                  },
                                                  _religionText,
                                                ),
                                              )
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.40,
                                                child:
                                                    UtilsWidgets.textFormField(
                                                  context,
                                                  "caste".tr,
                                                  "caste".tr,
                                                  (p0) {
                                                    if (p0 == null ||
                                                        p0.isEmpty) {
                                                      return "please".tr + "caste".tr;
                                                    }
                                                  },
                                                  _casteText,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  child: UtilsWidgets
                                                      .textFormField(
                                                    context,
                                                    "Sub-caste",
                                                    "Sub-caste",
                                                    (p0) {
                                                      if (p0 == null ||
                                                          p0.isEmpty) {
                                                        return "Please Enter sub-caste";
                                                      }
                                                    },
                                                    _subcasteText,
                                                  ))
                                            ]),
                                      ],
                                    ),
                                  ),
                                  UtilsWidgets.buildDatePicker(
                                    'servicejointf'.tr,
                                    'servicejointf'.tr,
                                    _serviceJoinText,
                                    (val) {},
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  ),
                                  UtilsWidgets.buildDatePicker(
                                    'schooljointf'.tr,
                                    'schooljointf'.tr,
                                    _schoolJoinText,
                                    (val) {},
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  ),
                                  UtilsWidgets.textFormField(
                                      context,
                                      'teacheraddress'.tr,
                                      'teacheraddress'.tr, 
                                      (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return 'please'.tr + 'teacheraddress'.tr;
                                        }
                                      }, 
                                      _addressText, maxLine: 3
                                  ),
                                  SizedBox(height: 10),
                                  UtilsWidgets.dropDownButton(
                                      context,
                                      'jobtypetf'.tr,
                                      'jobtypetf'.tr,
                                      jobName,
                                      jobList,
                                      (p0) => setState(() {
                                            jobName = p0;
                                          }), validator: (p0) {
                                    if (jobName == '') {
                                      return "please".tr + "jobtypetf".tr;
                                    }
                                  }, holder: jobName),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      maintainState: true,
                                      title: Text(
                                        'bankdetails'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      leading: const Icon(
                                        Icons.assured_workload_outlined,
                                        color: Colors.black,
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      children: [
                                        UtilsWidgets.textFormField(
                                          context,
                                          "banknametf".tr,
                                          "Eg. bank",
                                          (p0) {
                                            if (p0 == null || p0.isEmpty) {
                                              return "please".tr + "banknametf".tr;
                                            }
                                          },
                                          _bankNameText,
                                        ),
                                        UtilsWidgets.textFormField(
                                          context,
                                          "accountholdertf".tr,
                                          "accountholdertf".tr,
                                          (p0) {
                                            if (p0 == null || p0.isEmpty) {
                                              return "please".tr + "accountholdertf".tr;
                                            }
                                          },
                                          _accountNameText,
                                        ),
                                        UtilsWidgets.textFormField(
                                          context,
                                          "accountnumbertf".tr,
                                          "accountnumbertf".tr,
                                          (p0) {
                                            if (p0 == null || p0.isEmpty) {
                                              return "please".tr + "accountnumbertf".tr;
                                            }
                                          },
                                          _accountNoText,
                                        ),
                                        UtilsWidgets.textFormField(
                                          context,
                                          "ifsctf".tr,
                                          "ifsctf".tr,
                                          (p0) {
                                            if (p0 == null || p0.isEmpty) {
                                              return "please".tr + "ifsctf".tr;
                                            }
                                          },
                                          _IFSCText,
                                        )
                                      ],
                                    ),
                                  ),
                                  // UtilsWidgets.dropDownButton(context,
                                  //     'Choose status',
                                  //     'Choose status',
                                  //     statusName,
                                  //     statusList,
                                  //     (p0) => setState(() {
                                  //           statusName = p0;
                                  //         }), validator: (p0) {
                                  //   if (statusName == '') {
                                  //     return "Please choose status";
                                  //   }
                                  // }, holder: statusName),
                                ],
                              ),
                        SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : UtilsWidgets.buildRoundBtn(
                                _istransfer
                                    ? 'transfer'.tr
                                    : 'updateteacher'.tr, () async {
                                if (_formKey.currentState!.validate()) {
                                  UtilsWidgets.bottomDialogs(
                                      'addalert'.tr, 
                                      'alert'.tr,
                                      'cancel'.tr, 
                                      'submit'.tr, 
                                      context, () {
                                    Navigator.of(context).pop();
                                  }, () {
                                    updateTeacher();
                                    Navigator.of(context).pop();
                                  });
                                }
                              }),
                        SizedBox(height: 20),
                      ],
                    )
                  : UtilsWidgets.showProgressDialog()),
        ),
      ),
    );
  }

  getOfflineData() async {
    loadProgram();
    await teacherInfo();
  }

  loadProgram() async {
    var data = await rootBundle.loadString("assets/json/HVX.json");
    setState(() {
      programData = json.decode(data);
      programData.forEach((key, value) {
        blockList.add(key);
      });
    });
    return "success";
  }

  Future teacherInfo() async {
    setState(() {
      _isUploading = false;
    });
    String uri = Constants.TEACHER_URL + '/teacherdetails';
    Map params = {
      "userId": widget.id,
    };
    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map teacherMap = jsonDecode(response.body);
          Map<String, dynamic> infoMap = teacherMap['info'];
          _nameText.text = infoMap['teacherName'] ?? "";
          _mobileText.text = infoMap['mobile'] ?? "";
          _aadharText.text = infoMap['aadhaar'] ?? "";
          _dobDateText.text = infoMap['dob'];
          _serviceJoinText.text = infoMap['JoiningDate']['serviceJoin'];
          _schoolJoinText.text = infoMap['JoiningDate']['currentSchool'];
          gender = infoMap['gender'] ?? "Male";
          blockName = infoMap['block'] ?? "";
          clusterList.clear();
          Map blockMap = {};
          blockMap = programData[blockName];
          blockMap.forEach((clust, value) {
            clusterList.add(clust);
          });
          ///////////////////////////
          clusterName = infoMap['cluster'] ?? "";
          schoolList.clear();
          schoolList.clear();
          Map clusterMap = {};
          clusterMap = programData[blockName][clusterName];
          clusterMap.forEach((id, name) {
            schoolList.add(name);
            schoolId.add(id);
          });
          schoolName = schoolList[schoolId.indexOf(infoMap['udise'])];
          gender = infoMap['gender'] ?? "";
          jobName = infoMap['natureAppointment'] ?? "";
          _bankNameText.text = infoMap['bankDetails']['bankName'] ?? "";
          _accountNameText.text = infoMap['bankDetails']['accountName'] ?? "";
          _accountNoText.text = infoMap['bankDetails']['accountNo'] ?? "";
          _IFSCText.text = infoMap['bankDetails']['IFSC'] ?? "";
          _addressText.text = infoMap['address'] ?? "";
          _categoryText.text = infoMap['category'] ?? "";
          _religionText.text = infoMap['religion'] ?? "";
          _casteText.text = infoMap['scaste'] ?? "";
          _subcasteText.text = infoMap['subCaste'] ?? "";
          _isUploading = true;
        });
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future updateTeacher() async {
    String uri = '';
    Map params = {};
    setState(() {
      if (_istransfer) {
        uri = Constants.TEACHER_URL + '/teachertransfer';
        params = {
          'district': district,
          'cluster': clusterName,
          'block': blockName,
          "userId": widget.id,
          'udise': schoolId[schoolList.indexOf(schoolName)],
          'schoolName': schoolName,
          'mobile': _mobileText.text,
          "teacherName": _nameText.text,
          'status': 'Pending',
        };
      } else {
        uri = Constants.TEACHER_URL + '/updateteacher';
        params = {
          "userId": widget.id,
          'gender': gender,
          'mobile': _mobileText.text,
          "teacherName": _nameText.text,
          'dob':
              Utils.formatDate(DateTime.parse(_dobDateText.text), 'yyyy-MM-dd'),
          'aadhaar': _aadharText.text,
          'schoolTime': schoolTime,
          "activeStatus": "active",
          'role': 'Teacher',
          "currentSchool": Utils.formatDate(
              DateTime.parse(_schoolJoinText.text), 'yyyy-MM-dd'),
          "serviceJoin": Utils.formatDate(
              DateTime.parse(_serviceJoinText.text), 'yyyy-MM-dd'),
          'bankName': _bankNameText.text,
          'accountName': _accountNameText.text,
          'accountNo': _accountNoText.text,
          'IFSC': _IFSCText.text,
          "natureAppointment": jobName,
          "address": _addressText.text,
          "category": _categoryText.text,
          "religion": _religionText.text,
          "scaste": _casteText.text,
          "subCaste": _subcasteText.text,
        };
      }
    });

    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map infoMap = jsonDecode(response.body);
          UtilsWidgets.showGetDialog(context, infoMap['message'], Colors.green);
        });
      } else {
        UtilsWidgets.showToastFunc('Server Error ${response.statusCode}');
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
