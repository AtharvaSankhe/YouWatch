// import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:get/get.dart';
// // import 'package:todo/firebase/curd.dart';
// import 'package:todo/firebase/emailauth.dart';
// import 'package:flutter/material.dart';
// import 'package:todo/screens/verification/otp.dart';
// // import 'package:todo/screens/taskscreen.dart';
//
// class Phone extends StatefulWidget {
//   Phone({Key? key}) : super(key: key);
//
//   @override
//   State<Phone> createState() => _PhoneState();
// }
//
// class _PhoneState extends State<Phone> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final User? user = Auth().currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Container(
//         height: height,
//         width: width,
//         alignment: Alignment.center,
//         // padding: const EdgeInsets.all(18),
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/login/loginBg.jpg'),
//               fit: BoxFit.cover,
//             )),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18.0),
//               child: Text(
//                 'Sign up',
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white.withOpacity(1),
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 25, vertical: 20),
//                     color: Colors.black.withOpacity(0.25),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Looks like you don't have an account.",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white.withOpacity(1),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "Let's create a new account ",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white.withOpacity(1),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         SizedBox(
//                           height: 55,
//                           child: TextFormField(
//                             controller: nameController,
//                             keyboardType: TextInputType.name,
//                             cursorColor: Colors.grey,
//                             decoration: InputDecoration(
//                                 hintText: 'Name',
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: const BorderSide(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: const BorderSide(
//                                     color: Colors.white,
//                                   ),
//                                 )),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         SizedBox(
//                           height: 55,
//                           child: TextFormField(
//                             controller: phoneController,
//                             keyboardType: TextInputType.number,
//                             cursorColor: Colors.grey,
//                             decoration: InputDecoration(
//                                 hintText: 'Phone No.',
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: const BorderSide(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: const BorderSide(
//                                     color: Colors.white,
//                                   ),
//                                 )),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Text(
//                           "By selecting Agree and continue below, I agree to Terms of Service and Privacy Policy",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white.withOpacity(0.7),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         InkWell(
//                           onTap: () async {
//
//                             try{
//                               await Auth().phoneAuthentication(phoneController.text.trim());
//                               Get.to(()=>const OTP());
//
//                             } catch(e){
//                               Fluttertoast.showToast(msg: 'Something went wrong');
//                             }
//                             // await Auth().createUserWithEmailAndPassword(
//                             //     email: phoneController.text,
//                             //     name: nameController.text
//                             // );
//
//                             // if(newUser != null){
//                             //   Get.offAll(()=>const TasksScreen());
//                             // }
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             height: 55,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               'VERIFY',
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white.withOpacity(0.85),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
