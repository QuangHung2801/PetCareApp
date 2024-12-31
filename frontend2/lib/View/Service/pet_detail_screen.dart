import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pet;
  final String currentUserId;

  PetDetailScreen({required this.pet, required this.currentUserId});

  @override
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final String baseUrl = 'http://10.0.2.2:8888/api/adoption';
  bool isAdopted = false; // Trạng thái đăng ký nhận nuôi

  @override
  void initState() {
    super.initState();
    _checkAdoptionStatus();  // Kiểm tra lại trạng thái khi màn hình được tạo lại
  }

  // Lấy Session ID từ SharedPreferences
  Future<String?> getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('JSESSIONID');
  }

  // Lưu trạng thái nhận nuôi vào SharedPreferences
  Future<void> _saveAdoptionStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adopted_${widget.pet['id']}', status);
  }

  // Kiểm tra xem người dùng đã đăng ký nhận nuôi chưa
  Future<void> _checkAdoptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? adoptionStatus = prefs.getBool('adopted_${widget.pet['id']}');
    if (adoptionStatus != null) {
      setState(() {
        isAdopted = adoptionStatus;
      });
    }
  }

  // Đăng ký nhận nuôi
  Future<void> _registerAdoption(BuildContext context) async {
    String? sessionId = await getSessionId();
    if (sessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy Session ID! Vui lòng đăng nhập lại.')),
      );
      return;
    }

    final String petId = widget.pet['id']?.toString() ?? '';
    final url = Uri.parse('$baseUrl/adopt/$petId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': '$sessionId',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isAdopted = true; // Đã đăng ký nhận nuôi
      });
      _saveAdoptionStatus(true); // Lưu trạng thái đã nhận nuôi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bắt đầu quá trình nhận nuôi!')),
      );
      print('isAdopted: $isAdopted');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký nhận nuôi thất bại!')),
      );
    }
  }

  // Hoàn tất nhận nuôi
  Future<void> _completeAdoption(BuildContext context) async {
    String? sessionId = await getSessionId();
    if (sessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy Session ID! Vui lòng đăng nhập lại.')),
      );
      return;
    }

    final String petId = widget.pet['id']?.toString() ?? '';
    final response = await http.put(
      Uri.parse('$baseUrl/complete/$petId'),
      headers: {'Cookie': '$sessionId'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hoàn tất nhận nuôi thành công!')),
      );
      _saveAdoptionStatus(true); // Lưu trạng thái đã nhận nuôi
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể hoàn tất nhận nuôi!')),
      );
    }
  }

  // Hủy nhận nuôi
  Future<void> _cancelAdoption(BuildContext context) async {
    String? sessionId = await getSessionId();
    if (sessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy Session ID! Vui lòng đăng nhập lại.')),
      );
      return;
    }

    final String petId = widget.pet['id']?.toString() ?? '';
    final response = await http.put(
      Uri.parse('$baseUrl/cancel/$petId'),
      headers: {'Cookie': '$sessionId'},
    );

    if (response.statusCode == 200) {
      setState(() {
        isAdopted = false; // Hủy nhận nuôi
      });
      _saveAdoptionStatus(false); // Lưu trạng thái hủy nhận nuôi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hủy đăng ký nhận nuôi thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hủy đăng ký nhận nuôi thất bại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String posterUserId = widget.pet['posterUserId']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.pet['imageUrl'] ?? 'assets/no_image.png',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              widget.pet['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Loại: ${widget.pet['type']}'),
            Text('Cân nặng: ${widget.pet['weight']} kg'),
            Text('Mô tả: ${widget.pet['description']}'),
            Text('Số điện thoại liên hệ: ${widget.pet['contactPhone']}'),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.currentUserId != posterUserId)
                  ElevatedButton(
                    onPressed: isAdopted ? null : () => _registerAdoption(context),
                    child: Text(isAdopted ? 'Đã Đăng Ký' : 'Đăng Ký Nhận Nuôi'),
                  ),
                if (widget.currentUserId == posterUserId) ...[
                  ElevatedButton(
                    onPressed: () => _completeAdoption(context),
                    child: Text('Hoàn Tất'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _cancelAdoption(context),
                    child: Text('Hủy'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
