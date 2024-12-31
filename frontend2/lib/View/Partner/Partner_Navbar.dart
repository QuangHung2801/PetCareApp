import 'package:flutter/material.dart';

// Định nghĩa một callback để chuyển tab từ PartnerNavbar ra ngoài
typedef OnTabSelected = void Function(int index);

class PartnerNavbar extends StatelessWidget {
  final int selectedIndex;
  final OnTabSelected onTabSelected;

  PartnerNavbar({required this.selectedIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Thông báo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Lịch hẹn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Cá nhân',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue,
      backgroundColor: Colors.yellow,
      onTap: onTabSelected,
    );
  }
}
