import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:youwatchbuddy/controllers/uploadcontroller.dart';
import 'package:youwatchbuddy/global.dart';

class VideoDetails extends StatefulWidget {
  final File videoFile;
  final String videoPath ;
  const VideoDetails({Key? key,required this.videoFile,required this.videoPath}) : super(key: key);

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {

  UploadController uploadController = Get.put(UploadController());
  VideoPlayerController? playerController;
  TextEditingController titleController = TextEditingController() ;
  TextEditingController descriptionController = TextEditingController() ;
  String category = "";
  var categories = ['Educational','Entertainment','Informative','Sports','Gaming','Others'];

  @override
  void initState() {

    super.initState();

    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });

    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
    Timer(const Duration(milliseconds: 500),()=>setState(() {}));
  }

  Future<void> stopPlayer() async{
    playerController!.pause() ;
  }
  Future<void> resumePlayer() async{
    playerController!.play() ;
  }

  @override
  void dispose() {
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.back();},icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Video Details',style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                playerController!.value.isPlaying ? stopPlayer() : resumePlayer() ;
              },
              child: Container(
                  height: height*0.4,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(aspectRatio: playerController!.value.aspectRatio,child: VideoPlayer(playerController!),)
              ),
            ),
            GlobalController.instance.showProgessbar.isTrue?
            SizedBox(
              height: height*0.3,
              child:const SimpleCircularProgressBar(
                progressColors: [
                  Colors.green,
                  Colors.blueAccent,
                  Colors.red,
                  Colors.amber,
                  Colors.purpleAccent
                ],
                animationDuration: 20,
                backColor: Colors.white38,
              )
            ):
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  textDirection: TextDirection.ltr,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: titleController.text!=''?true:false ,
                    fillColor: Colors.grey.shade100,
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                    labelText: 'title of your video',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200,width: 1),
                      borderRadius: BorderRadius.circular(15),

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600,width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  textDirection: TextDirection.ltr,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: descriptionController.text!=''?true:false ,
                    fillColor: Colors.grey.shade100,
                    labelText: 'Enter description',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200,width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600,width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: DropdownButtonFormField(
                    // value: category,
                    icon: const Icon(
                      Icons
                          .keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: category!=''?true:false ,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(15), // Remove the padding within the field
                    ),
                    items: categories
                        .map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Category",
                      style: TextStyle(
                          color: Colors.grey.shade400,fontSize: 15,fontWeight: FontWeight.w700),
                    ),
                    isExpanded: true,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.black),
                    onChanged:
                        (String? newValue) {
                      setState(() {
                        category =
                        newValue!;
                        debugPrint(category);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: (){
                      if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && category != ''){
                        uploadController.saveVideoInfoToFirebase(titleController.text, descriptionController.text, category, widget.videoPath, context);
                      }
                      setState(() {
                        GlobalController.instance.showProgessbar.value = true ;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical:12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black54,
                      ),
                      child: const Text('UPLOAD',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
