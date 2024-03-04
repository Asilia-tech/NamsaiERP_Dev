import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numsai/screens/login_page.dart';
import 'package:numsai/screens/splash_page.dart';
import 'package:numsai/constants.dart';
import 'package:numsai/utils/local_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalString(),
      locale: const Locale('en', 'US'),
      title: Constants.APPNAME,
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.primaryColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/login': (context) => const PhoneLogin(),
      },
    );
  }
}
