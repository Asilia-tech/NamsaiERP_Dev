import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:numsai/screens/otp_page.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/function_utils.dart';
import 'package:numsai/utils/widget_utils.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;
  String OTP = "";
  String userLevel = "";
  String userId = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        UtilsWidgets.showDialogBox(
            context,
            'Yes',
            'No',
            () => exit(0),
            () => Navigator.of(context).pop(false),
            'Are you sure?',
            [Text('Do you want to exit an App')]);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent,
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Constants.whiteColor),
              )),
          body: Center(
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        child: Image.asset(
                          'assets/images/otp.png',
                          width: 150,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Enter Your Mobile Number',
                            style: TextStyle(
                              color: Color.fromARGB(255, 9, 8, 56),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Enter a 10 digit mobile number to receive a verification code",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: phoneController,
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "phonetf".tr;
                                  }
                                },
                                inputFormatters: Utils.onlyIntNumber(),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: phoneController.text.length == 10
                                            ? Colors.green
                                            : Colors.red),
                                    // borderRadius: BorderRadius.circular(10)
                                  ),
                                  prefix: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '(+91)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                maxLength: 10,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
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
                          : UtilsWidgets.buildRoundBtn('sendoTP'.tr, () {
                              if (_formKey.currentState!.validate()) {
                                userVerify();
                              }
                            }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future userVerify() async {
    setState(() {
      _isLoading = true;
    });
    String url =
        'https://4gsb83txs9.execute-api.ap-south-1.amazonaws.com/dev/verify';
    Map param = {"mobile": phoneController.text.trim()};
    try {
      var response = await http.post(Uri.parse(url), body: jsonEncode(param));
      if (response.statusCode == 200) {
        Map verifyMap = jsonDecode(response.body);
        if (verifyMap['isValid']) {
          Map info = verifyMap['info'];
          setState(() {
            userId = info['id'];
            userLevel = info['level'];
            _isLoading = false;
          });
          sendOTP();
        } else {
          setState(() {
            _isLoading = false;
          });
          UtilsWidgets.showGetDialog(context, verifyMap['message'], Colors.red);
        }
      } else {
        UtilsWidgets.showToastFunc(response.statusCode);
      }
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  //8828491684
  sendOTP() async {
    OTP = Utils.generateOTP();
    print(OTP);
    // String url =
    //     'https://uf7o06u7j9.execute-api.ap-south-1.amazonaws.com/dev/send_otp';
    // Map param = {"mobile": phoneController.text.trim(), "otp": OTP};
    // try {
    //   var response = await http.post(Uri.parse(url), body: jsonEncode(param));
    //   if (response.statusCode == 200) {
    //     Map verifyMap = jsonDecode(response.body);
    //     if (verifyMap['isValid']) {
    Get.to(OTPLogin(
        phoneNumber: phoneController.text,
        otp: OTP,
        userId: userId,
        userLevel: userLevel));
    //       UtilsWidgets.showToastFunc(verifyMap['message']);
    //     } else {
    //       UtilsWidgets.showGetDialog(context, verifyMap['message'], Colors.red);
    //     }
    //   } else {
    //     UtilsWidgets.showToastFunc(response.statusCode);
    //   }
    // } catch (e) {
    //   UtilsWidgets.showToastFunc(e.toString());
    // }
  }
}
