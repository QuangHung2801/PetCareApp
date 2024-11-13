import 'package:flutter/material.dart';
import 'View/ Social/Following.dart';
import 'Navbar.dart';
import 'View/ Social/discover.dart';
import 'View/Menu/Menu.dart';
import 'View/PetProfile/PetCareManagement.dart';
import 'View/Service/PetServicesPage.dart';
import 'View/PetProfile/PetProfile.dart';
import 'View/Service/ServiceScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'home',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final List<Widget> _pages = [
    HomePageSociety(),
    ExplorePage(),
    ServiceScreen(),
    PetServicesPage(),
    HomePage(),
  ];

  // Hàm xử lý sự kiện khi chọn mục từ BottomNavigationBar
  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar( // Gọi widget ở đây
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}