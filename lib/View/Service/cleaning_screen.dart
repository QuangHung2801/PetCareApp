import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CleaningServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vệ Sinh Thú Cưng'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Dịch Vụ Của Chúng Tôi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            ServiceCard(serviceName: 'Tắm Thú Cưng', imageUrl: 'assets/bath.jpg'),
            ServiceCard(serviceName: 'Cắt Móng', imageUrl: 'assets/nail_cutting.jpg'),
            ServiceCard(serviceName: 'Chải Lông', imageUrl: 'assets/grooming.jpg'),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String imageUrl;

  const ServiceCard({Key? key, required this.serviceName, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Image.asset(
            imageUrl, // Hình ảnh dịch vụ
            height: 150,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              serviceName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
