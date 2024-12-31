import 'package:flutter/material.dart';

class NutritionDetailScreen extends StatelessWidget {
  final String title;
  final String description;

  NutritionDetailScreen({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết chế độ dinh dưỡng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            // Thêm thông tin chi tiết như danh sách thực phẩm, chế độ ăn hàng ngày, etc.
            Text(
              'Danh sách thực phẩm:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Ví dụ danh sách thực phẩm
            ...List.generate(5, (index) {
              return ListTile(
                title: Text('Thực phẩm ${index + 1}'),
                subtitle: Text('Số lượng: ${index + 1} viên'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
