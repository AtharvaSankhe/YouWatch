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
  RxList<Video> likedVideos = <Video>[].obs;
  RxBool isLiked = false.obs ;



  Future<void> likeVideo(Video video) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.email.toString())
          .collection('likes')
          .doc(video.videoID)
          .set(video.toJson());
      isLiked.value = true;
      Fluttertoast.showToast(msg: 'Video is liked ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  Future<void> unlikeVideo(Video video) async {
    try {
      await _firebaseFirestore.collection('users').doc(_firebaseAuth.currentUser!.email.toString()).collection('likes').doc(video.videoID).delete();
      isLiked.value = false;
      Fluttertoast.showToast(msg: 'Video is unliked ');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
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
      print("Error: $e");
      isLiked.value = false ; // Error occurred or target ID not found
    }
  }




}