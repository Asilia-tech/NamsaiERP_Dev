import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numsai/screens/dashboard.dart';
import 'package:numsai/screens/login_page.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:http/http.dart' as http;

class OTPLogin extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  final String userId;
  final String userLevel;

  const OTPLogin(
      {super.key,
      required this.phoneNumber,
      required this.otp,
      required this.userId,
      required this.userLevel});

  @override
  _OTPLoginState createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  final _formKey = GlobalKey<FormState>();
  bool _isDone = true;
  bool _isLoading = false;
  String OTP = "";
  String submitOTP = "";

  @override
  void initState() {
    OTP = widget.otp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            toolbarHeight: 60,
            automaticallyImplyLeading: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Constants.whiteColor),
            )),
        body: Center(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'otp'.tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color.fromARGB(255, 9, 8, 56),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "otpmsg".tr + widget.phoneNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.to(PhoneLogin());
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 30,
                              ))
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OTPTextField(
                                length: 6,
                                width: 300,
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldWidth: 45,
                                style: TextStyle(fontSize: 14),
                                fieldStyle: FieldStyle.box,
                                outlineBorderRadius: 35,
                                onChanged: (pin) {
                                  setState(() {
                                    submitOTP = pin;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "nootp".tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  _isDone
                                      ? Countdown(
                                          seconds: 120,
                                          build: (BuildContext context,
                                                  double time) =>
                                              Text(
                                            time.round().toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          interval:
                                              Duration(milliseconds: 1000),
                                          onFinished: () {
                                            setState(() {
                                              _isDone = false;
                                            });
                                          },
                                        )
                                      : TextButton(
                                          child: Text("resend".tr,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Constants.primaryColor,
                                              )),
                                          onPressed: () {
                                            sendOTP();
                                          },
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : UtilsWidgets.buildRoundBtn('verifyoTP'.tr, () {
                                if (submitOTP.isNotEmpty) {
                                  verifyOTP();
                                } else {
                                  UtilsWidgets.showGetDialog(
                                      context, "Please Enter OTP", Colors.red);
                                }
                              })),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendOTP() async {
    setState(() {
      OTP = Utils.generateOTP();
      _isDone = true;
    });
    String url =
        'https://uf7o06u7j9.execute-api.ap-south-1.amazonaws.com/dev/send_otp';
    Map param = {"mobile": widget.phoneNumber, "otp": OTP};
    try {
      var response = await http.post(Uri.parse(url), body: jsonEncode(param));
      if (response.statusCode == 200) {
        Map verifyMap = jsonDecode(response.body);
        if (verifyMap['isValid']) {
          UtilsWidgets.showToastFunc(verifyMap['message']);
        } else {
          UtilsWidgets.showToastFunc(verifyMap['message']);
        }
      } else {
        UtilsWidgets.showToastFunc(response.statusCode);
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  verifyOTP() async {
    setState(() {
      _isLoading = true;
    });
    if (OTP == submitOTP) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('number', widget.phoneNumber);
      await prefs.setString('level', widget.userLevel);
      await prefs.setString('id', widget.userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } else {
      UtilsWidgets.showGetDialog(context, "otptf".tr, Colors.red);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
