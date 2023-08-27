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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,

          child: Container(
            height: height*0.66,
            width: width*0.75,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               Container(
                   height: height*0.25,
                   width: width*0.55,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(5),
                     color: Colors.amberAccent,
                   ),
                   child: Image.asset("assets/login/video.gif",height: height*0.75,width: width*0.75,),
               ),
                const Text('SELECT VIDEO',style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                InkWell(
                  onTap: (){
                    getVideoFile(ImageSource.gallery);
                  },
                  child: Container(
                    width: width*0.6,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Select from Gallery',style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                ),
                InkWell(
                  onTap: (){
                    getVideoFile(ImageSource.camera);
                  },
                  child: Container(
                    width: width*0.6,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Open Camera',style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
