// lib/View/Partner/PartnerPage.dart
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

class PartnerDashboardPage extends StatelessWidget {
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
      child: Text('Quản Lý Dịch Vụ'),
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
