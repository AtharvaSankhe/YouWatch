import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/bottom_nav.dart';
import 'package:youwatchbuddy/controllers/signupController.dart';
import 'package:youwatchbuddy/global.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';
import 'package:youwatchbuddy/views/verification/login.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
      .then((value) => Get.put(AuthenticationRepository()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
        home: Splash() ,
    );
  }
}


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  final  signUpController = Get.put(SignUpController());
  final  globalController = Get.put(GlobalController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(const Duration(milliseconds: 2500), () {
    //   Get.offAll(()=>const BottomNav());
    // });
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: height,
        width: width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset("assets/login/video.gif",height: height*0.75,width: width*0.75,),
            Text('YOUWATCH BUDDY',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
          ],
        ),
      ),
    );
  }
}

