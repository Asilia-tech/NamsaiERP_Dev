import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:numsai/constants.dart';
import 'package:numsai/utils/widget_utils.dart';

class MethodUtils {
  static uploadFile(String sendBy, String id, String date, String fileName,
      Uint8List file) async {
    String uri = Constants.RESOURCE_URL + '/$sendBy/notice/$id/$date/$fileName';
    var response = await http.post(
      Uri.parse(uri),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> tempMap = jsonDecode(response.body);

      Map<String, dynamic> tap = tempMap['fields'];
      String url = tempMap['url'].toString();

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(Map<String, String>.from(tap));
      request.files.add(await http.MultipartFile.fromBytes('file', file));

      final responseUpload = await request.send();

      if (responseUpload.statusCode == 204) {
        print('File Uploaded Successfully');
      } else {
        print('File Upload Failed');
      }
    } else {
      UtilsWidgets.showToastFunc('error occor');
    }
  }
}
