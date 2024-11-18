import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'clinic_BookingServiceScreen.dart';

class ClinicDetailScreen extends StatefulWidget {
  final String clinicName;

  ClinicDetailScreen({required this.clinicName});

  @override
  _ClinicDetailScreenState createState() => _ClinicDetailScreenState();
}

class _ClinicDetailScreenState extends State<ClinicDetailScreen> {
  late Future<Map<String, dynamic>> clinicDetails;

  @override
  void initState() {
    super.initState();
    clinicDetails = fetchClinicDetails(widget.clinicName);
  }

  // Từ điển dịch vụ
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

  Future<Map<String, dynamic>> fetchClinicDetails(String clinicName) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/clinics/$clinicName'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load clinic details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clinicName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: clinicDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No clinic details found'));
          }

          var clinic = snapshot.data!;
          var services = clinic['services'] ?? [];

          // Filter the services based on the available services from the clinic
          var availableServices = services.map((service) {
            String serviceName = serviceTranslation[service] ?? service;
            return serviceName;
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Image
                Container(
                  height: 250,
                  width: double.infinity,
                  child: clinic['imageUrl'] != null && clinic['imageUrl'] != ""
                      ? Image.network(
                    'http://10.0.2.2:8888/update/img/partners/${clinic['imageUrl']}',
                    fit: BoxFit.cover,
                  )
                      : Image.asset('assets/images/default-image.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic['businessName'] ?? '',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Địa chỉ: ${clinic['address'] ?? 'Không có thông tin'}'),
                      SizedBox(height: 5),
                      Text('Số điện thoại: ${clinic['phone'] ?? 'Không có thông tin'}'),
                      SizedBox(height: 5),
                      Text('Email: ${clinic['email'] ?? 'Không có thông tin'}'),
                      SizedBox(height: 5),
                      Text('Thời gian mở cửa: ${clinic['workingHours'] ?? "Không có thông tin"}'),
                      SizedBox(height: 10),
                      Text(
                        'Dịch vụ: ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Display only the services available for the clinic
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.from(availableServices.map((service) {
                          return Text('• $service', style: TextStyle(fontSize: 16));
                        })),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingServiceScreen(clinicName: widget.clinicName),
                        ),
                      );
                    },
                    child: Text('Đặt dịch vụ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
