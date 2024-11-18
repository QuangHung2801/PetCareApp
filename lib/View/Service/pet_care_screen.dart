import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'CareDetailScreen.dart'; // Import CareDetailScreen

class PetCareScreen extends StatefulWidget {
  @override
  _PetCareScreenState createState() => _PetCareScreenState();
}

class _PetCareScreenState extends State<PetCareScreen> {
  List<dynamic> petCareList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchPetCareList(); // Gọi API lấy danh sách dịch vụ chăm sóc thú cưng
  }

  // Hàm gọi API lấy danh sách dịch vụ chăm sóc thú cưng
  Future<void> fetchPetCareList() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8888/api/clinics?category=PET_CARE&search=$searchQuery'));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          petCareList = json.decode(response.body);
          print('Total Pet Care Services: ${petCareList.length}');
        });
      } else {
        print('Failed to load pet care services');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chăm sóc thú cưng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
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
                fetchPetCareList(); // Tìm kiếm theo tên dịch vụ chăm sóc
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên dịch vụ chăm sóc',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: petCareList.isEmpty
                ? Center(child: Text('Không tìm thấy dịch vụ chăm sóc thú cưng nào'))
                : ListView.builder(
              itemCount: petCareList.length,
              itemBuilder: (context, index) {
                final service = petCareList[index];
                return PetCareItem(
                  careName: service['businessName'] ?? 'N/A',
                  rating: service['rating'] != null
                      ? double.tryParse(service['rating'].toString())
                      : 0.0,
                  imageUrl: service['imageUrl'] ?? '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CareDetailScreen(careName: service['businessName'] ?? 'N/A'),
                      ),
                    );
                  },
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

// Widget PetCareItem
class PetCareItem extends StatelessWidget {
  final String careName;
  final double? rating;
  final String imageUrl;
  final VoidCallback onTap;

  PetCareItem({
    required this.careName,
    this.rating,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  Image.asset('assets/banner1.jpg', width: 80, height: 80),
            ),
          ),
          title: Text(
            careName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  5,
                      (i) => Icon(
                    Icons.star,
                    size: 14,
                    color: i < (rating ?? 0).toInt() ? Colors.yellow : Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Dịch vụ chăm sóc thú cưng',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black54),
        ),
      ),
    );
  }
}
