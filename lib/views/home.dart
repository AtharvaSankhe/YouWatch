import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youwatchbuddy/controllers/homecontroller.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';
import 'package:youwatchbuddy/views/profilesection/userdetails.dart';
import 'package:youwatchbuddy/views/watchvideo.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              expandedHeight: 0,
              title: const Center(
                  child: Text(
                'YOUWATCH BUDDY',
                style: TextStyle(color: Colors.white60, fontSize: 20),
              )),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.amberAccent,
                      size: 30,
                    ))
              ],
              leading: GestureDetector(
                onTap: (){
                  Get.to(()=>const UserDetails());
                },
                child: Container(
                  height: 10,
                  width: 10,
                  padding: const EdgeInsets.all(7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: AuthenticationRepository.instance.currentUserInfo.value.imagePath==''?
                        Image.asset('assets/login/loginAvatar.png')
                        :
                    FadeInImage(
                      image: NetworkImage(AuthenticationRepository.instance.currentUserInfo.value.imagePath??
                          ""),
                      // height: 200,
                      placeholder: const AssetImage('assets/login/loginAvatar.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              floating: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 25),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          cursorColor: Colors.grey.shade800,
                          controller: searchController,
                          onChanged: (value) {
                            homeController.searchVideo(value.toLowerCase());
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:  BorderSide(color: Colors.grey.shade800)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:  BorderSide(color: Colors.grey.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:  BorderSide(color: Colors.grey.shade800)),
                          ),
                        ),
                      ),
                    ),
                  ]
                )),
          ],
          floatHeaderSlivers: true,
          body: homeController.allVideos.isEmpty
              ?
              // const Center(
              //   child: SpinKitThreeBounce(
              //     color: Colors.white,
              //   ),
              // )
              SizedBox(
                  height: 500,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 40,
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade900,
                        highlightColor: Colors.grey.shade300,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: double.infinity,
                          height: 200,
                          alignment: Alignment.center,
                          color: Colors.grey.shade900,
                        ),
                      );
                    },
                  ),
                )
              : ListView.separated(
                  itemCount: homeController.allVideos.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 40,
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    int index = homeController.allVideos.length - 1 - i;
                    return GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            Watch(video: homeController.allVideos[index]));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: NetworkImage(
                                homeController.allVideos[index].thumbnailUrl ??
                                    "",
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.25,
                            )),
                        child: Stack(
                          children: [
                            const SizedBox(
                              height: 200,
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 200,
                              child: Align(
                                alignment: Alignment.center,
                                child: FadeInImage(
                                  image: NetworkImage(homeController
                                          .allVideos[index].thumbnailUrl ??
                                      ""),
                                  // height: 200,
                                  placeholder: const AssetImage(
                                      'assets/gifs/loader.gif',),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Watch Now',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )),
                            Positioned(
                              bottom: 10,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        homeController.allVideos[index].title!,
                                        style: const TextStyle(
                                          color: Colors.amberAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      homeController.allVideos[index].userName!,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.65),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
        // return ListView.builder(
        //   itemCount: homeController.allVideos.length,
        //   itemBuilder: (BuildContext context, int index) {
        //   return Container(
        //     // child: Text(homeController.allVideos[index]),
        //     child: FadeInImage(
        //       image: NetworkImage(homeController.allVideos[index]),
        //       placeholder: const AssetImage('assets/login/bgLogin.png'),
        //     ),
        //   );
        // },);
      }),
    );
  }
}
