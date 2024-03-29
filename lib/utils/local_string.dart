import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          "login": "Login",
          "welcome": "Welcome to ",
          "changelanguage": "Change language",
          "logout": "Logout",
          "logoutmsg": "Are you sure you want to logout?",
          "confirmmsg": "Are you sure?",
          "exitmsg": "Do you want to exit an App",
          "yes": "Yes",
          "no": "No",
          "ok": "Ok",
          "support": "Support",
          "help": "Help",
          "notice": "Notice",
          "viewnotice": "View notice",
          "sentnotice": "Sent notice",
          "alert": "Alert",
          "submit": "Submit",
          "save": "Save",
          "cancel": "Cancel",
          "wait": "Wait...",
          "please": "Please ",
          "note": "Note",
          "tx": "Thank You",
          "student": "Student",
          "teacher": "Teacher",
          "search": "Search",
          "otp": "Verification code",
          "otpmsg": "We have sent the verification code to +91",
          "loginmsg": "Enter a 10 digit mobile number to receive a verification code",
          "mobile_tf": "Enter your mobile number",
          "otptf": "You have entered an invalid OTP",
          "sendoTP": "Send OTP",
          "verifyoTP": "Verify OTP",
          "resend": "Resend",
          "errormsg": "Your entered mobile number not register with us",
          "nointernetmsg": "You are not connected to internet",
          "nootp": "Didn't receive? ",
          "attendance_history": "Attendance history",
          "see_more": "See more",
          "In": "Check-In",
          "Out": "Check-Out",
          "totalhours": "Total hours",
          "status": "Status",
          "day": "Day",
          "date": "Date",
          "view_history": "View history",
          "refresh": "Refresh",
          "cdnotice": "Post Notice",
          "rmteacher": "Remove teacher",
          "notify_leave": "Notify leave",
          "teacher_report": "Teacher Reports",
          "markt_attendance": "Mark Attendance",
          "marks_attendance": "Student Attendance",
          "log_time": "Log My Time",
          "personaldetails": "Personal Details",
          "examadd": "Add Exam Data",
          "teacherupdate": "Update/Transfer Principal",
          "studentreport": "Student Reports",
          "studentupdate": "Update/Transfer Student",
          "schooladd": "Add New School",
          "teacheradd": "Add New Principal",
          "studentadd": "Add New Student",
          "teachertransfer": "Teacher Transfer Request",
          "studenttransfer": "Student Transfer Request",
          "studentpromote": "Promote Students",
          "profile": "Profile",
          "internetalert": "PLEASE CONNECT TO THE INTERNET",
          "updateconfirm": "Would you like to update the data on the app?",
          "updateappdata": "Update App Data",
          "studentlist": "Get Student List",
          "chooseclassdivision": "Please choose class and division to get student list",
          "choosedaterange": "Please select a date for the report",
          "chooseclass": "Choose class",
          "choosedivision": "Choose division",
          "choosenewclass": "Choose new class",
          "choosenewdivision": "Choose new division",
          "nostudentfound": "No student found!!",
          "nohistoryfound": "No History Found!!",
          "chooseatleastonestudent": "Plaese choose at least one student",
          "about": "About",
          "privacypolicy": "Privacy Policy",
          "bankdetails": "Bank details",
          "holidays": "Holidays",
          "choosedeathdate": "Choose a Death date",
          "chooserelation": "Choose Relation",
          "reasonforleave": "Enter reason for leave",
          "choosedaytype": "Choose day type",
          "choosestartdate": "Choose start date",
          "chooseenddate": "Choose end date",
          "chooseleavetype": "Choose Leave",
          "appliedleaves": "Notified Leaves",
          "reviewinfo": "Please review leave details before submitting.",
          "chooseexamdate": "Choose exam date",
          "chooseexamname": "Choose exam name",
          "chooseexamyear": "Choose exam year",
          "choosesubject": "Choose subject",
          "totalmarks": "Total Marks",
          "obtainmarks": "Obtain Marks",
          "choosedate": "Please choose date",
          "remarktf": "Enter remark",
          "inschool": "Are you in your school..?",
          "logtime": "Log My Time",
          "logtimealert": "Set Automatic time zone setting enable to do clocking",
          "attendancedate": "Choose attendance date",
          "locationalert": "Location services are currently turned off. Please refresh to enable them.",
          "promotealert": "You can't promote student to next class",
          "futuredate": "You are not allowed to request sick leave for a date in the future.",
          "workdayrequired": "Your requested time off must include at least one workday. Please change the dates you've entered accordingly.",
          "gm": "Good Morning",
          "ga": "Good Afternoon",
          "ge": "Good Evening",
          "title": "Title",
          "sentdate": "Sent date",
          "sentby": "Sent by",
          "description": "Description",
          "attachment": "Attachment",
          "download": "Download ",
          "leavedetails": "Leave details:",
          "leave": "Leave:",
          "startdate": "Start date:",
          "enddate": "End date:",
          "total": "Total:",
          "reason": "Reason:",
          "addexamdata": "Add exam data",
          "bulkupload": "Bulk upload",
          "uploadexamdata": "Upload exam data",
          "filledexamdata": "Filled exam data",
          "semester": "Semester",
          "class": "Class",
          "division": "Division",
          "subject": "Subject",
          "marks": "Marks",
          "downloadexamfile": "Download exam file",
          "uploadexamfile": "Upload your file",
          "selectyourfile": "Select your file",
          "selectedfile": "Selected File",
          "fileextention": "File should be .csv",
          "addalert": "Please review the information you wish to add.",
          "logedtime": "Log Time",
          "address": "Address",
          "remark": "Remark",
          "editexamdata": "Edit Exam Data",
          "updateexamdata": "Update Exam Data",
          "updateexamalert": "Please review the marks you wish to update.",
          "studentname": "Student Name",
          "teachername": "Pricipal Name",
          "rollno": "Roll No",
          "mobile": "Mobile",
          "studentid": "Student Id",
          "examyear": "Exam Year",
          "choosestudentname": "Choose Student Name",
          "markedby": "Marked By",
          "totalstudents": "Total Students",
          "totalschools": "Total Schools",
          "present": "Present",
          "absent": "Absent",
          "totalteachers": "Total Teachers",
          "totalprincipals": "Total Principals",
          "classwiseattendance": "Class wise attendance",
          "weekwisepresent": "Week wise present",
          "weekwiseabsent": "Week wise absent",
          "monthwiseattendance": "Month wise attendance",
          "dashboard": "Dashboard",
          "studentreports": "Student Reports",
          "studentattendance": "Student Attendance",
          "attendancereport": "Attendance Report",
          "examreport": "Exam Report",
          "teacherreports": "Teacher Reports",
          "userreport": "User Report",
          "monthlyreport": "Monthly Report",
          "leavereport": "Leave Report",
          "chooseteachername": "Choose Teacher Name",
          "transferrequestapproval": "Transfer Request Approval",
          "transferfrom": "Transfer From",
          "transferto": "Transfer To",
          "applydate": "Apply Date",
          "approve": "Approve",
          "reject": "Reject",
          "approvealert": "Do you really want to approve this request?",
          "rejectalert": "Do you really want to reject this request?",
          "noticehistory": "Notice History",
          "deletenotice": "Delete Notice",
          "deletenoticealert": "Do you really want to delete this notice?",
          "postnoticetf": "Choose date to post notice",
          "noticesubjecttf": "Enter notice subject",
          "noticedetailstf": "Enter notice details",
          "edit": "Edit",
          "transfer": "Transfer",
          "uploadaadhaarcard": "Upload aadhaar card",
          "uploadbankpassbook": "Upload bank passbook",
          "ifsctf": "Enter IFSC code",
          "accountnumbertf": "Enter account number",
          "accountholdertf": "Enter account holder name",
          "banknametf": "Enter bank name",
          "jobtypetf": "Choose job type",
          "disabilitytypetf": "Enter disability type",
          "Isdisable": "Is student disable?",
          "residentaddresstf": "Enter residential address",
          "subcaste": "Sub-caste",
          "caste": "Caste",
          "choosereligion": "Choose religion",
          "choosecategory": "Choose category",
          "castedetails": "Caste Details",
          "choosegender": "Choose Gender",
          "gendermale": "Male",
          "genderfemale": "Female",
          "genderother": "Other",
          "dobtf": "Choose date of birth",
          "servicejointf": "Choose date of service Join",
          "schooljointf": "Choose date of school Join",
          "saadhaartf": "Enter student aadhaar number",
          "taadhaartf": "Enter principal aadhaar number",
          "aadhaarvtf": "Please enter valid aadhaar number",
          "smobiletf": "Enter parent's mobile number",
          "tmobiletf": "Enter principal mobile number",
          "mobilevtf": "Please enter valid mobile number",
          "tnametf": "Enter principal name",
          "mothernametf": "Mother name",
          "fathernametf": "Father name",
          "F&Lnametf": "First & Last name",
          "transferstudent": "Transfer Student",
          "updatestudent": "Update Student",
          "chooseblock": "Choose block",
          "choosecluster": "Choose cluster",
          "chooseschool": "Choose school",
          'choosestatus': 'Choose status',
          "transferteacher": "Transfer Principal",
          "updateteacher": "Update Principal",
          "updateschool": "Update School",
          "home": "Home",
          "hvd": "Hamara Vidyalaya Dashboard",
          "teacheroverview": "Teacher overview",
          "presentteachers": "Today's present teachers",
          "absentteachers": "Today's absent teachers",
          "studentoverview": "Student overview",
          "presentstudents": "Today's present students",
          "absentstudents": "Today's absent teachers",
          "tbasicinfo": "Basic information",
          "tschooltype": "Enter school type",
          "tgeographicinfo": "Geographic information",
          "latitude": "Enter the latitude",
          "longitude": "Enter the longitude",
          "georadius": "Enter the geo-radius",
          "schooladdress": "Enter school address",
          "pincode": "Enter the pincode",
          "tschooltime": "School time",
          "intime": "Enter the in-time",
          "outtime": "Enter the out-time",
          "tacademicinfo": "Academic Information",
          "totalteacherlicense": "Enter total teachers license required",
          "enterholidays": "Enter total holidays", 
          "holidayname": "Enter holiday name",
          "ttotalholiday": "Please choose total holidays",
          "add": "Add",
          "allteachers": "All Principals",
          "allschools": "All Schools",
          "schoolname": "School name",
          "teacheraddress": "Enter teacher address",
          "district": "Enter the district",
          "chooselevel1": 'Choose level-1',
          "chooselevel2": 'Choose level-2',
          "noticesendto": 'Choose sendTo',
          "noticereason": 'Enter reason for notice',
          "filetypewarning": 'File should be  jpg, png, pdf',
          "notifications": 'Notifications',
          "createnotif": 'Create Notification',
          "sentnotif": 'Sent Notifications',
          "receivednotif": 'Received Notifications',
          "noticeschoollevel": 'Enter school level',
          "teacherreportwarning": 'Please choose date range to generate report',
          "leavetype": 'Leave type',
          "totalleave": 'Total Leave',
          "studentreportlevel": 'Choose level',
          "enterdetails": 'Please enter the details',
          "timetable": "Timetable",
          "addcell": "Add a cell",
          "section": "section",
          "choosesection": "Choose the section",
          "starttime": "Start time",
          "endtime": "End time",
          "choosestarttime": "Choose start time",
          "chooseendtime": "Choose end time",
          "entersubject": "Enter the subject",
          "enterroom": "Enter the room",
          "enterteachername": "Enter the teacher name",
          "chooseday": "Choose the day",
          "print": "print",
          "update": "update",
        },


        "hi_IN": {
          "login": "लॉग इन करें",
          "welcome": "आपका स्वागत है",
          "changelanguage": "भाषा बदलें",
          "logout": "लॉग आउट",
          "logoutmsg": "क्या आप वाकई लॉगआउट करना चाहते हैं?",
          "confirmmsg": "क्या आपको यकीन है?",
          "exitmsg": "क्या आप ऐप से बाहर निकलना चाहते हैं",
          "yes": "हाँ",
          "no": "नहीं",
          "ok": "ठीक है",
          "support": "सहायता",
          "help": "मदद",
          "notice": "नोटिस",
          "viewnotice": "नोटिस देखे",
          "sentnotice": "नोटिस देखे",
          "alert": "सूचना",
          "status": "स्थिति",
          "submit": "सबमिट",
          "save": "सहेजें",
          "cancel": "रद्द करें",
          "wait": "प्रतीक्षा करें...",
          "please": "कृपया ",
          "note": "नोट",
          "tx": "धन्यवाद",
          "student": "छात्र",
          "teacher": "शिक्षक",
          "search": "खोजें",
          "otp": "OTP कोड",
          "otpmsg": "हमने OTP कोड पर भेज दिया है, मोबाइल नंबर है +91",
          "loginmsg":
              "OTP कोड प्राप्त करने के लिए एक 10 अंकों का मोबाइल नंबर दर्ज करें",
          "mobile_tf": "अपना मोबाइल नंबर दर्ज करें",
          "otptf": "आपने एक अमान्य OTP दर्ज किया है",
          "sendoTP": "OTP भेजें",
          "verifyoTP": "OTP वेरीफाय करें",
          "resend": "फिर से भेजें",
          "errormsg":
              "आपके द्वारा दर्ज किया गया मोबाइल नंबर हमारे साथ रजिस्टर नहीं है",
          "nointernetmsg": "आप इंटरनेट से कनेक्ट नहीं हैं",
          "nootp": "प्राप्त नहीं हुआ? ",
          "attendance_history": "पिछले दिनों की उपस्थिति",
          "see_more": "और देखें",
          "In": "चेक-इन",
          "Out": "चेक-आउट",
          "totalhours": "कुल घंटे",
          "view_history": "इतिहास देखें",
          "refresh": "ताज़ा करें",
          "teacheradd": "प्राध्यापक जोड़ें",
          "cdnotice": "नोटिस पोस्ट करें",
          "rmteacher": "शिक्षक हटाएं",
          "notify_leave": "छुट्टियाँ सूचित करें",
          "teacher_report": "शिक्षक रिपोर्ट",
          "markt_attendance": "उपस्थिति दर्ज करे",
          "marks_attendance": "छात्रों की उपस्थिति",
          "log_time": "मेरा समय लॉग करें",
          "personaldetails": "व्यक्तिगत की जानकारी",
          "examadd": "परीक्षा डेटा जोड़ें",
          "teacherupdate": "प्राध्यापक की जानकारी अपडेट करे",
          "studentreport": "छात्र की रिपोर्ट",
          "studentupdate": "छात्रों की जानकारी अपडेट करे",
          "schooladd": "नए स्कूल जोड़े",
          "studentadd": "नए छात्र जोड़े",
          "teachertransfer": "शिक्षक स्थानांतरण अनुरोध",
          "studenttransfer": "छात्र को ट्रांसफर करें",
          "studentpromote": "छात्र अगली कक्षा में भेजे",
          "profile": "उपयोगकर्ता जानकारी",
          "internetalert": "कृपया इंटरनेट से कनेक्ट करें",
          "updateconfirm": "क्या आप ऐप पर जानकारी अपडेट करना चाहते हैं?",
          "updateappdata": "ऐप जानकारी अपडेट करें",
          "studentlist": "छात्र सूची प्राप्त करे",
          "chooseclassdivision":
              "कृपया छात्र सूची प्राप्त करने के लिए कक्षा और वर्ग चुनें",
          "chooseclass": "कक्षा चुनें",
          "choosedivision": "वर्ग चुनें",
          "choosenewclass": "नए कक्षा चुनें",
          "choosenewdivision": "नए वर्ग चुनें",
          "nostudentfound": "कोई छात्र नहीं मिला!!",
          "nohistoryfound": "कोई जानकारी नहीं मिली!!",
          "chooseatleastonestudent": "कृपया कम से कम एक छात्र चुनें",
          "about": "हमारे बारे में",
          "privacypolicy": "गोपनीयता नीति",
          "bankdetails": "बैंक की जानकारी",
          "holidays": "छुट्टियाँ",
          "choosedeathdate": "मौत की तारीख चुनें",
          "chooserelation": "रिश्ता चुनें",
          "reasonforleave": "छुट्टी का कारण दर्ज करें",
          "choosedaytype": "दिन का प्रकार चुनें",
          "choosestartdate": "प्रारंभ तिथि चुनें",
          "date": "तारीख",
          "day": "दिन",
          "chooseexamdate": "परीक्षा की तिथि चुनें",
          "chooseexamname": "परीक्षा का नाम चुनें",
          "chooseexamyear": "परीक्षा का साल चुनें",
          "choosesubject": "विषय चुनें",
          "totalmarks": "कुल अंक",
          "choosedate": "कृपया तारीख चुनें",
          "remarktf": "जानकारी टाइप करें",
          "inschool": "क्या आप पाठशाला में है..?",
          "logtime": "उपस्थिति दर्ज करे",
          "choosedaterange": "कृपया रिपोर्ट के लिए तारीख चुनें",
          "logtimealert":
              "उपस्थिति करने के लिए स्वचालित समय की सेटिंग सक्षम करें सेट करें",
          "attendancedate": "उपस्थिति तिथि चुनें",
          "locationalert":
              "लोकेशन सेवाएँ फिलहाल बंद हैं. कृपया उन्हें सक्षम करने के लिए रीफ़्रेश करें.",
          "promotealert": "आप छात्र को अगली कक्षा में प्रमोट नहीं कर सकते",
          "chooseenddate": "समाप्ति तिथि चुनें",
          "chooseleavetype": "छुट्टी का प्रकार चुनें",
          "appliedleaves": "लागू छुट्टियाँ",
          "reviewinfo":
              "कृपया छुट्टी के लिए प्रस्तुत की गई जानकारी की समीक्षा करें इसे अंतिम रूप देने से पहले।",
          "futuredate":
              "आपको भविष्य की तारीख के लिए बीमारी की छुट्टी का अनुरोध करने की अनुमति नहीं है।",
          "workdayrequired":
              "आपके अनुरोधित छुट्टि का कम से कम एक कार्यदिवस शामिल होना चाहिए। कृपया आपने दर्ज की गई तारीखों को उसी अनुसार बदलें।",
          "gm": "शुभ प्रभात",
          "ga": "शुभ दोपहर",
          "ge": "शुभ संध्या",
          "title": "शीर्षक",
          "sentdate": "भेजी गई तिथि",
          "sentby": "भेजा गया",
          "description": "जानकारी",
          "attachment": "अटैचमेंट",
          "download": "डाउनलोड",
          "leavedetails": "छुट्टी की जानकारी:",
          "leave": "छुट्टी:",
          "startdate": "प्रारंभ तिथि:",
          "enddate": "समाप्ति तिथि:",
          "total": "कुल:",
          "reason": "कारण:",
          "bulkupload": "बल्क उपलोड",
          "uploadexamdata": "परीक्षा डेटा अपलोड करें",
          "filledexamdata": "भरा हुआ परीक्षा डेटा",
          "semester": "सेमेस्टर",
          "class": "कक्षा",
          "division": "वर्ग",
          "subject": "विषय",
          "marks": "मार्क्स",
          "downloadexamfile": "परीक्षा फ़ाइल डाउनलोड करें",
          "uploadexamfile": "परीक्षा फ़ाइल अपलोड करें",
          "selectyourfile": "अपनी फ़ाइल का चुने करें",
          "selectedfile": "फ़ाइल चुने",
          "fileextention": "फ़ाइल .csv होनी चाहिए",
          "addalert": "कृपया जो जानकारी आप जोड़ना चाहते हैं, उसे समीक्षा करें।",
          "logedtime": "समय लॉग करें",
          "address": "पता",
          "remark": "टिप्पणी",
          "obtainmarks": "प्राप्त अंक",
          "editexamdata": "परीक्षा डेटा एडिट करें",
          "updateexamdata": "परीक्षा डेटा अपडेट करें",
          "updateexamalert": "परीक्षा डेटा अपडेट करें",
          "studentname": "छात्र का नाम",
          "teachername": "प्राध्यापक का नाम",
          "rollno": "रोल नंबर",
          "mobile": "मोबाइल नंबर",
          "studentid": "छात्र आईडी",
          "examyear": "परीक्षा वर्ष",
          "choosestudentname": "छात्र का नाम चुनें",
          "markedby": "चिह्नित व्यक्ति",
          "totalstudents": "कुल छात्र",
          "totalschools": "कुल पाठशाला",
          "present": "हाजिर",
          "absent": "अनुपस्थित",
          "totalteachers": "कुल शिक्षक",
          "totalprincipals": "कुल प्राध्यापक",
          "classwiseattendance": "कक्षा अनुसार उपस्थिति",
          "weekwisepresent": "सप्ताह अनुसार उपस्थिति",
          "weekwiseabsent": "सप्ताह अनुसार अनुपस्थित",
          "monthwiseattendance": "माह अनुसार उपस्थिति",
          "dashboard": "डैशबोर्ड",
          "studentreports": "छात्र रिपोर्ट",
          "studentattendance": "छात्र उपस्थिति",
          "attendancereport": "उपस्थिति रिपोर्ट",
          "examreport": "परीक्षा रिपोर्ट",
          "teacherreports": "शिक्षक रिपोर्ट",
          "userreport": "उपयोगकर्ता रिपोर्ट",
          "monthlyreport": "मासिक रिपोर्ट",
          "leavereport": "छुट्टी की रिपोर्ट",
          "chooseteachername": "शिक्षक का नाम चुनें",
          "transferrequestapproval": "स्थानांतरण अनुरोध स्वीकृति",
          "transferfrom": "स्थानांतरित करने से",
          "transferto": "स्थानांतरित करने के लिए",
          "applydate": "आवेदन की तारीख",
          "approve": "स्वीकृति",
          "reject": "अस्वीकृति",
          "approvealert": "क्या आप वाकई इस अनुरोध को स्वीकृत करना चाहते हैं?",
          "rejectalert": "क्या आप वाकई इस अनुरोध को अस्वीकृत करना चाहते हैं?",
          "noticehistory": "नोटिस इतिहास",
          "deletenotice": "नोटिस हटाएं",
          "deletenoticealert": "क्या आप वाकई इस नोटिस को हटाना चाहते हैं?",
          "postnoticetf": "नोटिस पोस्ट करने के लिए तिथि चुनें",
          "noticesubjecttf": "नोटिस विषय दर्ज करें",
          "noticedetailstf": "नोटिस विवरण दर्ज करें",
          "edit": "संपादित करें",
          "transfer": "स्थानांतरित करें",
          "uploadaadhaarcard": "आधार कार्ड अपलोड करें",
          "uploadbankpassbook": "बैंक पासबुक अपलोड करें",
          "ifsctf": "IFSC कोड दर्ज करें",
          "accountnumbertf": "खाता संख्या दर्ज करें",
          "accountholdertf": "खाता धारक का नाम दर्ज करें",
          "banknametf": "बैंक का नाम दर्ज करें",
          "jobtypetf": "नौकरी का प्रकार चुनें",
          "disabilitytypetf": "विकलांगता का प्रकार दर्ज करें",
          "Isdisable": "क्या छात्र विकलांग है?",
          "residentaddresstf": "निवास पता दर्ज करें",
          "subcaste": "उप-जाति",
          "caste": "जाति",
          "choosereligion": "धर्म चुनें",
          "choosecategory": "श्रेणी चुनें",
          "castedetails": "जाति विवरण",
          "choosegender": "लिंग चुनें",
          "gendermale": "पुरुष",
          "genderfemale": "महिला",
          "genderother": "अन्य",
          "dobtf": "जन्म की तारीख चुनें",
          "servicejointf": "सेवा ज्वाइन की तारीख चुनें",
          "schooljointf": "स्कूल में शामिल होने की तारीख चुनें",
          "saadhaartf": "छात्र आधार नंबर दर्ज करें",
          "taadhaartf": "शिक्षक आधार नंबर दर्ज करें",
          "aadhaarvtf": "कृपया एक वैध आधार नंबर दर्ज करें",
          "smobiletf": "माता-पिता का मोबाइल नंबर दर्ज करें",
          "tmobiletf": "शिक्षक का मोबाइल नंबर दर्ज करें",
          "mobilevtf": "कृपया एक वैध मोबाइल नंबर दर्ज करें",
          "tnametf": "शिक्षक का नाम दर्ज करें",
          "mothernametf": "माता का नाम",
          "fathernametf": "पिता का नाम",
          "F&Lnametf": "पहला और आखिरी नाम",
          "transferstudent": "छात्र को स्थानांतरित करें",
          "updatestudent": "छात्र को अपडेट करें",
          "chooseblock": "ब्लॉक चुनें",
          "choosecluster": "क्लस्टर चुनें",
          "chooseschool": "स्कूल चुनें",
          'choosestatus': 'स्थिति चुनें',
          "transferteacher": "शिक्षक को स्थानांतरित करें",
          "updateteacher": "शिक्षक को अपडेट करें",
          "updateschool": "स्कूल को अपडेट करें",
          "home": "होम",
          "hvd": "हमारा विद्यालय डॅशबोर्ड",
          "teacheroverview": "शिक्षक अवलोकन",
          "presentteachers": "आज के मौजूदा शिक्षक",
          "absentteachers": "आज के अनुपस्थित शिक्षक",
          "studentoverview": "छात्र अवलोकन",
          "presentstudents": "आज के मौजूदा छात्र",
          "absentstudents": "आज के अनुपस्थित छात्र",
          "tbasicinfo": "मूल जानकारी",
          "tschooltype": "स्कूल का प्रकार चुनें",
          //
          "tgeographicinfo": "भौगोलिक जानकारी",
          "latitude": "लैटीट्यूड दर्ज करें",
          "longitude": "लॉन्जिट्यूड दर्ज करें",
          "georadius": "जियो-रेडियस दर्ज करें",
          "schooladdress": "विद्यालय का पता दर्ज करें",
          "pincode": "पिन कोड दर्ज करें",
          "tschooltime": "विद्यालय के समय दर्ज करें",
          "intime": "प्रारम्भ का समय दर्ज करें",
          "outtime": "समाप्ति का समय दर्ज करें",
          "tacademicinfo": "शैक्षणिक जानकारी",
          "totalteacherlicense": "कुल शिक्षक लाइसेंस दर्ज करें",
          "enterholidays": "कुल छुट्टियाँ दर्ज करें", 
          "holidayname": "छुट्टी का नाम दर्ज करें",
          "ttotalholiday": "कृपया कुल छुट्टियाँ दर्ज करें",
          "add": "जोड़ें",
          "allteachers": "सब अध्यापक",
          "allschools": "सभी विद्यालय",
          "schoolname": "विद्यालय का नाम",
          "teacheraddress": "शिक्षक का पता दर्ज करें",
          "district": "जिला दर्ज करें",
          "chooselevel1": 'लेवल-1 चुनें',
          "chooselevel2": 'लेवल-2 चुनें',
          "noticesendto": 'इसे भेजें चुनें',
          "noticereason": 'नोटिस का कारण दर्ज करें',
          "filetypewarning": 'फाइल jpg, png, pdf होनी चाहिए',
          "notifications": 'सूचनाएं',
          "createnotif": 'सूचनाएं बनाएं',
          "sentnotif": 'सूचनाएं भेजीं हुई',
          "receivednotif": 'मौजूदा सूचनाएं',
          "noticeschoollevel": "स्कुल स्तर दर्ज करें",
          "teacherreportwarning": 'कृपया रिपोर्ट तैयार करने के लिए तिथि सीमा चुनें',
          "leavetype": 'छुट्टी का प्रकार',
          "totalleave": 'कुल छुट्टी',
          "studentreportlevel": 'स्तर चुनें',
          "enterdetails": 'विवरण दर्ज करें',
          "timetable": "समय सारणी",
          "addcell": "एक सेल जोड़ें",
          "section": "अनुभाग",
          "choosesection": "अनुभाग चुनें",
          "starttime": "प्रारंभ समय",
          "endtime": "अंत समय",
          "choosestarttime": "प्रारंभ समय चुनें",
          "chooseendtime": "अंत समय चुनें",
          "entersubject": "विषय दर्ज करें",
          "enterroom": "कमरा नंबर लिखें",
          "enterteachername": "शिक्षक का नाम दर्ज करें",
          "chooseday": "दिन चुनें",
          "print": "प्रिंट करें",
          "update": "अद्यतन",
        },
      };
}
