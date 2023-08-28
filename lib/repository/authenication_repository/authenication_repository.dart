import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/bottom_nav.dart';
import 'package:youwatchbuddy/main.dart';
import 'package:youwatchbuddy/models/profilemodel.dart';
import 'package:youwatchbuddy/views/verification/login.dart';
import 'package:youwatchbuddy/views/home.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance ;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;
  Rx<Details> currentUserInfo = Details().obs ;

  @override
  void onReady() {
    firebaseUser =  Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async{
    if(user==null){
      Get.offAll(()=>const Login());
    }else{
      final document = await _firebaseFirestore.collection('users').doc(user.email.toString()).get();
      currentUserInfo.value = Details.fromDocumentSnapShot(document);
      Get.offAll(()=>const BottomNav());
    }

    // user==null? Get.offAll(()=>const Login()):Get.offAll(()=>const BottomNav());
  }

  Future<void> createUserWithEmailAndPassowrd(String email, String password, String name) async {
    try{
      //signin
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      //create fields in firebase
      _firebaseFirestore.collection('users').doc(firebaseUser.value!.email).set(
          {'email': email, 'name': name, 'imagePath': '', 'password':password});

      //put field values of currentUser into currentUserInfo
      final document = await _firebaseFirestore.collection('users').doc(email).get();
      currentUserInfo.value = Details.fromDocumentSnapShot(document);

      //naviagtion
      firebaseUser.value != null ? Get.offAll(()=>const BottomNav()):Get.offAll(()=>const Login());

    }on FirebaseAuthException catch(e){
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
  Future<void> loginUserWithEmailAndPassowrd(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final document = await _firebaseFirestore.collection('users').doc(email).get();
      currentUserInfo.value = Details.fromDocumentSnapShot(document);

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


  signinWithGoogle() async {
    //to get SHA1
    // cd android
    // ./gradlew signingReport



    // to sign in
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn() ;
    await GoogleSignIn().signOut();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication ;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    _firebaseFirestore.collection('users').doc(firebaseUser.value!.email).set(
        {'email': userCredential.user!.email.toString(), 'name': userCredential.user!.displayName, 'imagePath': userCredential.user!.photoURL.toString(), 'password':''});
    final document = await _firebaseFirestore.collection('users').doc(userCredential.user!.email.toString()).get();
    currentUserInfo.value = Details.fromDocumentSnapShot(document);
    if(userCredential.user != null){
      Get.offAll(()=>const BottomNav());
    }
    //to sign out

    // await GoogleSignIn().signOut();
    // FirebaseAuth.instance.signOut();

  }

}