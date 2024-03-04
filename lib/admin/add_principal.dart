import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/method_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPrincipal extends StatefulWidget {
  const AddPrincipal({super.key});

  @override
  State<AddPrincipal> createState() => _AddPrincipalState();
}

class _AddPrincipalState extends State<AddPrincipal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameText = TextEditingController(text: '');
  final TextEditingController _mobileText = TextEditingController(text: '');
  final TextEditingController _aadharText = TextEditingController(text: '');
  // final TextEditingController _categoryText = TextEditingController(text: '');
  // final TextEditingController _religionText = TextEditingController(text: '');
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
  String gender = "Male";
  String userID = "";
  String userNumber = "";
  String userLevel = "";
  List categoryList = ["Open", "OBC", "SC", "ST", "EWS", "NT", "Others"];
  String categoryName = "";
  List religionList = [
    "Hindu",
    "Islam",
    "Christian",
    "Sikh",
    "Buddha",
    "Jain",
    "Zoroastrian",
    "Juda",
    "Bahá'í Faith",
    "Indigenous religions and tribal faiths",
    "Others"
  ];
  String religionName = "";
  List blockList = [];
  String blockName = "";
  List clusterList = [];
  String clusterName = "";
  List schoolList = [];
  List schoolId = [];
  String schoolName = "";
  String udise = "";
  String district = "";
  String cluster = "";
  String block = "";
  String schoolTime = "";
  bool _isConnected = false;
  bool _isLoading = false;
  bool isUploading = false;
  File? _file;
  PlatformFile? _platformFile;
  bool isUploading1 = false;
  File? _file1;
  PlatformFile? _platformFile1;
  Map blockData = {};

  @override
  void initState() {
    loadBlock();
    super.initState();
  }

  onClear() {
    setState(() {
      _nameText.clear();
      _mobileText.clear();
      _aadharText.clear();
      _addressText.clear();
      _casteText.clear();
      _bankNameText.clear();
      _accountNameText.clear();
      _accountNoText.clear();
      _IFSCText.clear();
      _subcasteText.text = '';
      _dobDateText.text = DateTime.now().toString();
      _serviceJoinText.text = DateTime.now().toString();
      _schoolJoinText.text = DateTime.now().toString();
      isUploading1 = false;
      isUploading = false;
      // _file1!.delete();
      // _file!.delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar(context, 'teacheradd'.tr),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                UtilsWidgets.textFormField(
                  context,
                  "tnametf".tr,
                  "Eg. Rohan Thakur",
                  (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'please'.tr + "tnametf".tr;
                    }
                  },
                  _nameText,
                  inputFormatter: Utils.onlyAlpha(),
                ),
                UtilsWidgets.textFormField(
                  context,
                  "tmobiletf".tr,
                  'Eg. 9876543211',
                  (p0) {
                    if (p0 == null || p0.isEmpty)
                      return 'please'.tr + "tmobiletf".tr;
                    else if (Utils.validateMobile(p0.toString())) {
                      return "mobilevtf".tr;
                    }
                  },
                  _mobileText,
                  textInputType: TextInputType.phone,
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
                  textInputType: TextInputType.phone,
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
                      Text('Male')
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
                      Text('Female')
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
                      Text('Other')
                    ],
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ExpansionTile(
                    maintainState: true,
                    initiallyExpanded: true,
                    title: Text(
                      'castedetails'.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    leading: const Icon(
                      Icons.trip_origin,
                      color: Colors.black,
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.48,
                            child: UtilsWidgets.dropDownButton(
                              context,
                              'choosereligion'.tr,
                              'choosereligion'.tr,
                              religionName,
                              religionList,
                              (p0) => setState(() {
                                religionName = p0;
                              }),
                              validator: (p0) {
                                if (religionName == '') {
                                  return "please".tr + 'choosereligion'.tr;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: UtilsWidgets.dropDownButton(
                              context,
                              'choosecategory'.tr,
                              'choosecategory'.tr,
                              categoryName,
                              categoryList,
                              (p0) => setState(() {
                                categoryName = p0;
                              }),
                              validator: (p0) {
                                if (categoryName == '') {
                                  return "please".tr + "choosecategory".tr;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: UtilsWidgets.textFormField(
                                context,
                                "caste".tr,
                                "caste".tr,
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "caste".tr;
                                  }
                                },
                                _casteText,
                                inputFormatter: Utils.onlyAlpha(),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: UtilsWidgets.textFormField(
                                  context,
                                  "subcaste".tr,
                                  "subcaste".tr,
                                  (p0) {
                                    // if (p0 == null || p0.isEmpty) {
                                    //   return "Please Enter sub-caste";
                                    // }
                                  },
                                  _subcasteText,
                                  inputFormatter: Utils.onlyAlpha(),
                                ))
                          ]),
                    ],
                  ),
                ),
                Column(
                  children: [
                    userLevel == 'district'
                        ? UtilsWidgets.searchAbleDropDown(
                            context,
                            blockList,
                            blockName,
                            'Choose block',
                            blockName,
                            const Icon(Icons.search),
                            (value) {
                              if (value != null) {
                                setState(() {
                                  blockName = value;
                                  clusterList.clear();
                                  Map tempMap = {};
                                  tempMap = blockData[blockName];
                                  tempMap.forEach((clust, value) {
                                    clusterList.add(clust);
                                  });
                                });
                              }
                            },
                            'Choose block',
                            Colors.black,
                            'Choose block',
                            (value) {
                              if (value == 'Choose block' ||
                                  value == null ||
                                  value.toString().isEmpty) {
                                return 'Please Choose block';
                              }
                              return null;
                            })
                        : Container(),
                    userLevel == 'district' || userLevel == 'block'
                        ? UtilsWidgets.searchAbleDropDown(
                            context,
                            clusterList,
                            clusterName,
                            'Choose cluster',
                            clusterName,
                            const Icon(Icons.search),
                            (value) {
                              if (value != null) {
                                setState(() {
                                  clusterName = value;
                                  schoolList.clear();
                                  schoolList.clear();
                                  Map tempMap = {};
                                  tempMap = blockData[blockName][clusterName];
                                  tempMap.forEach((id, name) {
                                    schoolList.add(name);
                                    schoolId.add(id);
                                  });
                                });
                              }
                            },
                            'Choose cluster',
                            Colors.black,
                            'Choose cluster',
                            (value) {
                              if (value == 'Choose cluster' ||
                                  value == null ||
                                  value.toString().isEmpty) {
                                return 'Please Choose cluster';
                              }
                              return null;
                            })
                        : Container(),
                    UtilsWidgets.searchAbleDropDown(
                        context,
                        schoolList,
                        schoolName,
                        'Choose school',
                        schoolName,
                        const Icon(Icons.search),
                        (value) {
                          if (value != null) {
                            setState(() {
                              schoolName = value;
                              udise = schoolId[schoolList.indexOf(schoolName)];
                            });
                          }
                        },
                        'Choose school',
                        Colors.black,
                        'Choose school',
                        (value) {
                          if (value == 'Choose school' ||
                              value == null ||
                              value.toString().isEmpty) {
                            return 'Please Choose school';
                          }
                          return null;
                        })
                  ],
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
                    context, "residentaddresstf".tr, "residentaddresstf".tr,
                    (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return "please".tr + "residentaddresstf".tr;
                  }
                }, _addressText, maxLine: 3),
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
                }),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ExpansionTile(
                    maintainState: true,
                    initiallyExpanded: true,
                    title: Text(
                      'bankdetails'.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    leading: const Icon(
                      Icons.assured_workload_outlined,
                      color: Colors.black,
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    children: [
                      UtilsWidgets.textFormField(
                        context,
                        "banknametf".tr,
                        "banknametf".tr,
                        (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "please".tr + "banknametf".tr;
                          }
                        },
                        _bankNameText,
                        inputFormatter: Utils.onlyAlpha(),
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
                        inputFormatter: Utils.onlyAlpha(),
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
                isUploading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UtilsWidgets.buildIconBtn(_platformFile!.name,
                                    Icon(Icons.image), () {}, Colors.purple),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _file!.delete();
                                        isUploading = false;
                                      });
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UtilsWidgets.buildIconBtn(
                              'uploadaadhaarcard'.tr,
                              Icon(
                                Icons.upload_file,
                                color: Color.fromARGB(255, 9, 78, 135),
                              ), () {
                            getAadhaar();
                          }, Color.fromARGB(255, 9, 78, 135))
                        ],
                      ),
                isUploading1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UtilsWidgets.buildIconBtn(_platformFile1!.name,
                                    Icon(Icons.image), () {}, Colors.purple),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _file1!.delete();
                                        isUploading1 = false;
                                      });
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UtilsWidgets.buildIconBtn(
                              'uploadbankpassbook'.tr,
                              Icon(
                                Icons.upload_file,
                                color: Color.fromARGB(255, 9, 78, 135),
                              ), () {
                            getBank();
                          }, Color.fromARGB(255, 9, 78, 135))
                        ],
                      ),
                SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : UtilsWidgets.buildRoundBtn("teacheradd".tr, () async {
                        if (_formKey.currentState!.validate()) {
                          UtilsWidgets.bottomDialogs("addalert".tr, 'alert'.tr,
                              'cancel'.tr, 'submit'.tr, context, () {
                            Navigator.of(context).pop();
                          }, () {
                            addTeacher();
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

  Future<String> loadBlock() async {
    var data = await rootBundle.loadString("assets/json/HVX.json");
    setState(() {
      blockData = json.decode(data);
      blockData.forEach((key, value) {
        blockList.add(key);
      });
    });
    getOfflineData();
    return "success";
  }

  getOfflineData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userLevel = pref.getString('level') ?? '';
      userID = pref.getString('id') ?? '';
      userNumber = pref.getString('number') ?? '';
      district = pref.getString('district') ?? '';
      district = pref.getString('district') ?? '';
      cluster = pref.getString('cluster') ?? '';
      block = pref.getString('block') ?? '';
      udise = pref.getString('udise') ?? '';
      schoolTime = pref.getString('schoolTime') ?? '';
      if (userLevel == 'block') {
        blockName = userID;
        clusterList.clear();
        Map tempMap = {};
        tempMap = blockData[blockName];
        tempMap.forEach((clust, value) {
          clusterList.add(clust);
        });
      } else if (userLevel == 'cluster') {
        blockName = pref.getString('block') ?? '';
        clusterName = userID;
        schoolList.clear();
        schoolList.clear();
        Map tempMap = {};
        tempMap = blockData[blockName][clusterName];
        tempMap.forEach((id, name) {
          schoolList.add(name);
          schoolId.add(id);
        });
      } else {}
    });
  }

  Future addTeacher() async {
    setState(() {
      _isLoading = true;
    });
    String uri = Constants.TEACHER_URL + '/createteacher';
    Map params = {
      'district': district,
      'block': userLevel == 'block' ? block : blockName,
      'cluster': userLevel == 'cluster' ? cluster : clusterName,
      'udise': udise,
      'gender': gender,
      'mobile': _mobileText.text,
      "teacherName": _nameText.text,
      'dob': Utils.formatDate(DateTime.parse(_dobDateText.text), 'yyyy-MM-dd'),
      'aadhaar': _aadharText.text,
      'schoolTime': schoolTime,
      "status": "active",
      'role': 'HM',
      "currentSchool":
          Utils.formatDate(DateTime.parse(_schoolJoinText.text), 'yyyy-MM-dd'),
      "serviceJoin":
          Utils.formatDate(DateTime.parse(_serviceJoinText.text), 'yyyy-MM-dd'),
      'bankName': _bankNameText.text,
      'accountName': _accountNameText.text,
      'accountNo': _accountNoText.text,
      'IFSC': _IFSCText.text,
      "natureAppointment": jobName,
      "address": _addressText.text,
      "category": categoryName,
      "religion": religionName,
      "scaste": _casteText.text,
      "subCaste": _subcasteText.text,
    };
    try {
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        setState(() {
          Map tempMap = jsonDecode(response.body);
          if (tempMap['isValid']) {
            UtilsWidgets.showGetDialog(
                context, tempMap['message'], Colors.green);
            onClear();
          } else {
            UtilsWidgets.showGetDialog(context, tempMap['message'], Colors.red);
          }
        });
        if (_platformFile != null) {
          Uint8List bytes = _platformFile!.bytes ?? Uint8List(0);
          await MethodUtils.uploadFile(
              block, cluster, udise, _aadharText.text, bytes);
        }
        if (_platformFile1 != null) {
          Uint8List bytes1 = _platformFile1!.bytes ?? Uint8List(0);
          await MethodUtils.uploadFile(
              block, cluster, udise, _accountNoText.text, bytes1);
        }
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

  getAadhaar() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        _file = File(result.files.single.path!);
        _platformFile = result.files.first;
        setState(() {
          isUploading = true;
        });
      }
    } catch (e) {
      // UtilsWidgets.showToastFunc(e);
    }
  }

  getBank() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        _file1 = File(result.files.single.path!);
        _platformFile1 = result.files.first;
        setState(() {
          isUploading1 = true;
        });
      }
    } catch (e) {
      // UtilsWidgets.showToastFunc(e);
    }
  }
}
