// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:hive/hive.dart';
// import 'package:todo/firebase/emailauth.dart';
//
// class OTP extends StatefulWidget {
//   const OTP({Key? key}) : super(key: key);
//
//   @override
//   State<OTP> createState() => _OTPState();
// }
//
// class _OTPState extends State<OTP> {
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     var otp;
//     return Scaffold(
//       body: Container(
//         height: height,
//         width: width,
//         alignment: Alignment.center,
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/login/loginBg.jpg'),
//               fit: BoxFit.cover,
//             )),
//         child: Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 25, vertical: 20),
//                 color: Colors.black.withOpacity(0.25),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                         'Enter Verification Code',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white.withOpacity(1),
//                       ),
//                     ),
//                     const SizedBox(height: 20,),
//                     OtpTextField(
//                       numberOfFields: 6,
//                       fieldWidth: 25,
//                       clearText: true,
//                       cursorColor: Colors.black,
//                       // enabledBorderColor: Colors.black,
//                       focusedBorderColor: Colors.black,
//                       borderColor: Colors.white,
//                       disabledBorderColor: Colors.white,
//                       onSubmit: (code){
//                         otp = code ;
//                         Auth().verifyOTP(otp);
//                       },
//                     ),
//                     const SizedBox(height: 20,),
//                     InkWell(
//                       onTap: () async {
//                         Auth().verifyOTP(otp);
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 55,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.25),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Hero(
//                           tag: 'text',
//                           child: Text(
//                             'Verify',
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white.withOpacity(0.85),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                             "Didn't receive any code? ",
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black.withOpacity(0.85),
//                           ),
//                         ),
//                         Text(
//                             "Resend OTP",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white.withOpacity(1),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
