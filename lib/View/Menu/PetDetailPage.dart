import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Menu.dart';

class PetDetailPage extends StatelessWidget {
  final int petId;

  PetDetailPage({required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông tin thú cưng')),
      body: FutureBuilder<PetProfile>(
        future: fetchPetDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không tìm thấy thông tin thú cưng.'));
          } else {
            final pet = snapshot.data!;
            return Column(
              children: [
                Image.network('http://10.0.2.2:8888/${pet.imageUrl}'),
                SizedBox(height: 16),
                Text(pet.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                // Hiển thị thêm thông tin về thú cưng
                Text('Thông tin chi tiết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                // Text('Giới tính: ${pet.gender}'),
                // Text('Cân nặng: ${pet.weight} kg'),
                // Text('Đã triệt sản: ${pet.neutered ? 'Có' : 'Không'}'),
                // Text('Ngày sinh: ${pet.birthday}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _deletePetProfile(context, pet.id),
                  child: Text('Xóa hồ sơ thú cưng', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<PetProfile> fetchPetDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('sessionId');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8888/api/pet/detail/$petId'),
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PetProfile.fromJson(json);
    } else {
      throw Exception('Failed to load pet detail');
    }
  }

  Future<void> _deletePetProfile(BuildContext context, int petId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('sessionId');

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8888/api/pet/delete/$petId'),
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context); // Quay lại trang trước đó
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã xóa hồ sơ thú cưng thành công')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể xóa hồ sơ thú cưng')));
    }
  }
}
