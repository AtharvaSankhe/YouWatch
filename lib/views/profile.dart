import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youwatchbuddy/controllers/signupController.dart';
import 'package:youwatchbuddy/views/profilesection/favcreators.dart';
import 'package:youwatchbuddy/views/profilesection/likes.dart';
import 'package:youwatchbuddy/views/profilesection/userdetails.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            floating: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'YOUR PROFILE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                background: FadeInImage(
                  // image: NetworkImage('https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80'),
                  image:
                  // FirebaseAuth.instance.currentUser!.photoURL == null
                  //     ?
                  NetworkImage(
                          'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80'),
                  //     :
                  // NetworkImage(
                  //         FirebaseAuth.instance.currentUser!.photoURL ?? ""),
                  placeholder: AssetImage('assets/login/loginAvatar.png'),
                  fit: BoxFit.cover,
                )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                InkWell(
                  onTap: (){
                    Get.to(()=>const UserDetails());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: height*0.20,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                       image: AssetImage('assets/profile/details.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Text('USER DETAILS',style: TextStyle(color: Colors.white60,fontSize: 20,fontWeight: FontWeight.w700),),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Get.to(()=>Likes(isLikedScreen: 0,));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: height*0.20,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                       image:AssetImage('assets/profile/likes.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Text('LIKES',style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.w700),),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.to(()=>Likes(isLikedScreen: 1,));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: height*0.20,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:AssetImage('assets/profile/videos.jpg'),
                          fit: BoxFit.cover
                      ),
                    ),
                    child: const Text('YOUR VIDEOS',style: TextStyle(color: Colors.purpleAccent,fontSize: 20,fontWeight: FontWeight.w700),),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Fluttertoast.showToast(msg: 'Feature yet to be released');
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: height*0.20,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:AssetImage('assets/profile/shareapp.jpg'),
                          fit: BoxFit.cover
                      ),
                    ),
                    child: const Text('SHARE APP',style: TextStyle(color: Colors.blueAccent,fontSize: 20,fontWeight: FontWeight.w700),),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Get.to(()=>FavCreators());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: height*0.20,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:AssetImage('assets/profile/favcreators.jpg'),
                          fit: BoxFit.cover
                      ),
                    ),
                    child: const Text('FAV CREATORS',style: TextStyle(color: Colors.orangeAccent,fontSize: 20,fontWeight: FontWeight.w700),),
                  ),
                ),
                InkWell(
                  onTap: (){
                    SignUpController.instance.logOut();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: height*0.20,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:AssetImage('assets/profile/signout.jpg'),
                          fit: BoxFit.cover
                      ),
                    ),
                    child: const Text('SIGN OUT',style: TextStyle(color: Colors.yellowAccent,fontSize: 20,fontWeight: FontWeight.w700),),
                  ),
                ),

              ]
            ),
          )
        ],
      ),
    );
  }
}
