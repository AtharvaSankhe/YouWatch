import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:youwatchbuddy/views/home.dart';
import 'package:youwatchbuddy/views/profile.dart';
import 'package:youwatchbuddy/views/search.dart';
import 'package:youwatchbuddy/views/upload.dart';


import 'main.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedindex = 0 ;

  void _navigation(int index){
    setState(() {
      _selectedindex = index ;
    });
  }

  final List<Widget> _pages = [
        const Home(),
        const PostVideo(),
        const Profile(),
        // const Likes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: _pages.elementAt(_selectedindex),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8),
        child: GNav(
          gap: 7,
          padding: const EdgeInsets.all(15),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          // tabActiveBorder: Border.all(color: Colors.white),
          // tabBorder: Border.all(color: Colors.black),
          tabBackgroundColor: Colors.grey.shade800,
          tabBorderRadius: 25,
          selectedIndex: _selectedindex,
          onTabChange: _navigation,
          tabs:const [
            GButton(icon: Icons.home,text: 'Home',),
            GButton(icon: Icons.search,text: 'Search',),
            GButton(icon: Icons.person,text: 'Profile',),
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

