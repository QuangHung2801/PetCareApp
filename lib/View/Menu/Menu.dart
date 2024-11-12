import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import '../PetProfile/AddPetProfile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'PartnerRegistrationPage.dart';
import 'PetDetailPage.dart';

void main() {
  runApp(MyApp());
}

class PetProfile {
  final int id;
  final String name;
  final String gender;
  final double weight;
  final bool neutered;
  final String birthday;
  final String imageUrl;

  PetProfile({required this.id,
    required this.name,
    required this.gender,
    required this.weight,
    required this.neutered,
    required this.birthday,
    required this.imageUrl,});

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      weight: json['weight']?.toDouble() ?? 0.0, // Converts to double, default 0.0 if null
      neutered: json['neutered'] ?? false, // Defaults to false if null
      birthday: json['birthday'],
      imageUrl: json['imageUrl'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet App',
      home: HomePage(),

    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PetProfile> petProfiles = [];
  bool isLoading = true;
  // String? username;
  @override
  void initState() {
    super.initState();
    fetchPetProfiles(); // Gọi phương thức để tải danh sách thú cưng
  }

  Future<void> fetchPetProfiles() async {
    setState(() {
      isLoading = true;
    });


    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    // username = prefs.getString('name');
    // print('name: $username');
    print('User ID: $userId');// Retrieve the stored user ID
    String? sessionId = prefs.getString('JSESSIONID');
    print('Session ID: $sessionId');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8888/api/pet/all'),
        headers: {
          'Cookie': 'JSESSIONID=$sessionId',
          'Content-Type': 'application/json',
        },
        body:jsonEncode({'userId': userId}), // Use the retrieved user ID
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Data received: $data');
        setState(() {
          petProfiles = data.map((json) => PetProfile.fromJson(json)).toList();
        });
      } else {
        print('Failed to load pet profiles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading pet profiles: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('sessionId');

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8888/api/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId' // Attach the session ID cookie
        },
      );

      if (response.statusCode == 200) {
        // Logout successful, remove session data from local storage
        await prefs.remove('sessionId');
        await prefs.remove('userId');

        // Navigate to the login screen
        Navigator.pushReplacementNamed(context, '/LoginScreen');
        print('Đăng xuất thành công');
      } else {
        print('Đăng xuất thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildUserProfile(),
          SizedBox(height: 20),
          _buildPetList(),
          SizedBox(height: 20),
          _buildAddProfileCard(context),
          SizedBox(height: 20),
          _buildMenuOptions(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             "User",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Vào trang cá nhân'),
          ],
        ),
        Spacer(),
        Icon(Icons.qr_code_scanner),
      ],
    );
  }

  Widget _buildAddProfileCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPetProfilePage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(8),

        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thêm Profile thú cưng",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Nếu bạn có nuôi thú cưng thì tại sao không tạo Profile cho người bạn nhỏ của mình!",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline, size: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        _buildMenuOptionCard(
          icon: Icons.redeem,
          title: "Đăng ký tài khoản đối tác",
        onTap: () async {
          // Điều hướng đến trang đăng ký đối tác
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartnerRegistrationForm(),
            ),
          );
          if (result != null && result == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đăng ký đối tác thành công!')),
            );
        }

          }
        ),
        SizedBox(height: 16),
        _buildMenuOptionCard(
          icon: Icons.nfc,
          title: "Pet Smart NFC",
        ),
        SizedBox(height: 16),
        _buildMenuOptionCard(
          icon: Icons.map,
          title: "Địa chỉ",
        ),
        SizedBox(height: 16),
        _buildMenuOptionCard(
          icon: Icons.pets,
          title: "Dịch vụ thú cưng",
        ),
      ],
    );
  }

  Widget _buildMenuOptionCard({required IconData icon, required String title, String? subtitle, String? trailing ,VoidCallback? onTap}) {

    return InkWell( // Sử dụng InkWell hoặc GestureDetector để bắt sự kiện nhấn
      onTap: onTap, // Gọi hàm onTap khi người dùng nhấn vào
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.orange),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ]
                ],
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (petProfiles.isEmpty) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Gia đình của bạn có ${petProfiles.length} thành viên',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 130, // Điều chỉnh chiều cao nếu cần
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: petProfiles.length,
              itemBuilder: (context, index) {
                final pet = petProfiles[index];
                return InkWell(
                  onTap: () {
                    // Chuyển đến trang chi tiết khi nhấn vào một thú cưng
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailPage(petId: pet.id),
                      ),
                    );
                  },
                  child: Container(
                    width: 120, // Thẻ hình vuông với width = height
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('http://10.0.2.2:8888/${pet.imageUrl}'),
                          radius: 35, // Điều chỉnh bán kính cho ảnh tròn
                        ),
                        SizedBox(height: 5),
                        Text(
                          pet.name,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đăng xuất"),
          content: Text("Bạn có muốn đăng xuất không?"),
          actions: [
            TextButton(
              child: Text("Không"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text("Có"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                _logout(); // Gọi hàm đăng xuất
              },
            ),
          ],
        );
      },
    );
  }


}
