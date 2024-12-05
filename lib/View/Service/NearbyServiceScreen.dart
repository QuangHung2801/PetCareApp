import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'clinic_detail_screen.dart';

class NearbyServiceScreen extends StatefulWidget {
  @override
  _NearbyServiceScreenState createState() => _NearbyServiceScreenState();
}

class _NearbyServiceScreenState extends State<NearbyServiceScreen> {
  bool showVeterinaryCare = true;
  bool showPetCare = true;
  List<dynamic> clinicList = [];
  String searchQuery = '';
  double? latitude;
  double? longitude;

  // final Location location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog('Dịch vụ vị trí chưa được bật.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog('Quyền truy cập vị trí bị từ chối.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog('Quyền truy cập vị trí bị từ chối vĩnh viễn.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      print('latitude: $latitude, longitude: $longitude');
      fetchClinicList(); // Tải lại danh sách phòng khám
    } catch (e) {
      print('Error fetching location: $e');
      _showErrorDialog('Lỗi khi lấy vị trí hiện tại.');
    }
  }

  Future<void> fetchClinicList() async {
    if (latitude == null || longitude == null) {
      print('Chưa có vị trí hiện tại.');
      return;
    }

    // Tạo danh sách category dựa trên lựa chọn
    List<String> categories = [];
    if (showVeterinaryCare) categories.add('VETERINARY_CARE');
    if (showPetCare) categories.add('PET_CARE');

    // Chuyển đổi danh sách category thành chuỗi
    String category = categories.join(',');

    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8888/api/partner/nearby?latitude=$latitude&longitude=$longitude&category=${Uri.encodeQueryComponent(category)}&search=$searchQuery&maxDistance=8'));

      if (response.statusCode == 200) {
        setState(() {
          final decodedResponse = utf8.decode(response.bodyBytes);
          clinicList = json.decode(decodedResponse);
        });
      } else {
        print('Failed to load clinics: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching clinic list: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dịch vụ gần nhà'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_hospital),
                      Text('Phòng khám thú y'),
                      Checkbox(
                        value: showVeterinaryCare,
                        onChanged: (bool? value) {
                          setState(() {
                            showVeterinaryCare = value!;
                          });
                          fetchClinicList();
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.pets),
                      Text('Chăm sóc thú cưng'),
                      Checkbox(
                        value: showPetCare,
                        onChanged: (bool? value) {
                          setState(() {
                            showPetCare = value!;
                          });
                          fetchClinicList();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                fetchClinicList();
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên/địa chỉ',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: clinicList.isEmpty
                ? Center(child: Text('Không tìm thấy dịch vụ'))
                : ListView.builder(
              itemCount: clinicList.length,
              itemBuilder: (context, index) {
                final clinic = clinicList[index];
                return ClinicItem(
                  clinicName: clinic['businessName'] ?? 'N/A',
                  openingTime: clinic['openingTime'] ?? 'N/A',
                  closingTime: clinic['closingTime'] ?? 'N/A',
                  averageRating: clinic['averageRating'] != null
                      ? double.tryParse(clinic['averageRating'].toString())
                      : 0.0,
                  imageUrl: clinic['imageUrl'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClinicItem extends StatelessWidget {
  final String clinicName;
  final String openingTime;
  final String closingTime;
  final double? averageRating;
  final String imageUrl;

  ClinicItem({
    required this.clinicName,
    required this.openingTime,
    required this.closingTime,
    this.averageRating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClinicDetailScreen(clinicName: clinicName),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl.isNotEmpty
                  ? 'http://10.0.2.2:8888/$imageUrl'
                  : 'http://10.0.2.2:8888/update/img/partners/default_image.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            clinicName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Giờ mở cửa: $openingTime - $closingTime',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: averageRating ?? 0.0,
                    minRating: 0,
                    itemSize: 20,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                    ignoreGestures: true,
                  ),
                  Text(averageRating != null
                      ? averageRating!.toStringAsFixed(1)
                      : 'N/A'),
                ],
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
