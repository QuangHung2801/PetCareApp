import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Navbar.dart';
import '../../main.dart';
import '../Menu/Menu.dart';
import '../Partner/PartnerPage.dart';
import '../admin/AdminPage.dart';
import 'Forgotpassword.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/LoginScreen': (context) => LoginScreen(),
        '/MyHomePage': (context) => MyHomePage(title: '',),
        '/AdminPage': (context) => AdminPage(),
        '/PartnerHomePage': (context) => PartnerHomePage(),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/auth/login'), // Địa chỉ API
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phone': _phoneController.text,  // Sử dụng số điện thoại thay vì username
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String? jsessionId = response.headers['set-cookie']?.split(';').firstWhere((cookie) => cookie.startsWith('JSESSIONID='), orElse: () => '');
      if (jsessionId != null && jsessionId.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('JSESSIONID', jsessionId); // Lưu JSESSIONID
        print('JSESSIONID saved: $jsessionId');
      }
      List roles = responseBody['roles'];
      int userId = responseBody['userId'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId.toString());
      await prefs.setStringList('roles', roles.cast<String>());

      print('Login successful: ${response.body}');
      if (roles.contains('ADMIN')) {
        Navigator.pushReplacementNamed(context, '/AdminPage');
      } else if (roles.contains('PARTNER')) {
        Navigator.pushReplacementNamed(context, '/PartnerHomePage');
      } else {
        Navigator.pushReplacementNamed(context, '/MyHomePage');
      }

    } else {
      print('Login failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.jpg', height: 150),
                SizedBox(height: 20),
                // Phone Number Input
                TextField(
                  controller: _phoneController,  // Thêm controller cho số điện thoại
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Password Input
                TextField(
                  controller: _passwordController,  // Thêm controller cho mật khẩu
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
                SizedBox(height: 20),
                // Continue Button
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  }, // Gọi hàm _login khi nhấn nút
                  child: Text('Tiếp tục'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.orange,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text('Quên mật khẩu?'),
                ),
                SizedBox(height: 20),
                Text('Hoặc', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),
                SocialMediaButton(
                  label: 'Tiếp tục với Facebook',
                  icon: Icons.facebook,
                  color: Colors.blue,
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                SocialMediaButton(
                  label: 'Tiếp tục với Google',
                  icon: Icons.g_mobiledata,
                  color: Colors.red,
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                SocialMediaButton(
                  label: 'Tiếp tục với Apple',
                  icon: Icons.apple,
                  color: Colors.black,
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bạn chưa có tài khoản?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text('Đăng ký'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SocialMediaButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }
}
