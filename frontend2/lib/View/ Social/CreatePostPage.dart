import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Để xử lý File
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  List<File> _selectedImages = []; // Danh sách hình ảnh được chọn
  String? _selectedPetId;
  List<Map<String, dynamic>> _pets = [];

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? sessionId = prefs.getString('JSESSIONID');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8888/api/pet/user/$userId'),
        headers: {'Cookie': 'JSESSIONID=$sessionId', 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _pets = data.map((item) {
            return {
              'id': item['id'].toString(),
              'name': item['name'],
              'image': item['imageUrl'] ?? '',
            };
          }).toList();
        });
      } else {
        print("Lỗi HTTP: ${response.statusCode}, Nội dung: ${response.body}");
        throw Exception('Lỗi tải thú cưng');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách thú cưng: $e')),
      );
    }
  }

  // Hàm chọn nhiều hình ảnh
  void _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // Chọn nhiều ảnh

    if (pickedFiles != null) {
      setState(() {
        // Thêm các hình ảnh đã chọn vào danh sách hiện tại thay vì thay thế nó
        _selectedImages.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
    }
  }




  Future<void> _submitPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (_contentController.text.isEmpty || _selectedPetId == null || _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập nội dung, chọn thú cưng và ít nhất 1 ảnh.')) ,
      );
      return;
    }

    var uri = Uri.parse('http://10.0.2.2:8888/api/posts/$userId');
    var request = http.MultipartRequest('POST', uri)
      ..fields['content'] = _contentController.text
      ..fields['petId'] = _selectedPetId ?? '';

    // Đọc hình ảnh từ File và thêm vào request
    for (var image in _selectedImages) {
      var multipartFile = await http.MultipartFile.fromPath('images', image.path);
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng bài thất bại.')));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng bài viết'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            _selectedImages.isEmpty
                ? TextButton.icon(
              onPressed: _pickImages,
              icon: Icon(Icons.image),
              label: Text('Chọn hình ảnh'),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true, // Cho phép GridView có thể cuộn khi cần thiết
                  physics: NeverScrollableScrollPhysics(), // Tắt cuộn của GridView nếu bạn không muốn cuộn
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Hiển thị 3 hình ảnh trong một hàng
                    crossAxisSpacing: 8, // Khoảng cách giữa các hình ảnh theo chiều ngang
                    mainAxisSpacing: 8, // Khoảng cách giữa các hình ảnh theo chiều dọc
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      _selectedImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
                TextButton.icon(
                  onPressed: _pickImages,
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Chọn thêm hình ảnh'),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPetId,
              hint: Text("Chọn thú cưng"),
              items: _pets.map((pet) {
                return DropdownMenuItem<String>(
                  value: pet['id'],
                  child: Row(
                    children: [
                      pet['image'] != ''
                          ? Image.network(
                        pet['image'],
                        width: 30,
                        height: 30,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.pets),
                      )
                          : Icon(Icons.pets),
                      SizedBox(width: 8),
                      Text(pet['name']),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPetId = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Đăng bài'),
            ),
          ],
        ),
      ),
    );
  }
}

