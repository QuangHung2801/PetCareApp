import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminAppointmentsPage extends StatefulWidget {
  @override
  _AdminAppointmentsPageState createState() => _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  List<dynamic> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final url = Uri.parse('http://10.0.2.2:8888/api/admin/appointments/pending');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        appointments = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi lấy danh sách lịch hẹn: ${response.statusCode}")),
      );
    }
  }

  Future<void> confirmAppointment(int appointmentId) async {
    final url = Uri.parse('http://10.0.2.2:8888/api/admin/appointments/confirm/$appointmentId');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lịch hẹn đã được xác nhận.")),
      );
      fetchAppointments(); // Refresh danh sách sau khi xác nhận
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi xác nhận lịch hẹn: ${response.statusCode}")),
      );
    }
  }

  Future<void> rejectAppointment(int appointmentId) async {
    final url = Uri.parse('http://10.0.2.2:8888/api/admin/appointments/reject/$appointmentId');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lịch hẹn đã bị từ chối.")),
      );
      fetchAppointments(); // Refresh danh sách sau khi từ chối
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi từ chối lịch hẹn: ${response.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Lịch hẹn'),
        backgroundColor: Colors.orange,
      ),
      body: appointments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID Lịch hẹn: ${appointment['id']}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Tên thú cưng: ${appointment['petName']}"),
                  Text("Ngày: ${appointment['date']}"),
                  Text("Giờ: ${appointment['time']}"),
                  Text("Lý do: ${appointment['reason']}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => confirmAppointment(appointment['id']),
                        child: Text('Xác nhận'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => rejectAppointment(appointment['id']),
                        child: Text('Từ chối'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

