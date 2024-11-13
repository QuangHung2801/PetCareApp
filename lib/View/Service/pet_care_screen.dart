import 'package:flutter/material.dart';
import 'BookingServiceScreen.dart'; // Import BookingServiceScreen
import 'CareDetailScreen.dart'; // Import CareDetailScreen

class PetCareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chăm sóc thú cưng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Nhập tên dịch vụ chăm sóc',
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
              itemCount: 5, // Số lượng dịch vụ chăm sóc thú cưng
              itemBuilder: (context, index) {
                return PetCareItem(
                  clinicName: 'Spa & Grooming', // Pass the clinic name here
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareDetailScreen(clinicName: 'Spa & Grooming'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class PetCareItem extends StatelessWidget {
  final String clinicName;
  final VoidCallback onTap;

  PetCareItem({required this.clinicName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/banner1.jpg', // Đường dẫn tới ảnh trong thư mục assets
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
                'Dịch vụ làm đẹp thú cưng',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Icon(Icons.star, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('(10)', style: TextStyle(fontSize: 12)),
                ],
              ),
              Text(
                'Đặt chỗ trước',
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
