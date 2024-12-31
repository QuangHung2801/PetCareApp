import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> pendingAppointments = [];
  List<dynamic> confirmedAppointments = [];
  List<dynamic> completedAppointments = [];
  List<dynamic> cancelledAppointments = [];
  String? jsessionId;
  String? userId;
  String? partnerId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Added a new tab for completed appointments
    _loadJSessionId();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to load JSESSIONID from SharedPreferences
  Future<void> _loadJSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jsessionId = prefs.getString('JSESSIONID');
    userId = prefs.getString('userId');
    if (jsessionId != null) {
      _fetchAppointments();
    }
    if (jsessionId != null && userId != null) {
      await _fetchPartnerInfo(); // Fetch partner information
    }
  }

  Future<void> _fetchPartnerInfo() async {
    final url = Uri.parse('http://10.0.2.2:8888/api/partner/appointments/info/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$jsessionId',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          partnerId = data['id'].toString();
        });
        _fetchAppointments(); // Fetch appointments after obtaining partnerId
      } else {
        print('Failed to load partner info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching partner info: $e');
    }
  }

  Future<void> _updateAppointmentStatus(int appointmentId, String status) async {
    final url = Uri.parse('http://10.0.2.2:8888/api/partner/appointments/$appointmentId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$jsessionId',
        },
        body: json.encode({'status': status}),
      );
      if (response.statusCode == 200) {
        print("Appointment status updated successfully.");
        await _fetchAppointments(); // Reload appointments after updating
      } else {
        print("Failed to update status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  // Function to fetch all appointments by their status
  Future<void> _fetchAppointments() async {
    await _fetchAppointmentsByStatus('pending', pendingAppointments);
    await _fetchAppointmentsByStatus('confirmed', confirmedAppointments);
    await _fetchAppointmentsByStatus('completed', completedAppointments);
    await _fetchAppointmentsByStatus('rejected', cancelledAppointments);
    setState(() {});
  }

  Future<void> _fetchAppointmentsByStatus(String status, List<dynamic> list) async {
    if (partnerId == null) return; // Return if partnerId is not set yet
    final url = Uri.parse('http://10.0.2.2:8888/api/partner/appointments/$status?partnerId=$partnerId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$jsessionId',
        },
      );
      if (response.statusCode == 200) {
        list.clear();
        list.addAll(json.decode(response.body));
      } else {
        print('Failed to load $status appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching $status appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý Lịch hẹn"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Chờ xác nhận"),
            Tab(text: "Đã xác nhận"),
            Tab(text: "Đã hoàn thành"), // Added completed tab
            Tab(text: "Đã huỷ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(pendingAppointments, "Chờ xác nhận"),
          _buildAppointmentList(confirmedAppointments, "Đã xác nhận"),
          _buildAppointmentList(completedAppointments, "Đã hoàn thành"),
          _buildAppointmentList(cancelledAppointments, "Đã huỷ"),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(List<dynamic> appointments, String status) {
    if (appointments.isEmpty) {
      return Center(child: Text("Không có lịch hẹn $status"));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        var appointment = appointments[index];
        return Card(
          child: ListTile(
            title: Text("Lịch hẹn ID: ${appointment['id']}"),
            subtitle: Text("Trạng thái: $status\nChi tiết: ${appointment['details'] ?? 'Không có'}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (status == "Chờ xác nhận") // Options for "Pending" appointments
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => _updateAppointmentStatus(appointment['id'], 'CONFIRMED'),
                  ),
                if (status == "Chờ xác nhận" || status == "Đã xác nhận")
                  IconButton(
                    icon: Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => _updateAppointmentStatus(appointment['id'], 'REJECTED'),
                  ),
                if (status == "Đã xác nhận") // Option for "Confirmed" appointments
                  IconButton(
                    icon: Icon(Icons.done, color: Colors.blue),
                    onPressed: () => _updateAppointmentStatus(appointment['id'], 'COMPLETED'),
                  ),
              ],
            ),
            onTap: () {
              // Handle tap to show appointment details if needed
            },
          ),
        );
      },
    );
  }
}
