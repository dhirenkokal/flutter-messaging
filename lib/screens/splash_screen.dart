import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:messaging/api/apis.dart";
import "package:messaging/main.dart";
import "package:messaging/screens/auth/login_screen.dart";
import "package:messaging/screens/home_screen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      title: const Text('Welcome to Messaging'),
      ),
      body: Stack(children: [
        Positioned(
          top:mq.height *.15,
          width: mq.width *.5,
          right: mq.width *.25,
          child: Image.asset('images/icon.png')),

        Positioned(
          bottom:mq.height *.15,
          width: mq.width,
          child: Text('Made By Dhiren Kokal 🖥️',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              letterSpacing: .3))),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white));
      if(APIs.auth.currentUser != null){
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }
}