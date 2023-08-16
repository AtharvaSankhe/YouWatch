import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youwatchbuddy/views/videodetails.dart';

class PostVideo extends StatefulWidget {
  const PostVideo({Key? key}) : super(key: key);

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {

  getVideoFile(ImageSource sourceImg) async{
    final videoFile = await ImagePicker().pickVideo(source: sourceImg);

    if(videoFile != null){
      // get to video upload form where you put all the data for video
      Get.to(
              VideoDetails(videoFile: File(videoFile.path),videoPath: videoFile.path),
      );
    }else{
      Fluttertoast.showToast(msg: 'Video is not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Column(
          children: [
            TextButton(onPressed: () {
              getVideoFile(ImageSource.gallery);
            },
                child: const Text('from gallery')),
            TextButton(onPressed: () {
              getVideoFile(ImageSource.camera);

            },
                child: const Text('shoot from camera')),
          ],
        ),
      ),
    );
  }
}
