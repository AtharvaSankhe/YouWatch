import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/controllers/homecontroller.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (homeController.allVideos.isEmpty) {
          return const CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: homeController.allVideos.length,
          itemBuilder: (BuildContext context, int index) {
          return Container(
            // child: Text(homeController.allVideos[index]),
            child: FadeInImage(
              image: NetworkImage(homeController.allVideos[index]),
              placeholder: const AssetImage('assets/login/bgLogin.png'),
            ),
          );
        },);
      }
    ),
    );
  }
}
