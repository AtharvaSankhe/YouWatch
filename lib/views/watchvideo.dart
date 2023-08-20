import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:youwatchbuddy/controllers/homecontroller.dart';
import 'package:youwatchbuddy/controllers/watchvideocontroller.dart';
import 'package:youwatchbuddy/models/videomodel.dart';

class Watch extends StatefulWidget {
  Video video;

  Watch({Key? key, required this.video}) : super(key: key);

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  late VideoPlayerController? playerController;
  final WatchVideoController watchVideoController =
      Get.put(WatchVideoController());

  @override
  void initState() {
    super.initState();

    setState(() {
      playerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.video.videoUrl ?? ""));
    });
    playerController!.initialize().then((_) {
      setState(() {});
    });
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
    watchVideoController.findisLiked(widget.video);
  }

  Future<void> stopPlayer() async {
    playerController!.pause();
  }

  Future<void> resumePlayer() async {
    playerController!.play();
  }

  @override
  void dispose() {
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: playerController!.value.isInitialized
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        playerController!.value.isPlaying
                            ? stopPlayer()
                            : resumePlayer();
                      },
                      child: AspectRatio(
                        aspectRatio: playerController!.value.aspectRatio,
                        child: VideoPlayer(playerController!),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              widget.video.title ?? "",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30),
                            ))),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  widget.video.userName ?? "",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 25),
                                )),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Obx(
                                    ()=> IconButton(
                                          onPressed: () {
                                            watchVideoController.isLiked.value
                                                ? watchVideoController
                                                    .unlikeVideo(widget.video)
                                                : watchVideoController
                                                    .likeVideo(widget.video);
                                          },
                                          icon: watchVideoController.isLiked.value
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite_border_outlined,
                                                  color: Colors.white,
                                                )),
                                    ),
                                    const Text(
                                      '  Like',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: ()async{
                                        await Share.share('CheckOut this Video\n${widget.video.videoUrl}');
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '  Share',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Category: ${widget.video.category ?? ""}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Description: ${widget.video.description ?? ""}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox(
                height: height,
                width: width,
                child: const Center(
                  child: SpinKitThreeBounce(
                    color: Colors.white, // Set the color of the spinner
                    size: 35, // Set the size of the spinner
                  ),
                ),
              ),
      ),
    );
  }
}
