import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numsai/utils/local_string.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:numsai/screens/splash_page.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPager(),
    );
  }
}

class MyPager extends StatefulWidget {
  @override
  _MyPagerState createState() => _MyPagerState();
}

class _MyPagerState extends State<MyPager> {
  final PageController _pageController = PageController();
  final List<Widget> screens = [
    WelcomeScreen(),
    GeneralInfoScreen(),
    FeaturesScreen(),
    GetStartedScreen(),
    SplashScreen(),
  ];

  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: screens.length,
            itemBuilder: (BuildContext context, int index) {
              return screens[index];
            },
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _currentPageIndex > 0 ? () => _goToPage(_currentPageIndex - 1) : null,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: _currentPageIndex < screens.length - 1 ? () => _goToPage(_currentPageIndex + 1) : null,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double circleSize = screenSize.width * 1.4;

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: screenSize.width * 0.5 - circleSize * 0.5,
            top: screenSize.height * 0.5 - circleSize * 0.5,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: circleSize * 0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                    SizedBox(height: 60),
                    Text(
                      'Get started to experience the full potential of',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/images/namsai_rmbg.png',
                      height: 60,
                    ),
                    Text(
                      'Namsai SMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'An all-in-one solution for \n managing your daily needs',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 60),
                    Text(
                      'Let us get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -MediaQuery.of(context).size.width * 1.3, 
            top: -MediaQuery.of(context).size.height * 0.5, 
            child: Container(
              width: MediaQuery.of(context).size.width * 2.2, 
              height: MediaQuery.of(context).size.width * 1.5, 
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
          ),
          Positioned(
            right: -MediaQuery.of(context).size.width * 1.3, 
            top: -MediaQuery.of(context).size.height * 0.5, 
            child: Container(
              width: MediaQuery.of(context).size.width * 3, 
              height: MediaQuery.of(context).size.width * 1.4, 
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
          ),
          Positioned(
            right: -MediaQuery.of(context).size.width * 1.3, 
            top: -MediaQuery.of(context).size.height * 0.5, 
            child: Container(
              width: MediaQuery.of(context).size.width * 2.5, 
              height: MediaQuery.of(context).size.width * 1.4, 
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class GeneralInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.grey[200],
          ),
        ),
        Positioned(
          left: -MediaQuery.of(context).size.width * 1.3, 
          top: MediaQuery.of(context).size.height * 0.1, 
          child: Container(
            width: MediaQuery.of(context).size.width * 2.5, 
            height: MediaQuery.of(context).size.width * 2.5, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
        ),
        Positioned(
          right: -MediaQuery.of(context).size.width * 1.3, 
          top: MediaQuery.of(context).size.height * 0.13, 
          child: Container(
            width: MediaQuery.of(context).size.width * 1.6, 
            height: MediaQuery.of(context).size.width * 1.6, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
        ),
        Container(
          child: Center(
            child: Padding(
      			  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
      			  child: Column(
      			    mainAxisAlignment: MainAxisAlignment.center,
      			    children: [
      			      Text(
      			        'Developer Information',
      			        textAlign: TextAlign.center,
      			        style: TextStyle(
      			          fontSize: 32,
      			          fontWeight: FontWeight.bold,
      			          color: Colors.purple[700],
      			        ),
      			      ),
      			      SizedBox(height: 80),
      			      Text(
      			        'This app is designed as a \n School Management System \n for \n Namsai Education Department of \n Namsai District, Arunachal Pradesh',
      			        textAlign: TextAlign.center,
      			        style: TextStyle(fontSize: 18),
      			      ),
      			      SizedBox(height: 60),
      			      Text(
      			        'Developed by',
      			        textAlign: TextAlign.center,
      			        style: TextStyle(fontSize: 18),
      			      ),
      			      SizedBox(height: 40),
                  Image.asset(
                    'assets/images/asilia_rmbg.png',
                    height: 40,
                  ),
                  SizedBox(height: 20),
      			      Text(
      			        'Asilia Technologies Private Limited',
      			        textAlign: TextAlign.center,
      			        style: TextStyle(
      			          fontSize: 22,
      			          fontWeight: FontWeight.bold,
      			          color: Colors.purple[700],
      			        ),
      			      ),
      			    ],
      			  ),
      			),
          ),
        ),
      ],
    );
  }
}


class FeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.grey[200],
          ),
        ),
        Positioned(
          left: -MediaQuery.of(context).size.width * 1.3, 
          top: MediaQuery.of(context).size.height * 0.1, 
          child: Container(
            width: MediaQuery.of(context).size.width * 2.5, 
            height: MediaQuery.of(context).size.width * 2.5, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
        ),
        Positioned(
          right: -MediaQuery.of(context).size.width * 1.3, 
          top: MediaQuery.of(context).size.height * 0.13, 
          child: Container(
            width: MediaQuery.of(context).size.width * 1.6, 
            height: MediaQuery.of(context).size.width * 1.6, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
        ),
        Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Features',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  SizedBox(height: 60),
                  Text(
                    'With this app, you can',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 40),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text('Manage attendance'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text('Generate student and teacher reports'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text('Manage timetables'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text('Teacher and School Management'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.grey[200],
          ),
        ),
        Positioned(
          left: -MediaQuery.of(context).size.width * 1.3, 
          top: MediaQuery.of(context).size.height * 0.1, 
          child: Container(
            width: MediaQuery.of(context).size.width * 2.5, 
            height: MediaQuery.of(context).size.width * 2.5, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
        ),
        Positioned(
          right: -MediaQuery.of(context).size.width * 1.3, 
          top: MediaQuery.of(context).size.height * 0.13, 
          child: Container(
            width: MediaQuery.of(context).size.width * 1.6, 
            height: MediaQuery.of(context).size.width * 1.6, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
        ),
        Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'All done!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  SizedBox(height: 60),
                  Text(
                    'You are good to go! \n\n Login and start using the app',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
