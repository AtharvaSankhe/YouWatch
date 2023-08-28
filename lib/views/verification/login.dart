import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/controllers/signupController.dart';
import 'package:youwatchbuddy/views/verification/password.dart';
import 'package:youwatchbuddy/views/verification/signup.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final  signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.pinkAccent,
          image: DecorationImage(
            image: AssetImage('assets/login/bgLogin.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: 500,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                color: Colors.black.withOpacity(0.25),
                child: Column(
                  children: [
                    SizedBox(
                      height: 55,
                      child: TextFormField(
                        controller: signUpController.email,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(()=>const Password());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text(
                      'OR',
                      style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(1),
                    ),
                    ),
                    const SizedBox(height: 15,),
                    InkWell(
                      onTap: (){
                        signUpController.googleSignin();
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.g_mobiledata_sharp,size: 40,),
                            SizedBox(width: 35,),
                            Text(
                              'Continue with Google',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        // Get.to(()=>Phone());
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.phone_android,size: 40,),
                            SizedBox(width: 35,),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Continue with Mobile No.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      children: [
                        Text(
                          "Don't have an account ?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>const SignUp());
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 15,),
                    // const Align(
                    //   alignment: Alignment.bottomLeft,
                    //   child: Text(
                    //     "Forget your password ?",
                    //     style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
