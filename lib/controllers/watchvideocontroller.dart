import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/models/videomodel.dart';



class WatchVideoController extends GetxController{
  static WatchVideoController get instance => Get.find();
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  RxBool isLiked = false.obs ;
  RxBool isDisliked = false.obs ;
  RxBool isFav = false.obs ;



  Future<void> likeVideo(Video video) async {
    try {
      isLiked.value = true;

      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.email.toString())
          .collection('likes')
          .doc(video.videoID)
          .set(video.toJson());
      Fluttertoast.showToast(msg: 'Video is liked ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      isLiked.value = false;
    }
  }

  Future<void> dislikeVideo(Video video) async {
    try {
      isDisliked.value = true;
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.email.toString())
          .collection('dislikes')
          .doc(video.videoID)
          .set(video.toJson());
      Fluttertoast.showToast(msg: 'Video is disliked ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      isDisliked.value = false;
    }
  }

  Future<void> addFav(Video video) async {
    try {
      isFav.value = true;
      DocumentSnapshot userInfo = await _firebaseFirestore.collection('users').doc(video.userEmail).get();
      Map<String,dynamic> data = userInfo.data() as Map<String,dynamic>;
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.email.toString())
          .collection('favs')
          .doc(video.userEmail)
          .set({'email':data['email'],'imagePath':data['imagePath'],'name':data['name']});
      Fluttertoast.showToast(msg: 'Creator added to Favs 💗 ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      isFav.value = false;
    }
  }

  Future<void> unlikeVideo(Video video) async {
    try {
      isLiked.value = false;
      await _firebaseFirestore.collection('users').doc(_firebaseAuth.currentUser!.email.toString()).collection('likes').doc(video.userEmail).delete();
      Fluttertoast.showToast(msg: 'Video is removed from liked videos ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      isLiked.value = true;
    }
  }
  Future<void> undislikeVideo(Video video) async {
    try {
      isDisliked.value = false;
      await _firebaseFirestore.collection('users').doc(_firebaseAuth.currentUser!.email.toString()).collection('dislikes').doc(video.videoID).delete();
      Fluttertoast.showToast(msg: 'Video is removed from disliked videos ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      isDisliked.value = true;

    }
  }
  Future<void> removeFav(Video video) async {
    try {
      isFav.value = false;
      await _firebaseFirestore.collection('users').doc(_firebaseAuth.currentUser!.email.toString()).collection('favs').doc(video.userEmail).delete();
      Fluttertoast.showToast(msg: 'Creator removed from Favs 💔 ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      isFav.value = true;

    }
  }

  Future<void> findisLiked(Video video) async{
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('users').doc(_firebaseAuth.currentUser!.email.toString()).collection('likes')
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.id == video.videoID) {
          isLiked.value = true; // Found the target ID in the collection
        } else{
          false ;
        }
      }
    } catch (e) {

      isLiked.value = false ; // Error occurred or target ID not found
    }
  }
  Future<void> findisDisLiked(Video video) async{
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('users').doc(_firebaseAuth.currentUser!.email.toString()).collection('dislikes')
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.id == video.videoID) {
          isDisliked.value = true; // Found the target ID in the collection
          return;
        } else{
          false ;
        }
      }
    } catch (e) {
      isDisliked.value = false ; // Error occurred or target ID not found
    }
  }
  Future<void> findisFav(String email) async{
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('users').doc(_firebaseAuth.currentUser!.email.toString()).collection('favs')
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.id == email) {
          isFav.value = true; // Found the target ID in the collection
          return;
        } else{
          false ;
        }
      }
    } catch (e) {
      isDisliked.value = false ; // Error occurred or target ID not found
    }
  }




}