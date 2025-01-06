import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, String>> selectedServices = [];
  String imageUrl = "";
  String businessName = "";
  String businessCode = "";
  String businessLicense = "";
  String serviceCategory = ""; // Store the category type (e.g., PET_CARE, VETERINARY_CARE)

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

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8888/api/partner/show/$userId'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      try {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          businessName = data['businessName'] ?? "Thông tin không có sẵn";
          businessCode = data['businessCode'] ?? "Thông tin không có sẵn";
          businessLicense = data['businessLicense'] ?? "Thông tin không có sẵn";
          addressController.text = data['address'] ?? "Địa chỉ không có sẵn";
          phoneController.text = data['phone'] ?? "Số điện thoại không có sẵn";
          emailController.text = data['email'] ?? "Email không có sẵn";
          imageUrl = data['imageUrl'] ?? "Hình ảnh không có sẵn";

          serviceCategory = data['serviceCategory'] ?? "Không xác định";

          selectedServices = data['services'] != null
              ? List<Map<String, String>>.from(
            data['services'].map((service) {
              return {
                "name": serviceTranslation.keys.firstWhere(
                      (key) => serviceTranslation[key] == service['serviceCode'],
                  orElse: () => service['serviceCode'],
                ),
                "price": service['price']?.toString() ?? "Chưa cập nhật",
              };
            }).toList(),
          )
              : [];

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
    print('$userId');

    List<Map<String, String?>> serviceCodes = selectedServices.map((service) {
      return {
        'serviceCode': serviceTranslation[service['name']] ?? service['name'],
        'price': service['price'],
      };
    }).toList();

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8888/api/partner/update-partner-info/$userId'),
      headers: {'Content-Type': 'application/json; charset=utf-8'}, // Ensure UTF-8 encoding for the request
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
            "All Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Column(
            children: allServices.map((serviceName) {
              // Kiểm tra xem dịch vụ có trong selectedServices hay không
              final registeredService = selectedServices.firstWhere(
                    (service) => service['name'] == serviceName,
                orElse: () => {},
              );
              final isRegistered = registeredService.isNotEmpty;
              final price = registeredService['price'] ?? "";

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isRegistered,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              // Thêm dịch vụ vào danh sách đăng ký
                              selectedServices.add({"name": serviceName, "price": "0"});
                            } else {
                              // Xóa dịch vụ khỏi danh sách đăng ký
                              selectedServices.removeWhere((service) => service['name'] == serviceName);
                            }
                          });
                        },
                      ),
                      Text(serviceName),
                    ],
                  ),
                  if (isRegistered)
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: TextEditingController(text: price),
                        decoration: InputDecoration(labelText: "Price"),
                        onChanged: (newPrice) {
                          setState(() {
                            final index = selectedServices.indexWhere(
                                    (service) => service['name'] == serviceName);
                            if (index != -1) {
                              selectedServices[index]['price'] = newPrice;
                            }
                          });
                        },
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditingServices = false;
              });
              updatePartnerInfo();
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

