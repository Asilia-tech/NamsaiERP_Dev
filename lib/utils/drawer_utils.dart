import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numsai/admin/add_school.dart';
import 'package:numsai/admin/add_principal.dart';
import 'package:numsai/admin/list_school.dart';
import 'package:numsai/admin/list_teacher.dart';
import 'package:numsai/admin/notice/notifications.dart';
import 'package:numsai/screens/dashboard.dart';
import 'package:numsai/screens/login_page.dart';
import 'package:numsai/screens/profile_screen.dart';
import 'package:numsai/admin/student_reports/student_reports.dart';
import 'package:numsai/admin/teacher_reports/teacher_reports.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildDrawer {
  static Drawer buildUserDrawer(
      BuildContext context, bool isConnected, bool _ishindi) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Constants.whiteColor, Constants.greyColor],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/images/namsai_rmbg.png',
                    height: 60,
                  ),
                  Image.asset(
                    'assets/images/asilia_rmbg.png',
                    height: 40,
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            UtilsWidgets.drawerTile(context, Icons.home, 'home'.tr, () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(Dashboard());
            }),
            UtilsWidgets.drawerTile(context, Icons.notifications, 'cdnotice'.tr,
                () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(Notifications());
            }),
            UtilsWidgets.drawerTile(
                context, Icons.account_circle, 'teacheradd'.tr, () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(AddPrincipal());
            }),
            UtilsWidgets.drawerTile(context, Icons.edit, 'teacherupdate'.tr,
                () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(TeacherList());
            }),
            UtilsWidgets.drawerTile(context, Icons.school, 'schooladd'.tr, () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(AddSchool());
            }),
            UtilsWidgets.drawerTile(
                context, Icons.edit_square, 'updateschool'.tr, () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(SchoolList());
            }),
            const Divider(color: Colors.grey, thickness: 2),
            UtilsWidgets.drawerTile(context, Icons.dashboard, 'hvd'.tr,
                () async {
              if (isConnected) {
                String dashboardUrl =
                    'https://lookerstudio.google.com/reporting/b7379ce8-b30f-45df-b932-0af075b42c84';
                if (await canLaunch(dashboardUrl)) {
                  await launch(dashboardUrl);
                } else {
                  UtilsWidgets.showToastFunc('Could not launch $dashboardUrl');
                }
              } else {
                UtilsWidgets.showToastFunc(
                    "Please check your internet connection.");
              }
            }),
            UtilsWidgets.drawerTile(
                context, Icons.analytics, 'teacherreports'.tr, () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(TeacherReportScreen());
            }),
            UtilsWidgets.drawerTile(
                context, Icons.pie_chart, 'studentreport'.tr, () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(StudentReportScreen());
            }),
            const Divider(color: Colors.grey, thickness: 2),
            UtilsWidgets.drawerTile(context, Icons.wechat_sharp, 'help'.tr,
                () async {
              if (isConnected) {
                String phoneNumber = '917304336515';
                String whatsappUrl = 'https://wa.me/$phoneNumber?text=hi';
                if (await canLaunch(whatsappUrl)) {
                  await launch(whatsappUrl);
                } else {
                  UtilsWidgets.showToastFunc('Could not launch $whatsappUrl');
                }
              } else {
                UtilsWidgets.showToastFunc(
                    "Please check your internet connection.");
              }
            }),
            UtilsWidgets.drawerTile(context, Icons.person_2, 'profile'.tr, () {
              !isConnected
                  ? UtilsWidgets.showGetDialog(context,
                      "Please check your internet connection.", Colors.red)
                  : Get.to(ProfilePage());
            }),
            ExpansionTile(
              title: Text(
                'changelanguage'.tr,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              leading: const Icon(
                Icons.translate_rounded,
                color: Colors.black,
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              childrenPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
              children: [
                ListTile(
                  title: const Text('हिंदी'),
                  onTap: () {
                    var locale = Locale('hi', 'IN');
                    Get.updateLocale(locale);
                    _ishindi = true;
                  },
                ),
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    var locale = Locale('en', 'US');
                    Get.updateLocale(locale);
                    _ishindi = false;
                  },
                ),
              ],
            ),
            UtilsWidgets.drawerTile(
                context, Icons.power_settings_new_sharp, 'logout'.tr, () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              UtilsWidgets.bottomDialogs(
                  '', 'logoutmsg'.tr, 'no'.tr, 'yes'.tr, context, () {
                Navigator.of(context).pop();
              }, () {
                prefs.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhoneLogin(),
                  ),
                );
              });
            }),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
