import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppointmentPage(),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> with SingleTickerProviderStateMixin {
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
          AppointmentList(status: "REJECTED"),
        ],
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
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('JSESSIONID');

      if (sessionId == null) {
        throw Exception('Session ID không tồn tại. Vui lòng đăng nhập lại.');
      }

      // URL chính xác cho lệnh PUT
      final uri = Uri.parse('http://10.0.2.2:8888/api/admin/appointments/$appointmentId');

      // Gửi request PUT với body JSON chứa status
      final request = http.Request('PUT', uri);
      request.headers.addAll({
        'Cookie': '$sessionId',
        'Content-Type': 'application/json',
      });
      request.body = jsonEncode({'status': status});

// Gửi request và nhận response
      final response = await http.Client().send(request);
      final responseBody = await http.Response.fromStream(response);

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode == 200) {
        print('Cập nhật trạng thái thành công');
        setState(() {
          // Gọi fetchAppointments lại để cập nhật danh sách lịch hẹn
          appointments = fetchAppointments();
        });
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi trong quá trình gửi yêu cầu: $e');
      rethrow;
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
                    Text('Dịch vụ: ${appointment.service}', style: TextStyle(fontSize: 12)),
                    Text('Thời gian: ${appointment.time}', style: TextStyle(fontSize: 12)),
                    Text('Tên thú cưng: ${appointment.petName}', style: TextStyle(fontSize: 12)),
                    Text('Loại thú cưng: ${appointment.petType}', style: TextStyle(fontSize: 12)),
                    Text('Tên khách hàng: ${appointment.userName}', style: TextStyle(fontSize: 12)),
                    if (widget.status == "PENDING") ...[
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              // Update status to "CONFIRMED"
                              updateAppointmentStatus(appointment.id, "CONFIRMED");
                            },
                            child: Text('Xác nhận'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Update status to "CANCELLED"
                              updateAppointmentStatus(appointment.id, "REJECTED");
                            },
                            child: Text('Hủy'),
                          ),
                        ],
                      ),
                    ],
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
  final String id;

  final String service;
  final String time;
  final String petName;  // Thêm trường petType
  final String userName;
  final String petType;

  Appointment({required this.id, required this.service, required this.time,required this.petName,
    required this.userName,
    required this.petType,});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'].toString(),  // Ensure there's an ID for each appointment

      service: json['service'] ?? 'Chưa có thông tin dịch vụ',
      time: json['time'] ?? 'Chưa có thời gian', // Nếu time là null, gán giá trị mặc định
      petName: json['petName'] ?? 'Chưa có tên thú cưng',
      petType: json['petType'] ?? 'chua co Loai thu cung',
      userName: json['userName'] ?? 'Chưa có tên khách hàng',
    );
  }
}
