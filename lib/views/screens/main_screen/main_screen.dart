import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:market_sphere_vendor/views/screens/navigation_screens/earnings_screen/earnings_screen.dart';
import 'package:market_sphere_vendor/views/screens/navigation_screens/edit_screen/edit_screen.dart';
import 'package:market_sphere_vendor/views/screens/navigation_screens/orders_screen/orders_screen.dart';
import 'package:market_sphere_vendor/views/screens/navigation_screens/uploads_screen/uploads_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  final pages = [
    EarningsScreen(),
    UploadsScreen(),
    EditScreen(),
    OrdersScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (selectedIndex) {
          setState(() {
            _pageIndex = selectedIndex;
          });
        },
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconlyBroken.wallet),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBroken.upload),
            label: "Upload",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBroken.edit),
            label: "Edit",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBroken.buy),
            label: "Orders",
          )
        ],
      ),
    );
  }
}
