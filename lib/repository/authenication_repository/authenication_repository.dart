import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/bottom_nav.dart';
import 'package:youwatchbuddy/main.dart';
import 'package:youwatchbuddy/views/verification/login.dart';
import 'package:youwatchbuddy/views/home.dart';


class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance ;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser =  Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user){
    user==null? Get.offAll(()=>const Login()):Get.offAll(()=>const BottomNav());
  }

  Future<void> createUserWithEmailAndPassowrd(String email, String password, String name) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(()=>const BottomNav()):Get.offAll(()=>const Login());

      _firebaseFirestore.collection('users').doc(firebaseUser.value!.email).set(
          {'email': email, 'name': name, 'imagePath': '', 'password':password});

    }on FirebaseAuthException catch(e){
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
  Future<void> loginUserWithEmailAndPassowrd(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(()=>const BottomNav()):Get.offAll(()=>const Login());

    }on FirebaseAuthException catch(e){
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<void> logout() async {
    try{
      await _auth.signOut();
      Get.offAll(()=>const Login());
    }on FirebaseAuthException catch(e){
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

}