import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/global.dart';
import 'package:youwatchbuddy/models/videomodel.dart';

class LikeController extends GetxController {
  static LikeController get instance => Get.find();

  // this is the method to fetch storage data But I have already taken the URL of stored data in the database so no need to use this
  // final _fireStore = FirebaseStorage.instance ;
  //
  // RxList<String> allVideos = <String>[].obs ;
  //
  // Future<void> fetchVideos() async{
  //   ListResult videosList = await _fireStore.ref('All Thumbnails').listAll() ;
  //   List<Reference> videos = videosList.items ;
  //   for (Reference video in videos){
  //     allVideos.add( await video.getDownloadURL());
  //   }
  // }
  final _firebaseFirestore = FirebaseFirestore.instance;

  RxList<Video> allVideos = <Video>[].obs;
  List<Video> fetchAllVideos = [];

  Future<void> fetchVideos() async {
    try{
      final querySnapshot = await _firebaseFirestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .collection('likes')
          .get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (int i = 0; i < documents.length; i++) {
        fetchAllVideos.add(Video.fromDocumentSnapShot(documents[i]));
      }

      allVideos.value = fetchAllVideos;
      GlobalController.instance.showProgessbar.value= false;
      debugPrint('${allVideos[0].title}=======================+');
    } on FirebaseException catch(e){
      Get.back();
      Fluttertoast.showToast(msg: 'Something went wrong');
    }


    // final snapshot = await _firebaseFirestore.collection("users").doc(currentUser!.uid).collection('allTask').get();
    // final allTasks = snapshot.docs.map((e) => Task.fromSnapshot(e)).toList();
    // return allTasks ;
  }

  searchVideo(value) {
    allVideos.value = fetchAllVideos
        .where((element) =>
            element.title!.toLowerCase().contains(value.toLowerCase()) ||
            element.userName!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    if (allVideos.isEmpty) {
      Fluttertoast.showToast(msg: 'No match found');
      allVideos.value = fetchAllVideos;
    }

    if (value.isBlank || allVideos.isEmpty) {
      allVideos.value = fetchAllVideos;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    try{
      GlobalController.instance.showProgessbar.value = true ;
      fetchVideos();
    } catch(e){
      debugPrint('hello');
      Get.snackbar('No Liked Videos', "You haven't liked any video yet");
      Get.back();
    }
  }
}
