import 'package:flutter/material.dart';
import 'NutritionDetailScreen.dart';

class NutritionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chế độ dinh dưỡng'),
      ),
      body: ListView.builder(
        itemCount: 10, // Giả sử có 10 chế độ dinh dưỡng
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Chế độ dinh dưỡng ${index + 1}'),
            subtitle: Text('Thông tin tóm tắt của chế độ ${index + 1}'),
            onTap: () {
              // Chuyển đến màn hình chi tiết chế độ dinh dưỡng
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NutritionDetailScreen(
                    title: 'Chế độ dinh dưỡng ${index + 1}',
                    description: 'Chi tiết về chế độ ${index + 1}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
