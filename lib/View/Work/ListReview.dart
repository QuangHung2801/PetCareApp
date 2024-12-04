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
  List<dynamic> appointments = [];
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

      // Retrieve sessionId and userId
      sessionId = prefs.getString('JSESSIONID');
      userId = prefs.getString('userId');

      if (sessionId == null || userId == null) {
        throw Exception("Session ID or User ID is not found.");
      }

      // Fetch completed appointments
      final url = Uri.parse('http://10.0.2.2:8888/api/appointments/completed?userId=$userId');
      final response = await http.get(
        url,
        headers: {
          'Cookie': 'JSESSIONID=$sessionId',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          appointments = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Appointments'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? const Center(child: Text('No completed appointments found.'))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            child: ListTile(
              title: Text('Appointment ${appointment['id']}'),
              subtitle: Text('Date: ${appointment['date']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
