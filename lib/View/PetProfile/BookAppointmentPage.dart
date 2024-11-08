import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final TextEditingController reasonController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedPet;
  String? selectedService;
  List<Map<String, dynamic>> pets = [];
  List<Map<String, dynamic>> services = [];

  @override
  void initState() {
    super.initState();
    fetchPets();
    fetchServices(); // Fetch services
  }

  Future<void> fetchPets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('JSESSIONID');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Người dùng chưa đăng nhập!")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/pet/all'),
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> petList = jsonDecode(response.body);
      setState(() {
        pets = petList.map((pet) => {'id': pet['id'], 'name': pet['name']}).toList();
        if (pets.isNotEmpty) {
          selectedPet = pets[0]['name'];
        }
      });
    } else {
      print('Failed to load pet profiles: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi lấy danh sách thú cưng: ${response.statusCode}")),
      );
    }
  }

  Future<void> fetchServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');

    // Sử dụng phương thức GET để lấy danh sách dịch vụ
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8888/api/services/all'), // Cập nhật URL đúng
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> serviceList = jsonDecode(response.body);
      setState(() {
        services = serviceList.map((service) => {'id': service['id'], 'name': service['name']}).toList();
        if (services.isNotEmpty) {
          selectedService = services[0]['name'];
        }
      });
    } else {
      print('Failed to load services: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi lấy danh sách dịch vụ: ${response.statusCode}")),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> bookAppointment() async {
    if (selectedPet == null || selectedDate == null || selectedTime == null || reasonController.text.isEmpty || selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    int? selectedPetId;
    if (pets.isNotEmpty) {
      final pet = pets.firstWhere(
            (pet) => pet['name'] == selectedPet,
        orElse: () => {},
      );
      if (pet.isNotEmpty) {
        selectedPetId = pet['id'];
      }
    }

    if (selectedPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy thú cưng đã chọn")),
      );
      return;
    }

    int? selectedServiceId;
    if (services.isNotEmpty) {
      final service = services.firstWhere(
            (service) => service['name'] == selectedService,
        orElse: () => {},
      );
      if (service.isNotEmpty) {
        selectedServiceId = service['id'];
      }
    }
    print('Selected Service ID: $selectedServiceId');


    if (selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy dịch vụ đã chọn")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');

    final request = http.Request(
      'POST',
      Uri.parse('http://10.0.2.2:8888/api/appointments/book/$selectedPetId/$selectedServiceId'),
    );

    request.headers['Cookie'] = '$sessionId';
    request.headers['Content-Type'] = 'application/json';

    final payload = {
      'reason': reasonController.text,
      'date': "${selectedDate!.toIso8601String().split('T').first}", // yyyy-MM-dd format
      'time': "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}", // HH:mm format
    };


    request.body = jsonEncode(payload);

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt lịch thành công!')),
      );
      Navigator.pop(context);
    } else {
      response.stream.transform(utf8.decoder).listen((value) {
        print('Error response body: $value');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi lưu lịch hẹn: ${response.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt lịch khám cho thú cưng'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chọn thú cưng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            pets.isEmpty
                ? Center(child: CircularProgressIndicator())
                : DropdownButton<String>(
              value: selectedPet,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPet = newValue!;
                });
              },
              items: pets.map<DropdownMenuItem<String>>(
                    (pet) => DropdownMenuItem<String>(
                  value: pet['name'],
                  child: Text(pet['name']),
                ),
              ).toList(),
            ),
            SizedBox(height: 20),
            Text("Chọn dịch vụ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            services.isEmpty
                ? Center(child: CircularProgressIndicator())
                : DropdownButton<String>(
              value: selectedService,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedService = newValue!;
                });
              },
              items: services.map<DropdownMenuItem<String>>(
                    (service) => DropdownMenuItem<String>(
                  value: service['name'],
                  child: Text(service['name']),
                ),
              ).toList(),
            ),
            SizedBox(height: 20),
            Text("Lý do khám", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(hintText: "Nhập lý do khám"),
            ),
            SizedBox(height: 20),
            Text("Chọn ngày", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text(selectedDate == null ? 'Chưa chọn ngày' : "${selectedDate!.toLocal()}".split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            Text("Chọn giờ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text(selectedTime == null ? 'Chưa chọn giờ' : "${selectedTime!.format(context)}"),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: bookAppointment,
                child: Text('Đặt lịch'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
