import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/method_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticePost extends StatefulWidget {
  const NoticePost({super.key});

  @override
  State<NoticePost> createState() => _NoticePostState();
}

class _NoticePostState extends State<NoticePost>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateText = TextEditingController();
  final TextEditingController _subjectText = TextEditingController();
  final TextEditingController _reasonText = TextEditingController();
  String userLevel = "";
  String userID = "";
  String userNumber = "";
  String teacherName = "";
  String udise = "";
  String district = "";
  List schoolId = [];
  List level1List = ["All", "admin", "school"];
  String level1Name = "";
  List level2List = [];
  String level2Name = "";
  List schoollevelList = ["All", "Teacher", "HM"];
  String schoollevelName = "";
  bool _isLoading = false;
  late AnimationController loadingController;
  PlatformFile? _platformFile;
  List<dynamic> blockList = [];
  String blockName = "";
  List<dynamic> clusterList = [];
  String clusterName = "";
  List<dynamic> schoolList = [];
  String schoolName = "";
  Map<String, dynamic> blockData = {};

  @override
  void initState() {
    loadBlock();
    loadingController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.48,
                          child: UtilsWidgets.dropDownButton(
                              context,
                              'chooselevel1'.tr,
                              'chooselevel1'.tr,
                              level1Name,
                              level1List, (p0) {
                            setState(() {
                              level1Name = p0;
                              if (level1Name == 'school') {
                                if (!level2List.contains('school')) {
                                  level2List.add('school');
                                }
                              } else if (level1Name == 'admin') {
                                if (level2List.contains('school')) {
                                  level2List.remove('school');
                                }
                              }
                            });
                          }, validator: (p0) {
                            if (level1Name == '') {
                              return "please".tr + 'chooselevel1'.tr;
                            }
                          })),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.52,
                        child: UtilsWidgets.buildDatePicker(
                          'noticepostdate'.tr,
                          'noticepostdate'.tr,
                          _startDateText,
                          (val) {},
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 1),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      level1Name != 'All'
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.48,
                              child: UtilsWidgets.dropDownButton(
                                  context,
                                  'chooselevel2'.tr,
                                  'chooselevel2'.tr,
                                  level2Name,
                                  level2List, (p0) {
                                setState(() {
                                  level2Name = p0;
                                });
                              }, validator: (p0) {
                                if (level2Name == '') {
                                  return "please".tr + 'chooselevel2'.tr;
                                }
                              }))
                          : Container(),
                      level1Name == 'school'
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.52,
                              child: UtilsWidgets.dropDownButton(
                                  context,
                                  'noticeschoollevel'.tr,
                                  'noticeschoollevel'.tr,
                                  schoollevelName,
                                  schoollevelList, (p0) {
                                setState(() {
                                  schoollevelName = p0;
                                });
                              }, validator: (p0) {
                                if (schoollevelName == '') {
                                  return 'please'.tr + 'noticeschoollevel'.tr;
                                }
                              }))
                          : Container(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      userLevel == 'district'
                          ? level2Name == 'block' ||
                                  level2Name == 'cluster' ||
                                  level2Name == 'school'
                              ? UtilsWidgets.searchAbleDropDown(
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
                                        tempMap = blockData[blockName];
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
                                  })
                              : Container()
                          : Container(),
                      userLevel == 'block' || userLevel == 'district'
                          ? level2Name == 'cluster' || level2Name == 'school'
                              ? UtilsWidgets.searchAbleDropDown(
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
                                        tempMap =
                                            blockData[blockName][clusterName];
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
                                  })
                              : Container()
                          : Container(),
                      userLevel == 'cluster' ||
                              userLevel == 'block' ||
                              userLevel == 'district'
                          ? level2Name == 'school'
                              ? UtilsWidgets.searchAbleDropDown(
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
                                  })
                              : Container()
                          : Container()
                    ],
                  ),
                  UtilsWidgets.textFormField(
                      context, 
                      'noticesubjecttf'.tr, 
                      'noticesubjecttf'.tr, 
                      (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'please'.tr + 'noticesubjecttf'.tr;
                        }
                      }, 
                      _subjectText
                  ),
                  UtilsWidgets.textFormField(
                      context, 
                      'noticereason'.tr, 
                      'noticereason'.tr,
                      (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'please'.tr + 'noticereason'.tr;
                        }
                      }, 
                      _reasonText, maxLine: 3
                  ),
                  Text(
                    'uploadexamfile'.tr,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'filetypewarning'.tr,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: uploadFile,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10.0),
                      child: Container(
                        width: 250,
                        height: 150,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Constants.primaryColor,
                                style: BorderStyle.solid),
                            color: Colors.blue.shade50.withOpacity(.3),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              color: Constants.primaryColor,
                              size: 100,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'uploadexamfile'.tr,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _platformFile != null
                      ? Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'selectedfile'.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                  width: 250,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 1),
                                          blurRadius: 3,
                                          spreadRadius: 2,
                                        )
                                      ]),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: const Icon(Icons.file_present,
                                              size: 50)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _platformFile!.name,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${(_platformFile!.size / 1024).ceil()} KB',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade500),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                                height: 5,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.blue.shade50,
                                                ),
                                                child: LinearProgressIndicator(
                                                  value:
                                                      loadingController.value,
                                                )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _platformFile = null;
                                              });
                                            },
                                            icon: Icon(size: 25, Icons.delete),
                                          )),
                                    ],
                                  )),
                              const SizedBox(height: 20),
                            ],
                          ))
                      : Container(),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : UtilsWidgets.buildRoundBtn(
                          'cdnotice'.tr,
                          () {
                            if (_formKey.currentState!.validate()) {
                              postNotice();
                            }
                          },
                        ),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 2,
                      indent: 50,
                      endIndent: 50,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      if (userLevel == 'district') {
        level2List.add('All');
        level2List.add('block');
        level2List.add('cluster');
      } else if (userLevel == 'block') {
        level2List.add('All');
        level2List.add('cluster');
        blockName = userID;
        clusterList.clear();
        Map tempMap = {};
        tempMap = blockData[blockName];
        tempMap.forEach((clust, value) {
          clusterList.add(clust);
        });
      } else if (userLevel == 'cluster') {
        level1List.remove('admin');
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

  // uploadResource() async {
  //   String uri = Constants.RESOURCE_URL + '/rohan/notice/id/date/fileName';\
  //   var response = await http.post(
  //     Uri.parse(uri),
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> tempMap = jsonDecode(response.body);
  //     Map<String, dynamic> tap = tempMap['fields'];
  //     String url = tempMap['url'].toString();
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //     request.fields.addAll(Map<String, String>.from(tap));
  //     Uint8List bytes = _platformFile!.bytes ?? Uint8List(0);
  //     request.files.add(await http.MultipartFile.fromBytes('file', bytes));
  //     final responseUpload = await request.send();
  //     if (responseUpload.statusCode == 204) {
  //       print('File Uploaded Successfully');
  //     } else {
  //       print('File Upload Failed');
  //     }
  //   } else {
  //     UtilsWidgets.showToastFunc('error occor');
  //   }
  // }

  Future uploadFile() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result != null) {
        setState(() {
          _platformFile = result.files.first;
          loadingController.forward();
        });
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e);
    }
  }

  Future postNotice() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String sDate =
          Utils.formatDate(DateTime.parse(_startDateText.text), 'yyyy-MM-dd');
      String uri = Constants.NOTIFY_URL + '/postnoticeweb';
      Map params = {
        "sendBy": userNumber,
        "level": userLevel,
        "id": userID,
        "district": userLevel == 'district' ? userID : district,
        "block": userLevel == 'block' ? userID : blockName,
        "cluster": userLevel == 'cluster' ? userID : clusterName,
        "title": _subjectText.text.trim(),
        "description": _reasonText.text.trim(),
        "date": sDate,
        "attachment": _platformFile != null ? _platformFile!.name : '',
        'sendTo': level1Name == 'admin' ? level2Name : schoollevelName,
        'level1': level1Name,
        'level2': level1Name == level2Name ? udise : level2Name
      };
      var response = await http.post(Uri.parse(uri), body: jsonEncode(params));
      if (response.statusCode == 200) {
        Map<String, dynamic> tempMap = jsonDecode(response.body);
        UtilsWidgets.showGetDialog(
            context, "${tempMap["message"]}", Colors.blue);
        if (_platformFile != null) {
          Uint8List bytes = _platformFile!.bytes ?? Uint8List(0);
          await MethodUtils.uploadFile(
              userNumber, userID, sDate, _platformFile!.name, bytes);
          _platformFile = null;
          _startDateText.clear();
          _subjectText.clear();
          _reasonText.clear();
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
}
