import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPetPage extends StatefulWidget {
  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  String? gender = "Con cái";
  String? neutered = "Chưa";
  String? petType = "Chó"; // Lựa chọn mặc định cho loại động vật
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? imageUrl = "";

  Future<void> addPetProfile() async {
    final String apiUrl = "http://10.0.2.2:8888/api/pet/add";

    // Dữ liệu từ form
    Map<String, dynamic> petData = {
      "name": nameController.text,
      "description": descriptionController.text,
      "birthday": birthdayController.text,
      "gender": gender,
      "neutered": neutered == "Rồi",
      "weight": double.parse(weightController.text),
      "imageUrl": imageUrl,
      "type": petType // Cập nhật loại động vật
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(petData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thêm thú cưng thành công")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thất bại, thử lại sau")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Thêm thú cưng mới',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.camera_alt, size: 40, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Chọn hình đại diện cho thú cưng',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên thú cưng',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả về thú cưng',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: birthdayController,
              decoration: InputDecoration(
                labelText: 'Sinh nhật',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                // Chọn ngày
              },
            ),
            SizedBox(height: 16),
            Text('Category'),
            DropdownButtonFormField<String>(
              value: petType,
              onChanged: (String? newValue) {
                setState(() {
                  petType = newValue;
                });
              },
              items: <String>['Chó', 'Mèo', 'Chim', 'Thỏ', 'Khác']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Chọn giới tính'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Con cái'),
                    value: 'Con cái',
                    groupValue: gender,
                    onChanged: (String? value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Con đực'),
                    value: 'Con đực',
                    groupValue: gender,
                    onChanged: (String? value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Đã triệt sản hay chưa'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Chưa'),
                    value: 'Chưa',
                    groupValue: neutered,
                    onChanged: (String? value) {
                      setState(() {
                        neutered = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Rồi'),
                    value: 'Rồi',
                    groupValue: neutered,
                    onChanged: (String? value) {
                      setState(() {
                        neutered = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cân nặng',
                suffixText: 'Kg',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addPetProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Thêm', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
