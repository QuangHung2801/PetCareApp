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

  List<Map<String, dynamic>> pets = [];

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  // Fetch pets from the API
  Future<void> fetchPets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print('User ID: $userId');// Retrieve the stored user ID
    String? sessionId = prefs.getString('JSESSIONID');
    print('Session ID: $sessionId');

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

  // Select date for appointment
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

  // Select time for appointment
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

  // Book appointment with selected details
  Future<void> bookAppointment() async {
    if (selectedPet == null || selectedDate == null || selectedTime == null || reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    // Lấy id của thú cưng đã chọn
    int? selectedPetId;
    if (pets.isNotEmpty) {
      final pet = pets.firstWhere(
            (pet) => pet['name'] == selectedPet,
        orElse: () => {}, // Return an empty map if no pet is found
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

    print("ssss = " );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');
    print('Session ID: $sessionId');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/appointments/book/$selectedPetId'),
      headers: {
        'Cookie': 'JSESSIONID=$sessionId',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'reason': reasonController.text,
        'date': "${selectedDate!.toIso8601String().split('T').first}",
        'time': "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt lịch thành công!')),
      );
    } else {
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
            ElevatedButton(
              onPressed: bookAppointment,
              child: Text('Đặt lịch khám'),
            ),
          ],
        ),
      ),
    );
  }
}
