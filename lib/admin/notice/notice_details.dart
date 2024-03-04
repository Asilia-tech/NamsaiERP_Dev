import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:numsai/constants.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:numsai/utils/widget_utils.dart';

class NoticeDetails extends StatefulWidget {
  final Map noticeMap;
  const NoticeDetails({super.key, required this.noticeMap});

  @override
  State<NoticeDetails> createState() => _NoticeDetailsState();
}

class _NoticeDetailsState extends State<NoticeDetails> {
  Map noticeDetailMap = {};
  Uint8List webImage = Uint8List(8);
  List img = ['.png', '.jpg', 'jpeg'];

  @override
  void initState() {
    noticeDetailMap = widget.noticeMap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UtilsWidgets.buildAppBar(context, 'Notice'),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(minHeight: 250, maxWidth: 350),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    UtilsWidgets.kayValueWidget(
                        'Title', noticeDetailMap['title'], context),
                    UtilsWidgets.kayValueWidget(
                        'Receive date', noticeDetailMap['date'], context),
                    UtilsWidgets.kayValueWidget(
                        'Sent by',
                        noticeDetailMap['level'] == 'udise'
                            ? "Principal"
                            : noticeDetailMap['level'] == 'cluster'
                                ? "Cluster Administator"
                                : noticeDetailMap['level'] == 'block'
                                    ? "Block Administator"
                                    : "District Administator",
                        context),
                    UtilsWidgets.kayValueWidget(
                        'Description', noticeDetailMap['description'], context),
                    noticeDetailMap['attachment'] == ''
                        ? const Text(
                            'No attachment found!!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : UtilsWidgets.kayValueWidget(
                            'Attachment',
                            noticeDetailMap['attachment'],
                            context,
                            islink: true,
                            onPressed: () async {
                              String uri = Constants.RESOURCE_URL +
                                  '/${noticeDetailMap['sendBy'] + '/notice/' + noticeDetailMap['id'] + '/' + noticeDetailMap['date'] + '/' + noticeDetailMap['attachment']}';
                              var response = await http.get(Uri.parse(uri));
                              if (response.statusCode == 200) {
                                var imageURL = jsonDecode(response.body);
                                final anchor = html.AnchorElement(
                                    href: imageURL)
                                  ..target = 'blank'
                                  ..download = noticeDetailMap['attachment'];
                                anchor.click();
                              } else {
                                print(
                                    'Failed to load image. Status code: ${response.statusCode}');
                              }
                            },
                          ),
                    // noticeDetailMap['attachment'] != null
                    //     ? UtilsWidgets.buildIconBtn(
                    //         'Download resouce', Icon(Icons.download), () async {
                    //         String uri = Constants.RESOURCE_URL +
                    //             '/${noticeDetailMap['sendBy'] + '/notice/' + noticeDetailMap['id'] + '/' + noticeDetailMap['date'] + '/' + noticeDetailMap['attachment']}';
                    //         var response = await http.get(Uri.parse(uri));
                    //         if (response.statusCode == 200) {
                    //           var imageURL = jsonDecode(response.body);
                    //           final anchor = html.AnchorElement(href: imageURL)
                    //             ..target = 'blank'
                    //             ..download = noticeDetailMap['attachment'];
                    //           anchor.click();
                    //         } else {
                    //           print(
                    //               'Failed to load image. Status code: ${response.statusCode}');
                    //         }
                    //       }, Constants.primaryColor)
                    //     : Container()
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
