import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PartnerProfilePage extends StatefulWidget {
  @override
  _PartnerProfilePageState createState() => _PartnerProfilePageState();
}

class _PartnerProfilePageState extends State<PartnerProfilePage> {
  bool isEditingPersonalInfo = false;
  bool isEditingServices = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<String> allServices = [];
  List<String> selectedServices = [];
  String imageUrl = "";
  String businessName = "";
  String businessCode = "";
  String businessLicense = "";
  String serviceCategory = ""; // Store the category type (e.g., PET_CARE, VETERINARY_CARE)

  // Cập nhật dịch vụ với enum ServiceType mới
  Map<String, String> serviceTranslation = {
    "Trông giữ thú cưng": "PET_BOARDING",
    "Spa cho thú cưng": "PET_SPA",
    "Tắm và cắt tỉa lông": "PET_GROOMING",
    "Dắt thú cưng đi dạo": "PET_WALKING",
    "Khám chữa bệnh": "VETERINARY_EXAMINATION",
    "Tiêm phòng": "VACCINATION",
    "Phẫu thuật": "SURGERY",
    "Khám định kỳ": "REGULAR_CHECKUP",
  };

  @override
  void initState() {
    super.initState();
    fetchPartnerInfo();
  }

  Future<void> fetchPartnerInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("UserId: $userId");
    final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/partner/show/$userId'));

    if (response.statusCode == 200) {
      print(response.body);  // Print raw response to check data
      try {
        final data = jsonDecode(response.body);
        setState(() {
          businessName = data['businessName'] ?? "Thông tin không có sẵn";
          businessCode = data['businessCode'] ?? "Thông tin không có sẵn";
          businessLicense = data['businessLicense'] ?? "Thông tin không có sẵn";
          addressController.text = data['address'] ?? "Địa chỉ không có sẵn";
          phoneController.text = data['phone'] ?? "Số điện thoại không có sẵn";
          emailController.text = data['email'] ?? "Email không có sẵn";
          imageUrl = data['imageUrl'] ?? "Hình ảnh không có sẵn";

          serviceCategory = data['serviceCategory'] ?? "Không xác định";

          // Cập nhật selectedServices từ API, chuyển mã dịch vụ thành tên dịch vụ
          selectedServices = data['services'] != null
              ? List<String>.from(data['services'].map((serviceCode) {
            return serviceTranslation.keys.firstWhere(
                  (key) => serviceTranslation[key] == serviceCode,
              orElse: () => serviceCode, // Trả về mã dịch vụ nếu không tìm thấy dịch vụ tương ứng
            );
          }))
              : [];

          // Cập nhật danh sách dịch vụ theo loại dịch vụ
          if (serviceCategory == "PET_CARE") {
            allServices = [
              "Trông giữ thú cưng", "Spa cho thú cưng", "Tắm và cắt tỉa lông", "Dắt thú cưng đi dạo"
            ];
          } else if (serviceCategory == "VETERINARY_CARE") {
            allServices = [
              "Khám chữa bệnh", "Tiêm phòng", "Phẫu thuật", "Khám định kỳ"
            ];
          }
        });
      } catch (e) {
        print("Lỗi khi giải mã JSON: $e");
        print("Raw response: ${response.body}");
      }
    } else {
      print("Lấy thông tin đối tác không thành công");
    }
  }


  Future<void> updatePartnerInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    // Đảm bảo các dịch vụ được ánh xạ đúng với giá trị enum
    List<String> serviceCodes = selectedServices.map((serviceName) {
      return serviceTranslation[serviceName] ?? serviceName; // Nếu không có ánh xạ thì dùng tên gốc
    }).toList();

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8888/api/partner/update-partner-info/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'businessName': businessName,
        'businessCode': businessCode,
        'businessLicense': businessLicense,
        'address': addressController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'services': serviceCodes.isEmpty ? [] : serviceCodes,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isEditingPersonalInfo = false;
        isEditingServices = false;
      });
    } else {
      print("Cập nhật thông tin đối tác thất bại");
      print("Mã trạng thái phản hồi: ${response.statusCode}");
      print("Nội dung phản hồi: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Partner Profile")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildPersonalInfoSection(),
          SizedBox(height: 20),
          _buildServicesSection(),
          SizedBox(height: 20),
          _buildOptionsSection(context),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Business Name: $businessName"),
          Text("Business Code: $businessCode"),
          Text("Business License: $businessLicense"),
          SizedBox(height: 8),
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: "Address"),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "Phone"),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: updatePartnerInfo,
            child: Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Registered Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Column(
            children: allServices.map((service) {
              return CheckboxListTile(
                title: Text(service),
                value: selectedServices.contains(service),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedServices.add(service);
                    } else {
                      selectedServices.remove(service);
                    }
                  });
                },
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditingServices = !isEditingServices;
              });
              updatePartnerInfo(); // Lưu dịch vụ khi nhấn "Save Services"
            },
            child: Text("Save Services"),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        Navigator.pushReplacementNamed(context, '/LoginScreen');
      },
      child: Text("Log Out"),
    );
  }
}
