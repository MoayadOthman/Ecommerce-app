import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:last/screens/user_panel/notificationscreen.dart';
import 'package:last/screens/user_panel/product/allproductsscreen.dart';
import 'package:last/screens/user_panel/searchscreen.dart';
import 'package:last/utils/appconstant.dart';

import 'profile/profilescreen.dart';
import 'cart/cartscreen.dart';
import 'favoritesscreen.dart';
import 'mainscreen.dart';

class BottomNav extends StatefulWidget {
  BottomNav({super.key});
  @override
  State<BottomNav> createState() => _BottomNavState();
  User? user = FirebaseAuth.instance.currentUser;

}

class _BottomNavState extends State<BottomNav> {
  int _bottomNavIndex = 0;

  //حالة اردت إضتفة اسم اسفل icons
  // List<String> titleList = [
  //   'Home',
  //   "Favorite",
  //   "Cart",
  //   "Profile",
  // ];
  List<IconData> iconList = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.person,
  ];

  List<Widget> pages = [
    const MainScreen(),
    const FavoriteScreen(),
    CartScreen(userId:user!.uid),
    const ProfileScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () {
          // Get.to(()=>ProductSearchScreen());
        },
        backgroundColor: AppConstant.appMainColor,
        child: const Icon(Icons.search,color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        elevation: 10,
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isActive)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppConstant.appMainColor,
                      width: 2,
                    ),
                  ),
                ),
              Icon(iconList[index],
                color: isActive ? AppConstant.appMainColor : Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
