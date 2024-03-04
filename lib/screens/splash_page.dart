import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numsai/screens/dashboard.dart';
import 'package:numsai/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();
    setState(() {
      _visible = !_visible;
    });
    Timer(const Duration(seconds: 3), navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome To ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 19, 18, 112),
                    fontSize: 35,
                    letterSpacing: 0.3),
              ),
              Text(
                Constants.APPNAME,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 19, 18, 112),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3),
              ),
              Image.asset(
                'assets/images/namsai_rmbg.png',
                width: animation.value * 200,
                height: animation.value * 200,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  "Version ${Constants.APPVERSION}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void navigationPage() {
    Get.to(const Dashboard());
  }
}
