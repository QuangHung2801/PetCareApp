import 'package:flutter/material.dart';

import 'AddPetPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pety Profile',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AddPetProfilePage(),
    );
  }
}

class AddPetProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Profile thú cưng"),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // Đóng màn hình
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị logo ở giữa
            Image.asset(
              'assets/ssss.png', // Đường dẫn đến logo của bạn
              height: 200,
              width: 200,// Đặt kích thước cho logo
            ),
            SizedBox(height: 20),
            // Tiêu đề
            Text(
              'Thêm Profile thú cưng',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Mô tả
            Text(
              'Bắt đầu một cuộc hành trình mới của bạn cùng thú cưng trên Pety.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Nút "Thêm Profile thú cưng"
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến trang thêm thú cưng mới
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPetPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Thêm Profile thú cưng',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Link "Thêm thú cưng yêu thích"
            TextButton(
              onPressed: () {
                // Điều hướng đến trang thêm thú cưng yêu thích
              },
              child: Text(
                'Thêm thú cưng yêu thích',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
