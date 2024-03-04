import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  String userID = "";
  String userLevel = "";
  String userNumber = "";
  String designation = "";
  String email = "";
  String userName = "";

  @override
  void initState() {
    getOfflineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UtilsWidgets.buildAppBar(context, 'profile'.tr),
        body: _isLoading
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            const CircleAvatar(
                                radius: 50,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                )),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  userNumber,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(
                          endIndent: 20,
                          indent: 20,
                          thickness: 1,
                          color: Colors.black38,
                        ),
                        const SizedBox(height: 5),
                        UtilsWidgets.detailsFields(
                            context, 'personaldetails'.tr, [
                          UtilsWidgets.profileField(
                              context, 'Designation: ', designation),
                          UtilsWidgets.profileField(
                              context, 'Level: ', userLevel),
                          UtilsWidgets.profileField(context, 'ID: ', userID),
                          UtilsWidgets.profileField(context, 'Email: ', email),
                        ]),
                        SizedBox(height: 10),
                        ExpansionTile(
                          title: Text('about'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          leading: const Icon(Icons.info, color: Colors.black),
                          controlAffinity: ListTileControlAffinity.trailing,
                          childrenPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                          children: [
                            ListTile(
                              title: const Text(
                                  'This app is designed for School Management System for Namsai Education Department of Namsai District, Arunachal Pradesh.\n\nThis service is designed by Asilia Technologies Private Limited.\n\n'),
                              subtitle: Text(
                                'App version ${Constants.APPVERSION}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ExpansionTile(
                          title: Text(
                            'privacypolicy'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: const Icon(Icons.do_not_touch_outlined,
                              color: Colors.black),
                          controlAffinity: ListTileControlAffinity.trailing,
                          childrenPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                          children: [
                            ListTile(
                                title: const Text(
                                    'ASILIA TECHNOLOGIES PRIVATE LIMITED built the TimeLog Namsai app as a Free app. This SERVICE is provided by ASILIA TECHNOLOGIES PRIVATE LIMITED at no cost and is intended for use as is.\n\nThis page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.\n\nIf you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at TimeLog Namsai unless otherwise defined in this Privacy Policy.'),
                                subtitle: Row(
                                  children: [
                                    const Text('To more:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    TextButton(
                                      child: Text('click here'),
                                      onPressed: () async {
                                        String url =
                                            'https://asilia.tech/privacy-policy/';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          print('Could not launch $url');
                                        }
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Powered by ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                'assets/images/asilia_rmbg.png',
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  getOfflineData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userLevel = pref.getString('level') ?? '';
      userID = pref.getString('id') ?? '';
      userNumber = pref.getString('number') ?? '';
      designation = pref.getString('designation') ?? '';
      email = pref.getString('email') ?? '';
      userName = pref.getString('name') ?? '';
    });
  }
}
