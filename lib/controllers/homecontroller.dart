import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/models/videomodel.dart';

class HomeController extends GetxController{
  static HomeController  get instance => Get.find() ;

  final _fireStore = FirebaseStorage.instance ;

  RxList<String> allVideos = <String>[].obs ;

  Future<void> fetchVideos() async{
    ListResult videosList = await _fireStore.ref('All Thumbnails').listAll() ;
    List<Reference> videos = videosList.items ;
    for (Reference video in videos){
      allVideos.add( await video.getDownloadURL());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchVideos() ;

  }


}