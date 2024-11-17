import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'clinic_detail_screen.dart';

class ClinicListScreen extends StatefulWidget {
  @override
  _ClinicListScreenState createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends State<ClinicListScreen> {
  List<dynamic> clinicList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchClinicList(); // Lấy danh sách phòng khám khi khởi động màn hình
  }

  // Hàm gọi API lấy danh sách phòng khám theo thể loại dịch vụ
  Future<void> fetchClinicList() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8888/api/clinics?category=VETERINARY_CARE&search=$searchQuery'));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          clinicList = json.decode(response.body);
          print('Total Clinics: ${clinicList.length}');

        });
        clinicList.forEach((clinic) {
          print('Image URL: ${clinic['imageUrl']}');
        });
      } else {
        print('Failed to load clinics');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phòng khám thú y', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                fetchClinicList(); // Tìm kiếm theo tên hoặc địa chỉ
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên/địa chỉ của phòng khám',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: clinicList.isEmpty
                ? Center(child: Text('Không tìm thấy phòng khám nào'))
                : ListView.builder(
              itemCount: clinicList.length,
              itemBuilder: (context, index) {
                final clinic = clinicList[index];
                return ClinicItem(
                  clinicName: clinic['businessName'] ?? 'N/A',
                  openingTime: clinic['openingTime'] ?? 'N/A',
                  closingTime: clinic['closingTime'] ?? 'N/A',
                  rating: clinic['rating'] != null
                      ? double.tryParse(clinic['rating'].toString())
                      : 0.0,
                  imageUrl: clinic['imageUrl'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ClinicItem extends StatelessWidget {
  final String clinicName;
  final String openingTime;
  final String closingTime;
  final double? rating;
  final String imageUrl;

  ClinicItem({
    required this.clinicName,
    required this.openingTime,
    required this.closingTime,
    this.rating,
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
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl.isNotEmpty
                  ? 'http://10.0.2.2:8888/update/img/partners/$imageUrl' // Thêm URL gốc nếu cần thiết
                  : 'http://10.0.2.2:8888/update/img/partners/default_image.jpg', // Hình ảnh mặc định nếu imageUrl trống
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/banner2.jpg', width: 80, height: 80),
            ),
          ),
          title: Text(
            clinicName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Giờ mở cửa: $openingTime - $closingTime',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              Row(
                children: List.generate(
                  5,
                      (i) => Icon(
                    Icons.star,
                    size: 14,
                    color: i < (rating ?? 0).toInt()
                        ? Colors.yellow
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black54),
        ),
      ),
    );
  }
}
