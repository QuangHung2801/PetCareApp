import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PartnerRegistrationForm extends StatefulWidget {
  @override
  _PartnerRegistrationFormState createState() => _PartnerRegistrationFormState();
}

class _PartnerRegistrationFormState extends State<PartnerRegistrationForm> {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessCodeController = TextEditingController();
  final TextEditingController businessLicenseController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;
  List<String> selectedServices = [];
  String selectedCategory = ''; // To store the selected category

  bool isVeterinarySelected = false;
  bool isPetCareSelected = false;

  List<Map<String, String>> veterinaryServices = [
    {'label': 'Khám chữa bệnh', 'value': 'VETERINARY_EXAMINATION'},
    {'label': 'Tiêm phòng', 'value': 'VACCINATION'},
    {'label': 'Phẫu thuật', 'value': 'SURGERY'},
    {'label': 'Khám định kỳ', 'value': 'REGULAR_CHECKUP'},
  ];

  List<Map<String, String>> petCareServices = [
    {'label': 'Trông giữ thú cưng', 'value': 'PET_BOARDING'},
    {'label': 'Spa cho thú cưng', 'value': 'PET_SPA'},
    {'label': 'Tắm và cắt tỉa lông', 'value': 'PET_GROOMING'},
    {'label': 'Dắt thú cưng đi dạo', 'value': 'PET_WALKING'},
  ];

  // Hàm chọn hình ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Hàm chọn thời gian mở cửa
  Future<void> _selectOpeningTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        openingTime = picked;
      });
    }
  }

  // Hàm chọn thời gian đóng cửa
  Future<void> _selectClosingTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        closingTime = picked;
      });
    }
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Lấy userId đã lưu
  }

  String? _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return "${formattedTime.hour.toString().padLeft(2, '0')}:${formattedTime.minute.toString().padLeft(2, '0')}";
  }

  // Hàm đăng ký Partner
  Future<void> registerPartner() async {
    final userId = await _getUserId(); // Lấy userId từ SharedPreferences
    if (userId == null) {
      print("User ID không tồn tại.");
      return;
    }
    final uri = Uri.parse("http://10.0.2.2:8888/api/partner/register");
    final List<String> selectedServicesList = selectedServices.toList();
    var request = http.MultipartRequest('POST', uri);
    request.fields['userId'] = userId;
    request.fields['businessName'] = businessNameController.text;
    request.fields['businessCode'] = businessCodeController.text;
    request.fields['businessLicense'] = businessLicenseController.text;
    request.fields['address'] = addressController.text;
    request.fields['openingTime'] = _formatTime(openingTime!) ?? '';
    request.fields['closingTime'] = _formatTime(closingTime!) ?? '';
    request.fields['services'] = selectedServicesList.join(',');
    request.fields['serviceCategory'] = selectedCategory; // Sending selected category

    if (_selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ),
      );
    }
    print("Selected Category: $selectedCategory");
    final response = await request.send();
    if (response.statusCode == 200) {
      print("Đăng ký thành công");
      Navigator.pop(context);
      print("Dịch vụ đã chọn: $selectedServicesList");
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Failed to load pet profiles: ${response.statusCode}');
      print("Đăng ký thất bại: ${responseBody}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký Partner")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: businessNameController,
              decoration: InputDecoration(labelText: "Tên doanh nghiệp"),
            ),
            TextField(
              controller: businessCodeController,
              decoration: InputDecoration(labelText: "Mã số thuế"),
            ),
            TextField(
              controller: businessLicenseController,
              decoration: InputDecoration(labelText: "Giấy phép kinh doanh"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Địa chỉ"),
            ),
            const SizedBox(height: 10),
            Text("Chọn loại dịch vụ", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVeterinarySelected = !isVeterinarySelected;
                        isPetCareSelected = false; // Close "Chăm sóc thú cưng"
                        selectedCategory = 'VETERINARY_CARE'; // Set category to Phòng khám thú y
                        selectedServices.clear();
                      });
                    },
                    child: Text("Phòng khám thú y"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPetCareSelected = !isPetCareSelected;
                        isVeterinarySelected = false; // Close "Phòng khám thú y"
                        selectedCategory = 'PET_CARE'; // Set category to Chăm sóc thú cưng
                        selectedServices.clear();
                      });
                    },
                    child: Text("Chăm sóc thú cưng"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isVeterinarySelected) ...[
              Text("Dịch vụ phòng khám thú y", style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: veterinaryServices.map((service) {
                  return ListTile(
                    title: Text(service['label']!),
                    leading: Checkbox(
                      value: selectedServices.contains(service['value']!),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected != null) {
                            if (selected) {
                              selectedServices.add(service['value']!);
                            } else {
                              selectedServices.remove(service['value']!);
                            }
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ] else if (isPetCareSelected) ...[
              Text("Dịch vụ chăm sóc thú cưng", style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: petCareServices.map((service) {
                  return ListTile(
                    title: Text(service['label']!),
                    leading: Checkbox(
                      value: selectedServices.contains(service['value']!),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected != null) {
                            if (selected) {
                              selectedServices.add(service['value']!);
                            } else {
                              selectedServices.remove(service['value']!);
                            }
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 10),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => _selectOpeningTime(context),
                  child: Text(openingTime != null
                      ? "Giờ mở cửa: ${openingTime!.format(context)}"
                      : "Chọn giờ mở cửa"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _selectClosingTime(context),
                  child: Text(closingTime != null
                      ? "Giờ đóng cửa: ${closingTime!.format(context)}"
                      : "Chọn giờ đóng cửa"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerPartner,
              child: Text("Đăng ký"),
            ),
          ],
        ),
      ),
    );
  }
}
