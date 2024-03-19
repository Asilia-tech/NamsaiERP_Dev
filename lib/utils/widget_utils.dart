import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:numsai/constants.dart';
import 'package:photo_view/photo_view.dart';

class UtilsWidgets {
  static buildAppBar(BuildContext context, String title,
      {List<Widget>? Widgets, bool backBtn = true}) {
    return AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 60,
        title: Text(
          title,
          maxLines: 3,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        actions: Widgets,
        automaticallyImplyLeading: backBtn,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Constants.primaryColor),
        ));
  }

  static tabBar(
    String title,
    List<Tab> tabs,
    List<Widget> children,
  ) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Constants.primaryColor),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorWeight: 5,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: tabs,
          ),
          elevation: 20,
          titleSpacing: 10,
        ),
        body: TabBarView(children: children),
      ),
    );
  }

  static searchAbleDropDown(
      BuildContext context,
      List<dynamic> _dropdownItems,
      String? holder,
      String labelText,
      String? SelectedItem,
      Widget? icon,
      ValueChanged? onChange,
      String? DropdownPopUpText,
      Color? color,
      String? searchFieldPropsLabelText,
      FormFieldValidator? validator,
      {bool showSearchBox = true,
      FocusNode? focusNode,
      bool showClearButton = true,
      bool autoFocus = false,
      Key? key}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Container(
        child: DropdownSearch(
          key: key,
          popupProps: PopupProps.bottomSheet(
              showSearchBox: true,
              bottomSheetProps: BottomSheetProps(),
              title: Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  color: Constants.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(labelText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.clip,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))),
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 13,
                letterSpacing: 1),
            dropdownSearchDecoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              labelText: labelText,
              hintText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          items: _dropdownItems,
          validator: validator,
          onChanged: onChange,
          selectedItem: SelectedItem,
        ),
      ),
    );
  }

  static mutliSelectDropDown(
      List<dynamic> _dropdownItems,
      String? holder,
      String labelText,
      List<dynamic> SelectedItems,
      ValueChanged? onChange,
      String? DropdownPopUpText,
      Color? color,
      String? searchFieldPropsLabelText,
      FormFieldValidator? validator,
      {bool showSearchBox = true,
      FocusNode? focusNode,
      bool showClearButton = true,
      bool autoFocus = false,
      Key? key}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Container(
        child: DropdownSearch.multiSelection(
          key: key,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              labelText: labelText,
              hintText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          items: _dropdownItems,
          validator: validator,
          onChanged: onChange,
          selectedItems: SelectedItems,
        ),
      ),
    );
  }

  static dropDownButton(
      BuildContext context,
      String? hint,
      String? label,
      String _dropDownValue,
      List<dynamic> dropDownItem,
      Function(dynamic)? onChange,
      {String? Function(String?)? validator,
      String? holder,
      Widget? widget}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(
        children: [
          widget ?? Text(""),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    label: Text("$label")),
                value: holder,
                focusColor: Colors.transparent,
                isExpanded: true,
                hint: Text(
                  '$hint',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                items: dropDownItem
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ))
                    .toList(),
                validator: validator,
                onChanged: onChange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static textFormField(BuildContext context, String? labelText, String hintText,
      String? Function(String?)? validator, TextEditingController? controller,
      {bool isReadOnly = false,
      TextInputType textInputType = TextInputType.text,
      bool obscure = false,
      int maxLine = 1,
      Widget? icon,
      Widget? suffixIcon,
      Widget? prefixIcon,
      Key? key,
      String? Function(String)? onChanged,
      List<TextInputFormatter>? inputFormatter,
      TextInputAction textInputAction = TextInputAction.next}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Container(
        child: TextFormField(
          key: key,
          onChanged: onChanged,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 1),
          textInputAction: textInputAction,
          autofocus: false,
          keyboardType: textInputType,
          inputFormatters: inputFormatter,
          controller: controller,
          validator: validator,
          obscureText: obscure,
          maxLines: maxLine,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.black, width: 0.0),
            ),
            // contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            icon: icon,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            labelText: labelText,
          ),
        ),
      ),
    );
  }

  static buildDatePicker(String dateLabelText, String hintText,
      TextEditingController editingController, Function(String)? onChanged,
      {DateTime? firstDate,
      DateTime? lastDate,
      DateTimePickerType date = DateTimePickerType.date,
      String dateMask = 'd MMM, yyyy'}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: DateTimePicker(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(width: 2.0),
            ),
            icon: Icon(Icons.calendar_today),
            hintText: hintText,
            labelText: dateLabelText,
            labelStyle: TextStyle(color: Colors.grey)),
        type: date,
        dateMask: dateMask,
        initialDate: DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate,
        icon: const Icon(Icons.event),
        controller: editingController,
        onChanged: onChanged,
        validator: (val) {
          if (val!.isEmpty) {
            return "choosedate".tr;
          }
          return null;
        },
      ),
    );
  }

  static buildIconBtn(
      String? btnName, Widget icon, Function()? onpress, Color? color) {
    return Center(
      child: TextButton.icon(
        onPressed: onpress,
        icon: icon,
        label: Text(
          "$btnName",
          style: TextStyle(
              color: color, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(),
      ),
    );
  }

  static homeIconBtn(String? btnName, Widget icon, Function()? onpress,
      Color? btncolor, double? width,
      {Color bgcolor = const Color.fromARGB(255, 35, 132, 164)}) {
    return Container(
      width: width,
      child: TextButton.icon(
        onPressed: onpress,
        icon: icon,
        label: Text(
          "$btnName",
          style: TextStyle(color: btncolor, fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgcolor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: BorderSide(color: Constants.primaryColor),
                borderRadius: BorderRadius.circular(15)))),
      ),
    );
  }

  static buildSqureBtn(
      String? btnName, Function()? onpress, Color? txtcolor, Color? bgcolor,
      {Color bordercolor = const Color.fromARGB(255, 35, 132, 164)}) {
    return Center(
      child: ElevatedButton(
        onPressed: onpress,
        child: Text(
          '$btnName',
          textAlign: TextAlign.center,
          style: TextStyle(color: txtcolor),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: bgcolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: bordercolor,
              )),
        ),
      ),
    );
  }

  static buildRoundBtn(String? btnsend, Function()? onPressed) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
          child: Text(
            "$btnsend",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Constants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Constants.primaryColor),
            ),
          ),
          onPressed: onPressed),
    );
  }

  static buildRoundBox(BuildContext context, String? btnsend,
      Color? btntxtcolor, Color? btnbgcolor, Function()? onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.38,
      height: MediaQuery.of(context).size.height * 0.15,
      child: ElevatedButton(
          child: Text(
            "$btnsend",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                inherit: false,
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.w600,
                color: btntxtcolor),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: btnbgcolor,
            surfaceTintColor: btnbgcolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Constants.primaryColor),
            ),
          ),
          onPressed: onPressed),
    );
  }

  static buildAdminCount(
      String countName, IconData? countIcon, String countTotal) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(countIcon, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    countName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                countTotal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static toggleWidget(List<bool> isSelected, Function(int)? onPressed) {
    return ToggleButtons(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedColor: isSelected[0] ? Colors.white : Constants.primaryColor,
        fillColor: isSelected[0]
            ? Constants.primaryColor
            : Color.fromARGB(255, 207, 207, 207),
        constraints: const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
        children: [
          Text(
            'yes'.tr,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            'no'.tr,
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        ],
        isSelected: isSelected,
        onPressed: onPressed);
  }

  static Widget buildCard(
      String title, Widget icon, Function()? onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: icon,
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // static buildCard(BuildContext context, double titlesize, String title,
  //     double valuesize, String value, Function()? onTap, Color? color) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Padding(
  //       padding: EdgeInsets.all(8.0),
  //       child: Container(
  //         width: MediaQuery.of(context).size.width * 0.12,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           color: Colors.white,
  //           border: Border.all(color: Constants.primaryColor),
  //         ),
  //         child: Column(
  //           children: [
  //             Container(
  //               child: Text(
  //                 value,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: valuesize,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(8),
  //             ),
  //             Container(
  //               width: MediaQuery.of(context).size.width * 0.12,
  //               height: MediaQuery.of(context).size.width * 0.025,
  //               decoration: BoxDecoration(
  //                 color: color,
  //                 border: Border.all(color: Colors.white),
  //                 borderRadius: BorderRadius.only(
  //                   bottomRight: Radius.circular(12),
  //                   bottomLeft: Radius.circular(12),
  //                 ),
  //               ),
  //               child: Text(
  //                 title,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: titlesize,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(5),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static showProgressDialog() {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                semanticsLabel: 'please'.tr + 'wait'.tr,
                strokeWidth: 5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Constants.primaryColor),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('please'.tr + 'wait'.tr,
                    style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ]));
  }

  static showWidgetDialog(BuildContext context, String okbtnName,
      Function()? okPressed, String? title, List<Widget> WidgetList) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "$title",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: WidgetList,
        ),
      ),
      actions: [
        TextButton(
          child:
              Text('$okbtnName', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: okPressed,
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showDialogBox(
      BuildContext context,
      String btn1Name,
      String btn2Name,
      Function()? btn1Pressed,
      Function()? btn2Pressed,
      String? title,
      List<Widget> WidgetList) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          "$title",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: WidgetList,
        ),
      ),
      actions: [
        TextButton(
          child: Text('$btn1Name'),
          onPressed: btn1Pressed,
        ),
        TextButton(
          child: Text('$btn2Name'),
          onPressed: btn2Pressed,
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static zoomDialog(BuildContext context, image) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: PhotoView(
              tightMode: true,
              imageProvider: MemoryImage(image),
              heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
            ),
          );
        },
      );

  static showToastFunc(message) {
    return Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Constants.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showGetDialog(BuildContext context, message, Color? color) {
    return Get.defaultDialog(
        title: "alert".tr,
        middleText: message,
        contentPadding: EdgeInsets.all(15),
        backgroundColor: Color.fromARGB(255, 227, 235, 239),
        titleStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
        middleTextStyle: TextStyle(color: Colors.black),
        textConfirm: "ok".tr,
        buttonColor: Constants.primaryColor,
        onConfirm: () {
          Navigator.of(context).pop();
        },
        radius: 20);
  }

  static showGetSnackbar(
      BuildContext context, message, Color? color, Widget? icon,
      {bool isDismissible = true,
      Duration? duration = const Duration(seconds: 3)}) {
    return Get.rawSnackbar(
        titleText: Text('alert'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        messageText: Text(message,
            style: TextStyle(fontWeight: FontWeight.w500, color: color)),
        isDismissible: isDismissible,
        duration: duration,
        backgroundColor: Constants.primaryColor,
        icon: icon,
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED);
  }

  static bottomDialogs(
      String msg,
      String title,
      String btn1name,
      String btn2name,
      BuildContext context,
      Function() on1Pressed,
      Function() on2Pressed) {
    return Dialogs.bottomMaterialDialog(
        msg: msg,
        title: title,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: on2Pressed,
            text: btn2name,
            iconData: Icons.thumb_up,
            color: Constants.primaryColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsOutlineButton(
            onPressed: on1Pressed,
            text: btn1name,
            iconData: Icons.cancel,
            color: Colors.white70,
            textStyle: TextStyle(color: Constants.primaryColor),
            iconColor: Constants.primaryColor,
          ),
        ]);
  }

  static remainData(BuildContext context, Widget? child1, Widget? child2) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(child: child1),
              ),
              Expanded(
                flex: 1,
                child: Container(child: child2),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
        ],
      )),
    );
  }

  static upcomingEvent(String eventName, Color backgroundColor,
      Widget eventicon, Widget subtitle, List<Widget> children) {
    return ExpansionTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        childrenPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
        leading: CircleAvatar(
            radius: 25, backgroundColor: backgroundColor, child: eventicon),
        title: Text(
          eventName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle,
        children: children);
  }

  static decorContainer(String containerName, options) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                containerName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: options,
            ),
          ],
        ),
      ),
    );
  }

  static drawerTile(BuildContext context, IconData iconData, String title,
      Function()? onTap) {
    return ListTile(
      leading: Icon(
        iconData,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      onTap: onTap,
    );
  }

  static drawTable(List<DataColumn> columns, List<DataRow> rows,
      {bool sort = true, int columnIndex = 0}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: DataTable(
            sortColumnIndex: columnIndex,
            sortAscending: sort,
            showBottomBorder: true,
            dataTextStyle: const TextStyle(
              color: Colors.black,
            ),
            horizontalMargin: 10,
            dataRowMaxHeight: 65,
            headingTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            columnSpacing: 15,
            headingRowColor: MaterialStateColor.resolveWith((states) {
              return Constants.primaryColor;
            }),
            columns: columns,
            rows: rows),
      ),
    );
  }

  static profileField(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              key,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static detailsFields(
      BuildContext context, String columnName, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(columnName,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal)),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static kayValueWidget(String? key, String? value, BuildContext context,
      {bool islink = false, Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: IntrinsicHeight(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    key ?? "",
                    maxLines: 10,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: islink
                      ? TextButton(
                          onPressed: onPressed,
                          child: Text(value ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue)),
                        )
                      : Text(value ?? '', maxLines: 50),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
            height: 5,
            indent: 25,
            endIndent: 25,
          ),
        ],
      )),
    );
  }

  static msgDecor(BuildContext context, String msg) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
