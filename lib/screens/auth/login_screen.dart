import "dart:developer";
import "dart:io";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import "package:messaging/api/apis.dart";
import "package:messaging/helper/dialogs.dart";
import "package:messaging/main.dart";
import "package:messaging/screens/home_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isAnimate = false;

  @override
  Widget build(BuildContext context) {
    //mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      title: const Text('Welcome to Messaging'),
      ),
      body: Stack(children: [
        AnimatedPositioned(
          top:mq.height *.15,
          width: mq.width *.5,
          right: _isAnimate ? mq.width *.25 : -mq.width *.5,
          duration: Duration(seconds: 1),
          child: Image.asset('images/icon.png')),

        Positioned(
          bottom:mq.height *.15,
          width: mq.width *.7,
          left: mq.width *.15,
          height: mq.height *.06,
          child:ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue.shade200,
            shape: StadiumBorder(),
            elevation: 1),
            onPressed: (){
              _handleGoogleBtnClick();
            },
            icon: Image.asset('images/google.png',height: mq.height*.045),
            label: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 18),
                children: [
                TextSpan(text: "Continue with "),
                TextSpan(text: "Google", style: TextStyle(fontWeight: FontWeight.w700)),
            ])))
          )
        ]
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate = true;
      });
    });
  }

_handleGoogleBtnClick(){
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      
      if(user != null){
      log('\nUser: ${user.user}');
      log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
      if((await APIs.userExists())){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }else{
        await APIs.createUser().then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        });
      }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
  try{
  await InternetAddress.lookup('google.com');
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await APIs.auth.signInWithCredential(credential);
  }catch(e){
    log('\n_signInWithGoogle: $e');
    Dialogs.showSnackbar(context, 'Something went Wrong (Check Internet Connection)');
    return null;
  }
}
}