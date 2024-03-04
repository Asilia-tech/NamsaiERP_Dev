import 'dart:convert';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:numsai/utils/widget_utils.dart';

class Utils {
  static String formatDate(DateTime date, String format) {
    DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  static DateTime parseTime(String time, String formatPattern) {
    DateFormat format = DateFormat(formatPattern);
    return format.parse(time);
  }

  static String formatTimeOfDay(time) {
    DateTime now = DateTime.now();
    DateTime dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return Utils.formatDate(dateTime, 'hh:mm a');
  }

  static String timeStampToDate(String timestamp,
      {String format = 'dd-MM-yyyy hh:mm a'}) {
    DateTime createDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
    String date = Utils.formatDate(createDate, format);
    return date;
  }

  static String formatTime(String time) {
    final parsedTime = DateFormat('HH:mm').parse(time);
    return DateFormat('hh:mm a').format(parsedTime);
  }

  static String previousDate(String date) {
    final parsedDate =
        DateFormat('yyyy-MM-dd').parse(date).subtract(Duration(days: 1));
    String newdate = Utils.formatDate(parsedDate, 'yyyy-MM-dd');
    return newdate;
  }

  static DateTime parseTimeE(String time) {
    final format = DateFormat.jm();
    return format.parse(time);
  }

  static String replaceSpaceWithUnderscore(String input) {
    return input.replaceAll(' ', '_');
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours:$minutes';
  }

  static downloadCSV(List<List<String>> fileData, String fileName) async {
    try {
      String csvData = ListToCsvConverter().convert(fileData);
      final bytes = utf8.encode(csvData);
      Utils.downloadFile(bytes, fileName);
      // final blob = html.Blob([bytes]);
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor = html.document.createElement('a') as html.AnchorElement
      //   ..href = url
      //   ..style.display = 'none'
      //   ..download = fileName;
      // anchor.click();
      // html.Url.revokeObjectUrl(url);
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  static downloadFile(Uint8List file, String fileName) async {
    final blob = html.Blob([Uint8List.fromList(file)]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName;
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  static String generateOTP() {
    const String chars = "0123456789";
    Random random = Random();
    String password = '';
    for (int i = 0; i < 6; i++) {
      int index = random.nextInt(chars.length);
      password += chars[index];
    }
    return password;
  }

  static bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return true;
    }
    return false;
  }

  static onlyFloatNumber() {
    final value = [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))];
    return value;
  }

  static onlyIntNumber() {
    final value = [FilteringTextInputFormatter.allow(RegExp('[0-9]'))];
    return value;
  }

  static onlyAlpha() {
    final value = [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))];
    return value;
  }

  static assetImageToUint8List(String path) async {
    ByteData bytes = await rootBundle.load(path);
    Uint8List list = bytes.buffer.asUint8List();
    return list;
  }
}
