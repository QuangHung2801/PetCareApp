import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Menu.dart';
import 'PetSettingsPage.dart';

class PetDetailPage extends StatelessWidget {
  final int petId;

  PetDetailPage({required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin thú cưng'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetSettingsPage(petId: petId),
                ),
              );
            },
          ),
        ],
      ),
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('http://10.0.2.2:8888/${pet.imageUrl}'),
                      radius: 70,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      pet.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text('Thông tin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Divider(),
                  SizedBox(height: 8),
                  _buildInfoBox('Giới tính: ${pet.gender}'),
                  _buildInfoBox('Cân nặng: ${pet.weight} kg'),
                  _buildInfoBox('Đã triệt sản: ${pet.neutered ? 'Có' : 'Không'}'),
                  _buildInfoBox('Ngày sinh: ${pet.birthday}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _deletePetProfile(context, pet.id),
                    child: Text('Xóa hồ sơ thú cưng', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoBox(String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          info,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<PetProfile> fetchPetDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8888/api/pet/detail/$petId'),
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return PetProfile.fromJson(json);
    } else {
      throw Exception('Failed to load pet detail');
    }
  }

  Future<void> _deletePetProfile(BuildContext context, int petId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');  // Use 'JSESSIONID' key here to match

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8888/api/pet/delete/$petId'),
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã xóa hồ sơ thú cưng thành công')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể xóa hồ sơ thú cưng')));
    }
  }
}

class PetProfile {
  final int id;
  final String name;
  final String imageUrl;
  final String gender;
  final double weight;
  final bool neutered;
  final String birthday;

  PetProfile({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.gender,
    required this.weight,
    required this.neutered,
    required this.birthday,
  });

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
      weight: json['weight'],
      neutered: json['neutered'],
      birthday: json['birthday'],
    );
  }
}
