import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BookingServiceScreen.dart';
import 'care_BookingServiceScreen.dart';
import 'clinic_BookingServiceScreen.dart'; // Adjust import paths as necessary

class CareDetailScreen extends StatefulWidget {
  final String careName;

  CareDetailScreen({required this.careName});

  @override
  _CareDetailScreenState createState() => _CareDetailScreenState();
}

class _CareDetailScreenState extends State<CareDetailScreen> {
  late Future<Map<String, dynamic>> careDetails;

  // Translation map for services
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
    careDetails = fetchCareDetails(widget.careName);
  }

  Future<Map<String, dynamic>> fetchCareDetails(String careName) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/clinics/$careName'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load care details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.careName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: careDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No care details found'));
          }

          var care = snapshot.data!;
          var services = care['services'] ?? [];

          // Translate and filter available services
          var availableServices = services.map((service) {
            return serviceTranslation[service] ?? service;
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Image
                Container(
                  height: 250,
                  width: double.infinity,
                  child: care['imageUrl'] != null && care['imageUrl'] != ""
                      ? Image.network(
                    'http://10.0.2.2:8888/update/img/partners/${care['imageUrl']}',
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
                        care['businessName'] ?? '',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Địa chỉ: ${care['address'] ?? 'Không có thông tin'}'),
                      SizedBox(height: 5),
                      Text('Số điện thoại: ${care['phone'] ?? 'Không có thông tin'}'),
                      SizedBox(height: 5),
                      Text('Email: ${care['email'] ?? 'Không có thông tin'}'),
                      SizedBox(height: 5),
                      Text('Thời gian mở cửa: ${care['workingHours'] ?? "Không có thông tin"}'),
                      SizedBox(height: 10),
                      Text(
                        'Dịch vụ: ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Display available services
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
                          builder: (context) => CareBookingServiceScreen(careName: widget.careName),
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
