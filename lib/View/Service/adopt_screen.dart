import 'package:flutter/material.dart';
import 'pet_detail_screen.dart';
import 'add_pet_adopt_screen.dart'; // Nhập màn hình mới

class AdoptPetsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pets = [
    {
      'name': 'Milo',
      'age': 2,
      'gender': 'Đực',
      'breed': 'Golden Retriever',
      'description': 'Thân thiện, thích chơi với trẻ em và rất năng động.'
    },
    {
      'name': 'Luna',
      'age': 3,
      'gender': 'Cái',
      'breed': 'Mèo Ba Tư',
      'description': 'Yêu thích không gian yên tĩnh và rất thích được vuốt ve.'
    },
    {
      'name': 'Charlie',
      'age': 1,
      'gender': 'Đực',
      'breed': 'Corgi',
      'description': 'Hiếu động, vui vẻ và dễ huấn luyện.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhận Nuôi Thú Cưng'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPetScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return GestureDetector(
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet['name'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('${pet['age']} tuổi - ${pet['gender']}'),
                    Text('Giống: ${pet['breed']}'),
                    Text('Mô tả: ${pet['description']}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
