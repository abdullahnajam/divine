import 'dart:async';

import 'package:divine/auth/login.dart';
import 'package:divine/auth/register.dart';
import 'package:divine/bottom_navigation.dart';
import 'package:divine/screens/home.dart';
import 'package:divine/values/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {

  static String routeName = "/splash";
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;
  bool showActionButtons=false;
  bool showLoading=true;

  @override
  void initState() {
    super.initState();
    _loadWidget();
    initPlatfromState();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    User user=FirebaseAuth.instance.currentUser;
    if(user==null){
      setState(() {
        showLoading=false;
        showActionButtons=true;

      });
    }
    else{
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, child: BottomBar()));
    }

  }

  Future<void> initPlatfromState(){

    OneSignal.shared.init(
        oneSignalAppId
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset('assets/images/splash.png',fit: BoxFit.cover,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Image.asset('assets/images/logo.png'),
              ),

            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: showLoading,
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              height: showActionButtons?MediaQuery.of(context).size.height*0.2:0,
              child: Column(
                children: [

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Register()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColorDark,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.7,

                      height: 50,
                      child: Text("Get Started",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Login()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.7,

                      height: 50,
                      child: Text("Login",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
