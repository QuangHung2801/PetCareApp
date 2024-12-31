import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'AppointmentsPage.dart';

import 'NoticationsPage.dart';
import 'PartnerProfilePage.dart';
import 'Partner_Navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bảng Điều Khiển Đối Tác Chăm Sóc Thú Cưng',
      home: PartnerHomePage(),
    );
  }
}

class PartnerHomePage extends StatefulWidget {
  @override
  _PartnerHomePageState createState() => _PartnerHomePageState();
}

class _PartnerHomePageState extends State<PartnerHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PartnerDashboardPage(),
    NotificationsPage(),
    AppointmentsPage(),
    PartnerProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: PartnerNavbar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class PartnerDashboardPage extends StatefulWidget {
  @override
  _PartnerDashboardPageState createState() => _PartnerDashboardPageState();
}

class _PartnerDashboardPageState extends State<PartnerDashboardPage> {
  bool isServiceOpen = true; // Biến theo dõi trạng thái dịch vụ

  @override
  void initState() {
    super.initState();
    getServiceStatus(); // Gọi hàm lấy trạng thái dịch vụ khi trang được tải
  }

  Future<void> getServiceStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Lấy partner ID từ SharedPreferences

    if (userId != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8888/api/partner/serviceStatus/$userId'),
      );

      if (response.statusCode == 200) {
        try {
          print('Response body: ${response.body}'); // Log toàn bộ nội dung response

          var data = jsonDecode(response.body);
          print('Parsed isOpen: ${data['isOpen']}'); // Log giá trị isOpen đã phân tích

          if (data['isOpen'] != null && data['isOpen'] is bool) {
            setState(() {
              isServiceOpen = data['isOpen']; // Cập nhật trạng thái dịch vụ
            });
          } else {
            print('Invalid isOpen value: ${data['isOpen']}');
          }
        } catch (e) {
          print('Error parsing response: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã có lỗi khi phân tích dữ liệu.')),
          );
        }
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải trạng thái dịch vụ.')),
        );
      }
    }
  }

  Future<void> closeService() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8888/api/partner/closeServiceEarly/$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          isServiceOpen = false; // Đóng dịch vụ
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dịch vụ đã được đóng cửa.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể đóng cửa dịch vụ.')),
        );
      }
    }
  }

  Future<void> reopenService() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8888/api/partner/reopenService/$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          isServiceOpen = true; // Mở lại dịch vụ
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dịch vụ đã được mở lại.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể mở lại dịch vụ.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bảng Điều Khiển Đối Tác Chăm Sóc Thú Cưng"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // Implement logout logic
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildPartnerInfo(),
          SizedBox(height: 20),
          _buildServiceManagementSection(),
          SizedBox(height: 20),
          _buildAppointmentSection(),
          SizedBox(height: 20),
          _buildPetList(),
        ],
      ),
    );
  }

  Widget _buildPartnerInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('Thông Tin Đối Tác'),
    );
  }

  Widget _buildServiceManagementSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quản Lý Dịch Vụ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: isServiceOpen ? closeService : null, // Disable button if service is open
            child: Text('Đóng Cửa Dịch Vụ Sớm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red color for close button
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: !isServiceOpen ? reopenService : null, // Disable button if service is closed
            child: Text('Mở Lại Dịch Vụ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Green color for reopen button
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('Lịch Hẹn'),
    );
  }

  Widget _buildPetList() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('Danh Sách Thú Cưng'),
    );
  }
}
