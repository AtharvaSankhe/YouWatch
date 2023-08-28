import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/controllers/signupController.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';
import 'package:youwatchbuddy/views/profilesection/favcreators.dart';
import 'package:youwatchbuddy/views/profilesection/likes.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    nameController.text = AuthenticationRepository.instance.currentUserInfo.value.name??"";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _Auth = FirebaseAuth.instance;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white60,
            size: 25,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white60, fontSize: 25),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: AuthenticationRepository
                                  .instance.currentUserInfo.value.imagePath ==
                              ''
                          ? Image.asset('assets/login/loginAvatar.png')
                          :FadeInImage(
                        image: NetworkImage(AuthenticationRepository
                            .instance.currentUserInfo.value.imagePath ??
                            ""),
                        height: 200,
                        placeholder: const AssetImage(
                          'assets/gifs/loader.gif',),
                        fit: BoxFit.fill,
                      ),),
                          // : Image.network(AuthenticationRepository.instance.currentUserInfo.value.imagePath??"",fit: BoxFit.cover,),),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade900,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Name:    ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            width: width*0.52,
                            child: TextField(
                              controller: nameController,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          // Text(
                          //   AuthenticationRepository
                          //           .instance.currentUserInfo.value.name ??
                          //       "",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     color: Colors.grey.shade400,
                          //     fontSize: 15,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          // ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: 'Email Address cannot be altered 😔');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Email:    ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.52,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AuthenticationRepository
                                          .instance.currentUserInfo.value.email ??
                                      "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          FocusScope.of(context).unfocus();

                          try{
                            AuthenticationRepository.instance.currentUserInfo!.value.name = nameController.text;
                            await FirebaseFirestore.instance.collection('users').doc(AuthenticationRepository.instance.currentUserInfo!.value.email).update({'name':nameController.text});
                          } on FirebaseException catch(e){
                            Fluttertoast.showToast(msg: 'unable to update name');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => Likes(
                          isLikedScreen: 0,
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Liked Videos',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => Likes(
                          isLikedScreen: 1,
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'My Videos',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => FavCreators());
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Fav Creators',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
