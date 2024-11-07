import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BookAppointmentPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewAppointment(),
    );
  }
}

class ViewAppointment extends StatefulWidget {
  @override
  _ViewAppointmentState createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với số lượng tab là 3
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Hủy TabController khi widget bị huỷ
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt Lịch"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,  // Cho phép cuộn nếu số lượng tab quá nhiều
          labelStyle: TextStyle(fontSize: 15), // Kích thước font chữ nhỏ hơn trong tab
          tabs: [
            Tab(text: "Lịch Chờ duyệt"),
            Tab(text: "Lịch Đã Xác nhận"),
            Tab(text: "Lịch Đã Hủy"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AppointmentList(status: "PENDING"),   // Sử dụng trạng thái cho từng tab
          AppointmentList(status: "CONFIRMED"),
          AppointmentList(status: "CANCELLED"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookAppointmentPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class AppointmentList extends StatefulWidget {
  final String status;
  AppointmentList({required this.status});

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  late Future<List<Appointment>> appointments;

  @override
  void initState() {
    super.initState();
    appointments = fetchAppointments();
  }

  // Fetch appointments from backend
  Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8888/api/admin/appointments/${widget.status.toLowerCase()}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Appointment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: appointments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có lịch hẹn'));
        }

        final appointments = snapshot.data!;
        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Card(
              child: ListTile(
                title: Text("Khách Hàng: ${appointment.customer}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.service, style: TextStyle(fontSize: 12)),
                    Text(appointment.time, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Appointment {
  final String customer;
  final String service;
  final String time;

  Appointment({required this.customer, required this.service, required this.time});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      customer: json['customer'] ?? 'Chưa có thông tin khách hàng',  // Nếu customer là null, gán giá trị mặc định
      service: json['service'] ?? 'Chưa có thông tin dịch vụ',       // Nếu service là null, gán giá trị mặc định
      time: json['time'] ?? 'Chưa có thời gian',                      // Nếu time là null, gán giá trị mặc định
    );
  }
}
