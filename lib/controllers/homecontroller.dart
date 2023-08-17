import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/models/videomodel.dart';

class HomeController extends GetxController{
  static HomeController  get instance => Get.find() ;


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

  RxList<Video> allVideos = <Video>[].obs ;

  Future<void> fetchVideos() async{

    final querySnapshot = await FirebaseFirestore.instance.collection('videos').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs ;
    for(int i = 0 ;i< documents.length ; i++){
      allVideos.add(Video.fromDocumentSnapShot(documents[i]));
    }

    debugPrint('${allVideos[0].title}=======================+');



    // final snapshot = await _firebaseFirestore.collection("users").doc(currentUser!.uid).collection('allTask').get();
    // final allTasks = snapshot.docs.map((e) => Task.fromSnapshot(e)).toList();
    // return allTasks ;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchVideos() ;

  }


}