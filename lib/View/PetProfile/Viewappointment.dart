import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BookAppointmentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          AppointmentList(status: "PENDING"),
          AppointmentList(status: "CONFIRMED"),
          AppointmentList(status: "REJECTED"),
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
    try {
      // Lấy sessionId từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('JSESSIONID');

      if (sessionId == null) {
        throw Exception('Session ID không tồn tại. Vui lòng đăng nhập lại.');
      }

      // Xây dựng URI cho yêu cầu API
      final uri = Uri.parse('http://10.0.2.2:8888/api/admin/appointments/${widget.status.toLowerCase()}');

      // Tạo một HTTP request
      final request = http.Request('GET', uri);
      request.headers['Cookie'] = '$sessionId';  // Gửi sessionId trong header Cookie
      request.headers['Content-Type'] = 'application/json';  // Đặt Content-Type là application/json

      // Gửi yêu cầu và nhận phản hồi
      final response = await request.send();

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode == 200) {
        // Đọc body của response từ stream
        final responseBody = await response.stream.bytesToString();
        List<dynamic> data = json.decode(responseBody);

        return data.map((item) => Appointment.fromJson(item)).toList();
      } else {
        // Nếu mã trạng thái không phải 200, throw một exception với thông báo lỗi
        final errorResponse = await response.stream.bytesToString();
        throw Exception('Error: ${response.statusCode}, Response body: $errorResponse');
      }
    } catch (e) {
      // Xử lý bất kỳ lỗi nào trong quá trình thực hiện yêu cầu
      print('Lỗi trong quá trình gửi yêu cầu: $e');
      rethrow;  // Ném lại lỗi để có thể xử lý ở nơi gọi
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dịch Vụ: ${appointment.service}", style: TextStyle(fontSize: 12)),
                    Text("Thời Gian: ${appointment.time}", style: TextStyle(fontSize: 12)),
                    Text("Tên Thú Cưng: ${appointment.petName}", style: TextStyle(fontSize: 12)),
                    Text("Loại Thú Cưng: ${appointment.petType}", style: TextStyle(fontSize: 12)),
                    Text("Tên Người Dùng: ${appointment.userName}", style: TextStyle(fontSize: 12)),
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

  final String service;
  final String time;
  final String petName;  // Thêm trường petType
  final String userName;
  final String petType;// Thêm trường userName


  Appointment({

    required this.service,
    required this.time,
    required this.petName,
    required this.userName,
    required this.petType,
  });


  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(// Nếu customer là null, gán giá trị mặc định
      service: json['service'] ?? 'Chưa có thông tin dịch vụ',       // Nếu service là null, gán giá trị mặc định
      time: json['time'] ?? 'Chưa có thời gian',                      // Nếu time là null, gán giá trị mặc định
      petName: json['petName'] ?? 'Chưa có tên thú cưng',
      petType: json['petType'] ?? 'chua co Loai thu cung',
      userName: json['userName'] ?? 'Chưa có tên khách hàng',                 // Nếu time là null, gán giá trị mặc định
    );
  }
}
