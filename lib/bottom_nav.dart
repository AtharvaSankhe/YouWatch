import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';
import 'package:youwatchbuddy/views/chatroom/chatscreen.dart';
import 'package:youwatchbuddy/views/home.dart';
import 'package:youwatchbuddy/views/profile.dart';
import 'package:youwatchbuddy/views/watchvideo.dart';
import 'package:youwatchbuddy/views/upload.dart';

import 'main.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthenticationRepository.instance.currentUserInfo.value.email)
        .update({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  int _selectedindex = 0;

  void _navigation(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  final List<Widget> _pages = [
    Home(),
    const PostVideo(),
    ChatScreen(),
    const Profile(),
    // const Likes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedindex),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8),
        child: GNav(
          gap: 7,
          padding: const EdgeInsets.all(15),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          backgroundColor: Colors.black,
          color: Colors.white60,
          activeColor: Colors.amberAccent,
          // tabActiveBorder: Border.all(color: Colors.white),
          // tabBorder: Border.all(color: Colors.black),
          tabBackgroundColor: Colors.grey.shade800,
          tabBorderRadius: 25,
          selectedIndex: _selectedindex,
          onTabChange: _navigation,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.post_add,
              text: 'Upload',
            ),
            GButton(
              icon: Icons.chat,
              text: 'Chat',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// class Bottom_Nav extends StatefulWidget {
//   const Bottom_Nav({Key? key}) : super(key: key);
//
//   @override
//   State<Bottom_Nav> createState() => _Bottom_NavState();
// }
//
// class _Bottom_NavState extends State<Bottom_Nav> {
//   int _selectedindex = 0 ;
//
//   void _navigation(int index){
//     setState(() {
//       _selectedindex = index ;
//     });
//   }
//
//   final List<Widget> _pages = [
//     Home(),
//     Cart(),
//     // const Cart(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedindex],
//       drawer: Drawer(
//         backgroundColor: Colors.black,
//         child: Drawers(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedindex,
//         onTap: _navigation,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'Cart'),
//         ],
//
//       ),
//     );
//   }
// }
