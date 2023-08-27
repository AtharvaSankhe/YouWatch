import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/controllers/favcreatorcontroller.dart';

class FavCreators extends StatelessWidget {
  FavCreators({Key? key}) : super(key: key);

  final FavCreatorController favCreatorController =
      Get.put(FavCreatorController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'YOUWATCH BUDDY',
                style: TextStyle(color: Colors.white60, fontSize: 20),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white60,
                  size: 30,
                ),
              ),
              floating: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    cursorColor: Colors.grey.shade800,
                    onChanged: (value) {
                      favCreatorController.searchVideo(value.toLowerCase());
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade300,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white38)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white38),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white38)),
                    ),
                  ),
                ),
              ),
            ])),
          ],
          floatHeaderSlivers: true,
          body: ListView.separated(
            itemCount: favCreatorController.favCreators.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              height: 25,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(15),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade900,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            favCreatorController.favCreators[index].imagePath ==
                                    ''
                                ? Image.asset(
                                    'assets/login/loginAvatar.png',
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    favCreatorController
                                            .favCreators[index].imagePath ??
                                        "".toString(),
                                    fit: BoxFit.fill,
                                  ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.35,
                      child: Center(
                        child: Text(
                          favCreatorController.favCreators[index].name ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Videos: ',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '15 ',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                    //no. of videos
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
