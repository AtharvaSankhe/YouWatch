import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youwatchbuddy/controllers/signupController.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.yellow,
      body: Container(
        child: TextButton(
          onPressed: () { SignUpController.instance.logOut(); },
          child: const Text('SignOut'),

        ),
      )
    );
  }
}
