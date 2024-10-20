import 'dart:convert';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatelessWidget {
  // Initialize TextEditingController for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      print('Mật khẩu không khớp'); // Passwords do not match
      return;
    }

    // Check if name is not empty
    if (_nameController.text.isEmpty) {
      print('Tên không được để trống'); // Name cannot be empty
      return;
    }

    // Send POST request to register the user
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': _nameController.text, // Send name to backend
        'email': _emailController.text,
        'phone': _phoneController.text, // Change 'username' to 'phone'
        'password': _passwordController.text,
      }),
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Handle successful registration
      print('Registration successful: ${response.body}');
      Navigator.pop(context); // Navigate back to login screen
    } else {
      // Handle registration failure
      print('Registration failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Full Name Input
                TextField(
                  controller: _nameController, // Set controller
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Email Input
                TextField(
                  controller: _emailController, // Set controller
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Phone Number Input
                TextField(
                  controller: _phoneController, // Set controller
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixText: '+84 ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Password Input
                TextField(
                  controller: _passwordController, // Set controller
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
                SizedBox(height: 20),
                // Confirm Password Input
                TextField(
                  controller: _confirmPasswordController, // Set controller
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
                SizedBox(height: 20),
                // Register Button
                ElevatedButton(
                  onPressed: () {
                    _register(context); // Handle registration on button press
                  },
                  child: Text('Đăng ký'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
