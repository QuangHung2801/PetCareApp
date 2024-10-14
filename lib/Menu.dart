import 'package:flutter/material.dart';

import 'AddPetProfile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pety App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

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
          _buildAddProfileCard(context), // Truyền 'context' vào đây
          SizedBox(height: 20),
          _buildMenuOptions(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://example.com/user-profile-image.jpg'),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'user',
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

  // Hàm tạo card "Thêm Profile thú cưng"
  Widget _buildAddProfileCard(BuildContext context) {
    return InkWell(
      onTap: () {
        // Điều hướng đến trang thêm profile thú cưng
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
          title: "Đổi thưởng",
          subtitle: "Rất nhiều phần quà đang chờ bạn đổi thưởng!",
          trailing: "0 Xu",
        ),
        SizedBox(height: 16),
        _buildMenuOptionCard(
          icon: Icons.nfc,
          title: "Pety Smart NFC",
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

  Widget _buildMenuOptionCard({required IconData icon, required String title, String? subtitle, String? trailing}) {
    return Container(
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
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
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
    );
  }
}
