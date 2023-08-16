import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap:(){
          print(FirebaseAuth.instance.currentUser!.uid.toString());
        },
        child: Container(
          color: Colors.blue,
        ),
      ),
    );
  }
}
