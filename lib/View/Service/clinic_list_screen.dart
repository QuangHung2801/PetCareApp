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
          final decodedResponse = utf8.decode(response.bodyBytes);
          clinicList = json.decode(decodedResponse);
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
                bool isOpen = _checkIfClinicIsOpen(
                  clinic['openingTime'],
                  clinic['closingTime'],
                  clinic['isOpen'],
                );

                return ClinicItem(
                  clinicName: clinic['businessName'] ?? 'N/A',
                  openingTime: clinic['openingTime'] ?? 'N/A',
                  closingTime: clinic['closingTime'] ?? 'N/A',
                  averageRating: clinic['averageRating'] != null
                      ? double.tryParse(clinic['averageRating'].toString())
                      : 0.0,
                  imageUrl: clinic['imageUrl'] ?? '',
                  isOpen: isOpen,
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  // Hàm kiểm tra nếu phòng khám đang mở dựa trên giờ
  // Hàm kiểm tra nếu phòng khám đang mở dựa trên giờ
  bool _checkIfClinicIsOpen(String openingTime, String closingTime, bool isOpen) {
    final now = DateTime.now();

    // Nếu phòng khám đã quyết định đóng cửa sớm
    if (!isOpen) {
      return false;  // Trả về false nếu đóng cửa sớm
    }

    // Kiểm tra giờ mở cửa và đóng cửa bình thường
    final opening = DateTime(now.year, now.month, now.day, int.parse(openingTime.split(":")[0]), int.parse(openingTime.split(":")[1]));
    final closing = DateTime(now.year, now.month, now.day, int.parse(closingTime.split(":")[0]), int.parse(closingTime.split(":")[1]));

    return now.isAfter(opening) && now.isBefore(closing);
  }
}

class ClinicItem extends StatelessWidget {
  final String clinicName;
  final String openingTime;
  final String closingTime;
  final double? averageRating;
  final String imageUrl;
  final bool isOpen;

  ClinicItem({
    required this.clinicName,
    required this.openingTime,
    required this.closingTime,
    this.averageRating,
    required this.imageUrl,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isOpen) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClinicDetailScreen(clinicName: clinicName),
            ),
          );
        }
      },
      child: Card(
        color: Colors.white,
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
              if (averageRating != null && averageRating! > 0)
                Row(
                  children: List.generate(
                    5,
                        (i) => Icon(
                      Icons.star,
                      size: 14,
                      color: i < (averageRating ?? 0).toInt()
                          ? Colors.yellow
                          : Colors.grey,
                    ),
                  ),
                ),
              // Nếu phòng khám không mở, hiển thị thông báo
              if (!isOpen)
                Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      'Đóng cửa',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: isOpen ? Colors.black54 : Colors.grey, // Chỉ cho phép nhấn nếu mở cửa
          ),
        ),
      ),
    );
  }
}
