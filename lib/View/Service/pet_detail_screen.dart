import 'package:flutter/material.dart';

class PetDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  PetDetailScreen({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(pet['image'], width: double.infinity, height: 250, fit: BoxFit.cover),
            SizedBox(height: 16.0),
            Text(
              pet['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Giống: ${pet['breed']}', style: TextStyle(fontSize: 18)),
            Text('Tuổi: ${pet['age']}'),
            Text('Giới tính: ${pet['gender']}'),
            SizedBox(height: 16.0),
            Text(
              'Tính cách: Rất thân thiện và hòa đồng với trẻ em.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showAdoptionForm(context);
                },
                child: Text('Đăng Ký Nhận Nuôi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị Form Đăng Ký Nhận Nuôi
  void _showAdoptionForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Đăng Ký Nhận Nuôi ${pet['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Họ và Tên'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Số Điện Thoại'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đăng ký nhận nuôi thành công!')),
                );
              },
              child: Text('Xác Nhận'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }
}
