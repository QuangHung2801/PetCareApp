import 'package:flutter/material.dart';
import 'View/PetProfile/PetProfile.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _selectedIndex = 0; // Chỉ số hiện tại của BottomNavigationBar

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Hàm xử lý sự kiện khi chọn mục từ BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Đẩy các widget lên phía trên
          children: <Widget>[
            const SizedBox(height: 20), // Khoảng cách giữa AppBar và nút
            SizedBox(
              width: 130, // Chiều rộng hình vuông
              height: 140, // Chiều cao hình vuông
              child: ElevatedButton(
                onPressed: () {
                  // Dẫn đến màn hình PetHealthScreen khi bấm nút
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetHealthScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bo góc nhẹ
                  ),
                ),
                child: const Text('Sổ sức khỏe'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Cộng đồng'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Khám phá'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Thú cưng'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Dịch vụ'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,  // Màu khi được chọn
        unselectedItemColor: Colors.black, // Màu đen cho icon chưa chọn
        selectedLabelStyle: const TextStyle(color: Colors.black),  // Màu chữ khi được chọn
        unselectedLabelStyle: const TextStyle(color: Colors.black), // Màu chữ chưa chọn
        onTap: _onItemTapped,
      ),
    );
  }
}
