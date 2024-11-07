import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPetProfilePage extends StatefulWidget {
  final int petId;

  EditPetProfilePage({required this.petId});

  @override
  _EditPetProfilePageState createState() => _EditPetProfilePageState();
}

class _EditPetProfilePageState extends State<EditPetProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String gender = 'Con cái';
  bool isNeutered = false;
  String? imageUrl;
  File? _selectedImage;
  String? petType = "Chó";


  final ImagePicker _picker = ImagePicker();

  // Load pet profile from API
  Future<void> loadPetProfile() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8888/api/pet/detail/${widget.petId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nameController.text = data['name'];
        descriptionController.text = data['description'];
        weightController.text = data['weight'].toString();;
        selectedDate = DateFormat('MM/dd/yyyy').parse(data['birthday']);
        gender = data['gender'];
        isNeutered = data['neutered'];
        imageUrl = data['imageUrl'];
        petType = data['type'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Không thể tải hồ sơ thú cưng")));
    }
  }

  @override
  void initState() {
    super.initState();
    loadPetProfile();
  }

  // Select an image from the gallery
  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Edit pet profile with image upload
  Future<void> editPetProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');
print('id:$sessionId');
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://10.0.2.2:8888/api/pet/edit/${widget.petId}'),

    );



    request.fields['name'] = nameController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['birthday'] = DateFormat('yyyy-MM-dd').format(selectedDate);
    request.fields['gender'] = gender;
    request.fields['weight'] =weightController.text;
    request.fields['neutered'] = isNeutered.toString();
    request.fields['type'] = petType!;

    print('Form Fields:');
    print('Name: ${nameController.text}');
    print('Description: ${descriptionController.text}');
    print('Birthday: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
    print('Gender: $gender');
    print('Weight: ${weightController.text}');
    print('Neutered: $isNeutered');
    print('Type: $petType');

    // If a new image is selected, add it to the request
    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image', // name of the field expected by the backend
        _selectedImage!.path,
      ));
    } else if (imageUrl != null) {
      request.fields['imageUrl'] = imageUrl!;
    }
    request.headers['Cookie'] = '$sessionId';
    print('Request Headers: ${request.headers}');


    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hồ sơ thú cưng đã được cập nhật")));
      Navigator.pop(context);
    } else {
      final responseBody = await response.stream.bytesToString();
      print("Response body: $responseBody");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thất bại")));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa hồ sơ thú cưng"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chọn hình đại diện cho thú cưng"),
            SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: selectImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : imageUrl != null
                      ? NetworkImage('http://10.0.2.2:8888/$imageUrl')
                      : null,
                  child: _selectedImage == null && imageUrl == null
                      ? Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Tên thú cưng",
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Mô tả về thú cưng",
              ),
            ),
            SizedBox(height: 16),
            Text("Loại thú cưng"),
            DropdownButton<String>(
              value: (petType != null && ['Chó', 'Mèo', 'Chim', 'Khác'].contains(petType)) ? petType : 'Chó',
              onChanged: (String? newValue) {
                setState(() {
                  petType = newValue!;
                });
              },
              items: <String>['Chó', 'Mèo', 'Chim', 'Khác']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text("Sinh nhật"),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("Chọn giới tính"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Con cái"),
                    value: 'Con cái',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Con đực"),
                    value: 'Con đực',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Đã triệt sản hay chưa"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Chưa"),
                    value: false,
                    groupValue: isNeutered,
                    onChanged: (value) {
                      setState(() {
                        isNeutered = value as bool;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Rồi"),
                    value: true,
                    groupValue: isNeutered,
                    onChanged: (value) {
                      setState(() {
                        isNeutered = value as bool;
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
                labelText: "cân nặng thú cưng",
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: editPetProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text("Lưu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
