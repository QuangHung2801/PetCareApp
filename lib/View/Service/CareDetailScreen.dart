import 'package:flutter/material.dart';
import 'BookingServiceScreen.dart'; // Import BookingServiceScreen

class CareDetailScreen extends StatelessWidget {
  final String clinicName;

  CareDetailScreen({required this.clinicName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clinicName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hình ảnh
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/banner1.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Thông tin chi tiết đại lý
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Địa chỉ: 123 Đường ABC, Quận 1, TP. HCM'),
                  SizedBox(height: 5),
                  Text('Số điện thoại: 0123456789'),
                  SizedBox(height: 5),
                  Text('Email: example@clinic.com'),
                  SizedBox(height: 5),
                  Text('Thời gian mở cửa: 07:30 - 17:00'),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      Icon(Icons.star_border, color: Colors.grey, size: 20),
                      SizedBox(width: 8),
                      Text('(13 đánh giá)', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Dịch vụ: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Tắm chó, mèo', style: TextStyle(fontSize: 16)),
                      Text('• Tỉa lông', style: TextStyle(fontSize: 16)),
                      Text('• Khách sạn thú cưng', style: TextStyle(fontSize: 16)),
                      Text('• Cắt móng', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            // Nút đặt dịch vụ
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Chuyển sang trang BookingServiceScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingServiceScreen()),
                  );
                },
                child: Text('Đặt dịch vụ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
