import 'package:flutter/material.dart';
import 'clinic_detail_screen.dart';

class ClinicListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phòng khám thú y', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Nhập tên/địa chỉ của đại lý',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Số lượng phòng khám
              itemBuilder: (context, index) {
                return ClinicItem(clinicName: 'Anh Già thú y');
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Nền trắng cho toàn bộ màn hình
    );
  }
}

class ClinicItem extends StatelessWidget {
  final String clinicName;

  ClinicItem({required this.clinicName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClinicDetailScreen(clinicName: clinicName),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/banner2.jpg', // Đường dẫn tới ảnh trong thư mục assets
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            clinicName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đóng cửa 07:30 - 17:00',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('(13)', style: TextStyle(fontSize: 12)),
                ],
              ),
              Text(
                'Dịch vụ đặt chỗ trước',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black54),
        ),
      ),
    );
  }
}
