import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:youwatchbuddy/bottom_nav.dart';
import 'package:youwatchbuddy/global.dart';
import 'package:youwatchbuddy/models/videoModel.dart';
import 'package:youwatchbuddy/views/home.dart';


class UploadController extends GetxController {

  compressVideoFile(String videoFilePath) async {
    final compressedVideoFilePath = await VideoCompress.compressVideo(
        videoFilePath, quality: VideoQuality.DefaultQuality);
    return compressedVideoFilePath!.file;
  }

  getThumbnailImage(String videoFilePath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoFilePath);
    return thumbnail;
  }

  uploadCompressedVideoFileToFirebaseStorage(String videoID,
      String videoFilePath) async {
    UploadTask videoUploadTask = FirebaseStorage.instance.ref().child(
        'All Videos').child(videoID).putFile(
        await compressVideoFile(videoFilePath));
    TaskSnapshot snapshot = await videoUploadTask;
    String downloadUrlOfUploadVideo = await snapshot.ref.getDownloadURL();
    return downloadUrlOfUploadVideo;
  }

  uploadCompressedThumbnailImageToFirebaseStorage(String videoID,
      String videoFilePath) async {
    UploadTask thumbnailUploadTask = FirebaseStorage.instance.ref().child(
        'All Thumbnails').child(videoID).putFile(
        await getThumbnailImage(videoFilePath));
    TaskSnapshot snapshot = await thumbnailUploadTask;
    String downloadUrlOfUploadedThumbnail = await snapshot.ref.getDownloadURL();
    return downloadUrlOfUploadedThumbnail;
  }

  saveVideoInfoToFirebase(String title, String description, String category,
      String videoFilePath, BuildContext context) async {
    try {
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection('users').doc(
          FirebaseAuth.instance.currentUser!.email.toString()).get();

      Get.snackbar("Starting",'Starting');
      String videoID = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      Get.snackbar("DateTime",'DateTime');

      // upload to Storage
      String videoDownloadUrl = await uploadCompressedVideoFileToFirebaseStorage(
          videoID, videoFilePath);
      Get.snackbar("videoUrl",'videoUrl');

      //upload thumbail
      String thumbnailDownloadUrl = await uploadCompressedThumbnailImageToFirebaseStorage(
          videoID, videoFilePath);
      Get.snackbar("thumbnail",'thambnail');

      //save to firestore
      Video videoObject = Video(
          userEmail: FirebaseAuth.instance.currentUser!.email.toString(),
          userName: (userDocumentSnapshot.data() as Map<String, dynamic>)['name'],
        videoID: videoID,
        title: title,
        description: description,
        category: category,
        videoUrl: videoDownloadUrl,
        thumbnailUrl: thumbnailDownloadUrl,
        publishedDateTime: DateTime.now().millisecondsSinceEpoch,
        comments: 0,
        likesList: [],
      );

      Get.snackbar("New Video", "Video to Storage done bro");
      await FirebaseFirestore.instance.collection("videos").doc(videoID).set(videoObject.toJson());
      print('video collection =====================++++++++');
      Get.snackbar("New Video", "firestore done bro");

      showProgessbar = false ;
      print('here is the issue');
      Get.offAll(()=>const BottomNav());
      Get.snackbar("New Video", "Video Successful uploaded");
    } catch (e) {
      Fluttertoast.showToast(msg: 'Video Upload Unsuccessful');
      debugPrint(e.toString());
    }
  }

}