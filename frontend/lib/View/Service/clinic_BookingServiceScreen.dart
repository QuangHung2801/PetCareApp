import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BookingServiceScreen extends StatefulWidget {
  final String clinicName;
  BookingServiceScreen({required this.clinicName});

  @override
  _BookingServiceScreenState createState() => _BookingServiceScreenState();
}

class _BookingServiceScreenState extends State<BookingServiceScreen> {
  List<String> availableServices = [];
  List<Map<String, dynamic>> userPets = [];
  String? selectedService;
  String? selectedPetId;
  String? partnerId;
  DateTime? appointmentDate;
  TimeOfDay? appointmentTime;

  final Map<String, String> serviceTranslation = {
    "PET_BOARDING": "Trông giữ thú cưng",
    "PET_SPA": "Spa cho thú cưng",
    "PET_GROOMING": "Tắm và cắt tỉa lông",
    "PET_WALKING": "Dắt thú cưng đi dạo",
    "VETERINARY_EXAMINATION": "Khám chữa bệnh",
    "VACCINATION": "Tiêm phòng",
    "SURGERY": "Phẫu thuật",
    "REGULAR_CHECKUP": "Khám định kỳ",
  };

  @override
  void initState() {
    super.initState();
    fetchAvailableServices();
    fetchUserPets();
    getClinicId(widget.clinicName);
  }

  // Lấy danh sách dịch vụ từ clinic details
  Future<void> fetchAvailableServices() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/clinics/${widget.clinicName}'));
      if (response.statusCode == 200) {
        var clinic = json.decode(response.body);
        var services = clinic['services'] ?? [];
        setState(() {
          availableServices = (services as List<dynamic>)
              .map((service) => serviceTranslation[service] ?? service.toString())
              .toList();
        });
      } else {
        print('Failed to fetch services. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching services: $error');
    }
  }

  Future<void> getClinicId(String clinicName) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/clinics/$clinicName'));
      if (response.statusCode == 200) {
        var clinic = json.decode(response.body);
        setState(() {
          partnerId = clinic['id'].toString();
        });
      } else {
        print('Failed to fetch clinic. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching clinic: $error');
    }
  }

  // Lấy danh sách thú cưng của người dùng
  Future<void> fetchUserPets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/pet/all'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"userId": userId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        userPets = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  // Mở hộp thoại chọn ngày
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        appointmentDate = picked;
      });
    }
  }

  // Mở hộp thoại chọn giờ
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        appointmentTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt dịch vụ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chọn dịch vụ:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedService,
              hint: Text('Chọn dịch vụ'),
              items: availableServices.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedService = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Chọn thú cưng:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedPetId,
              hint: Text('Chọn thú cưng'),
              items: userPets.map((pet) {
                return DropdownMenuItem<String>(
                  value: pet['id'].toString(),
                  child: Text(pet['name']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPetId = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => selectDate(context),
              child: Text(appointmentDate == null
                  ? 'Chọn ngày'
                  : 'Ngày đã chọn: ${DateFormat('yyyy-MM-dd').format(appointmentDate!)}'),
            ),
            ElevatedButton(
              onPressed: () => selectTime(context),
              child: Text(appointmentTime == null
                  ? 'Chọn giờ'
                  : 'Giờ đã chọn: ${appointmentTime!.format(context)}'),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: placeBooking,
                child: Text('Xác nhận đặt dịch vụ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> placeBooking() async {
    if (selectedService == null || selectedPetId == null || appointmentDate == null || appointmentTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng chọn tất cả các thông tin!')));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionid = prefs.getString('JSESSIONID');

    String formattedDate = DateFormat('yyyy-MM-dd').format(appointmentDate!);
    String formattedTime = DateFormat.Hm().format(
      DateFormat.jm().parse(appointmentTime!.format(context)),
    );

    // Kiểm tra dịch vụ đã chọn và chuyển đổi theo enum
    String? serviceEnum = serviceTranslation.entries
        .firstWhere((entry) => entry.value == selectedService, orElse: () => MapEntry("", ""))
        .key;

    if (serviceEnum.isEmpty) {
      print("Dịch vụ không hợp lệ");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dịch vụ không hợp lệ!')));
      return;
    }

    print('Dịch vụ đã chọn: $serviceEnum');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/appointments/book/$selectedPetId/$partnerId'),
      headers: {'Content-Type': 'application/json', 'Cookie': '$sessionid'},
      body: json.encode({
        "userId": userId,
        "petId": selectedPetId,
        "date": formattedDate,
        "time": formattedTime,
        "serviceType": serviceEnum,  // Gửi đúng enum của dịch vụ
      }),
    );

    if (response.statusCode == 201) {
      print("Đặt dịch vụ thành công!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đặt dịch vụ thành công!')));
      Navigator.pop(context);
    } else {
      String errorMessage = json.decode(response.body)['message'] ?? 'Đặt dịch vụ thất bại!';
      print("Lỗi đặt dịch vụ: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $errorMessage')));
    }
  }
}
