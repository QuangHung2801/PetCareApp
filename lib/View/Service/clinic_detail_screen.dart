import 'package:flutter/material.dart';
import 'BookingServiceScreen.dart'; // Import BookingServiceScreen

class ClinicDetailScreen extends StatelessWidget {
  final String clinicName;

  ClinicDetailScreen({required this.clinicName});

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
            // Banner Image
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'assets/banner2.jpg',
                fit: BoxFit.cover,
              ),
            ),
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
                  SizedBox(height: 10),
                  Text(
                    'Dịch vụ:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Nội sôi', style: TextStyle(fontSize: 16)),
                      Text('• Thiến chó,mèo ', style: TextStyle(fontSize: 16)),
                      Text('• Tiem phòng ', style: TextStyle(fontSize: 16)),
                      Text('• Bẻ răng chó,mèo ', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingServiceScreen(),
                    ),
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