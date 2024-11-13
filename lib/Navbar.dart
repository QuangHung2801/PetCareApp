import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Bảng tin'),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Tin tức '),
        BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Thú cưng'),
        BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined), label: 'Dịch vụ'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: const TextStyle(color: Colors.black),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      onTap: onItemTapped,
    );
  }
}
