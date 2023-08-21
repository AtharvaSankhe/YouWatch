import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
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

  String _videoDuration(Duration duration){
    String twoDigits(int n)=> n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours>0)hours,
      minutes,
      seconds,
    ].join(':');
  }

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
    watchVideoController.findisDisLiked(widget.video);
    watchVideoController.findisFav(widget.video.userEmail.toString());
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ValueListenableBuilder(
                            valueListenable: playerController!,
                            builder: (context,VideoPlayerValue value,child){
                              return Text(
                                _videoDuration(value.position),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 12,
                          child: VideoProgressIndicator(
                              playerController!,
                              allowScrubbing: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ValueListenableBuilder(
                            valueListenable: playerController!,
                            builder: (context,VideoPlayerValue value,child){
                              return Text(
                                _videoDuration(playerController!.value.duration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(
                              ()=> InkWell(
                                onTap: (){
                                  watchVideoController.isFav.value
                                      ? watchVideoController
                                      .removeFav(widget.video)
                                      : watchVideoController
                                      .addFav(widget.video);
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: watchVideoController.isFav.value?Colors.red:Colors.white60,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.favorite),
                                        Text(
                                          widget.video.userName ?? "",
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 25),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Obx(
                                      () => IconButton(
                                          onPressed: () {
                                            watchVideoController.isLiked.value
                                                ? watchVideoController
                                                    .unlikeVideo(widget.video)
                                                : watchVideoController
                                                    .likeVideo(widget.video);
                                          },
                                          icon:
                                              watchVideoController.isLiked.value
                                                  ? const Icon(
                                                      Icons.thumb_up_alt_sharp,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .thumb_up_alt_outlined,
                                                      color: Colors.white,
                                                    )),
                                    ),
                                    const Text(
                                      '  Like',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Obx(
                                          () => IconButton(
                                          onPressed: () {
                                            watchVideoController.isDisliked.value
                                                ? watchVideoController
                                                .undislikeVideo(widget.video)
                                                : watchVideoController
                                                .dislikeVideo(widget.video);
                                          },
                                          icon:
                                          watchVideoController.isDisliked.value
                                              ? Icon(
                                            Icons.thumb_down,
                                            color: Colors.grey.shade800,
                                          )
                                              : const Icon(
                                            Icons
                                                .thumb_down_alt_outlined,
                                            color: Colors.white,
                                          )),
                                    ),
                                    const Text(
                                      '  Dislike',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await Share.share(
                                            'CheckOut this Video\n${widget.video.videoUrl}');
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      '  Share',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () async {

                                      },
                                      icon: const Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      '  Download',
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
