import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Review.dart';

class CompletedAppointmentsScreen extends StatefulWidget {
  const CompletedAppointmentsScreen({Key? key}) : super(key: key);

  @override
  _CompletedAppointmentsScreenState createState() => _CompletedAppointmentsScreenState();
}

class _CompletedAppointmentsScreenState extends State<CompletedAppointmentsScreen> {
  List<dynamic> completedAppointments = [];
  List<dynamic> pendingAppointments = [];
  List<dynamic> confirmedAppointments = [];
  List<dynamic> rejectedAppointments = [];

  bool isLoading = true;
  String? sessionId;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadSessionAndFetchAppointments();
  }

  Future<void> _loadSessionAndFetchAppointments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      sessionId = prefs.getString('JSESSIONID');
      userId = prefs.getString('userId');

      if (sessionId == null || userId == null) {
        throw Exception("Session ID or User ID is not found.");
      }

      await _fetchAppointments('completed', completedAppointments);
      await _fetchAppointments('pending', pendingAppointments);
      await _fetchAppointments('confirmed', confirmedAppointments);
      await _fetchAppointments('rejected', rejectedAppointments);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchAppointments(String status, List<dynamic> targetList) async {
    final url = Uri.parse('http://10.0.2.2:8888/api/appointments/$status?userId=$userId');
    final response = await http.get(
      url,
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      targetList.addAll(data);
    } else {
      print('Failed to load $status appointments: ${response.statusCode}');
    }
  }

  Widget _buildAppointmentList(List<dynamic> appointments, String status) {
    // if (appointments.isEmpty) {
    //   return Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Text('$title: Không có cuộc hẹn nào.', style: const TextStyle(fontSize: 16)),
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
        ),
        ...appointments.map((appointment) {
          return Card(
            child: ListTile(
              title: Text('Dịch vụ ${appointment['id']}'),
              subtitle: Text('Ngày: ${appointment['date']} - Trạng thái: $status'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (status == 'Đã hoàn thành')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewScreen(appointmentId: appointment['id']),
                          ),
                        );
                      },
                      child: const Text('Đánh giá'),
                    ),
                  Icon(
                    status == 'Đã hoàn thành'
                        ? Icons.check_circle
                        : status == 'Chờ duyệt'
                        ? Icons.access_time
                        : status == 'Đã duyệt'
                        ? Icons.thumb_up
                        : Icons.cancel,
                    color: status == 'Đã hoàn thành'
                        ? Colors.green
                        : status == 'Chờ duyệt'
                        ? Colors.orange
                        : status == 'Đã duyệt'
                        ? Colors.blue
                        : Colors.red,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhật ký cuộc hẹn'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildAppointmentList(pendingAppointments, 'Chờ duyệt'),
              _buildAppointmentList(confirmedAppointments, 'Đã duyệt'),
              _buildAppointmentList(completedAppointments, 'Đã hoàn thành'),
              _buildAppointmentList(rejectedAppointments, 'Người cung cấp đã hủy'),
            ],
          ),
        ),
      ),
    );
  }
}
