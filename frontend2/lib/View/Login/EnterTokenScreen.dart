import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ResetPasswordScreen.dart';

class EnterTokenScreen extends StatefulWidget {
  @override
  _EnterTokenScreenState createState() => _EnterTokenScreenState();
}

class _EnterTokenScreenState extends State<EnterTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> verifyToken() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/password-reset/verify-token'),
      headers: {
        'Content-Type': 'application/json', // Đặt Content-Type là application/json
      },
      body: jsonEncode({'token': _tokenController.text}),
    );

    if (response.statusCode == 200) {
      // Nếu token hợp lệ, chuyển sang trang đặt lại mật khẩu
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(token: _tokenController.text)),
      );
    } else {
      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Token không hợp lệ hoặc đã hết hạn.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập Token'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhập mã token',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Vui lòng nhập mã token đã được gửi đến email của bạn.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(
                  labelText: 'Token',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã token.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      verifyToken();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Xác nhận Token',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
