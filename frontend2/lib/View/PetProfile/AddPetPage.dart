import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../Menu/Menu.dart';

class AddPetPage extends StatefulWidget {
  @override
  _AddPetPageState createState() => _AddPetPageState();

}

class _AddPetPageState extends State<AddPetPage> {
  String? gender = "Con cái";
  String? neutered = "Chưa";
  String? petType = "Chó";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  File? _image;





  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> addPetProfile() async {
    final String apiUrl = "http://10.0.2.2:8888/api/pet/add";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');

      print('Session ID: $sessionId');


    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        birthdayController.text.isEmpty ||
        weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    double? weight = double.tryParse(weightController.text);
    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập cân nặng hợp lệ")),
      );
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['name'] = nameController.text
      ..fields['description'] = descriptionController.text
      ..fields['birthday'] = birthdayController.text
      ..fields['gender'] = gender!
      ..fields['neutered'] = neutered == "Rồi" ? "true" : "false"
      ..fields['weight'] = weight.toString()
      ..fields['type'] = petType!;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Ensure this matches your backend field name
        _image!.path,
      ));
    }


    // Gửi session ID trong header Cookie
    request.headers['Cookie'] = '$sessionId';
    print('Request Headers: ${request.headers}');

    // Attach the image if it exists

    try {
      var response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      print('Response status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thêm thú cưng thành công")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thất bại, thử lại sau")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi")),
      );
    }
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        birthdayController.text = "${pickedDate.toIso8601String().substring(0, 10)}"; // Format to yyyy-MM-dd
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm thú cưng mới'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[700])
                    : null,
              ),
            ),
            SizedBox(height: 8),
            Text('Chọn hình đại diện cho thú cưng', style: TextStyle(color: Colors.grey)),
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
              onTap: () => _selectBirthday(context),
            ),
            SizedBox(height: 16),
            Text('Loại động vật'),
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
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                labelText: 'Cân nặng (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addPetProfile,
              child: Text('Thêm thú cưng'),
            ),
          ],
        ),
      ),
    );
  }
}
