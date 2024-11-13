import 'package:flutter/material.dart';

class BookingServiceScreen extends StatefulWidget {
  @override
  _BookingServiceScreenState createState() => _BookingServiceScreenState();
}

class _BookingServiceScreenState extends State<BookingServiceScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _petController = TextEditingController();

  bool surgerySelected = false;
  bool vaccinationSelected = false;
  bool endoscopySelected = false;
  bool neuteringSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt dịch vụ'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên khách hàng'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _petController,
              decoration: InputDecoration(labelText: 'Thú cưng'),
            ),
            SizedBox(height: 20),
            Text(
              'Chọn dịch vụ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text('Phẫu thuật'),
              value: surgerySelected,
              onChanged: (value) {
                setState(() {
                  surgerySelected = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Tiêm phòng'),
              value: vaccinationSelected,
              onChanged: (value) {
                setState(() {
                  vaccinationSelected = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Nội soi'),
              value: endoscopySelected,
              onChanged: (value) {
                setState(() {
                  endoscopySelected = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Thiến chó mèo'),
              value: neuteringSelected,
              onChanged: (value) {
                setState(() {
                  neuteringSelected = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý khi bấm nút "Xác nhận đặt dịch vụ"
                  _submitBooking();
                },
                child: Text('Xác nhận đặt dịch vụ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitBooking() {
    // Xử lý đặt dịch vụ, ví dụ lưu thông tin vào cơ sở dữ liệu hoặc gửi đến server
    String name = _nameController.text;
    String phone = _phoneController.text;
    String pet = _petController.text;

    List<String> selectedServices = [];
    if (surgerySelected) selectedServices.add('Phẫu thuật');
    if (vaccinationSelected) selectedServices.add('Tiêm phòng');
    if (endoscopySelected) selectedServices.add('Nội soi');
    if (neuteringSelected) selectedServices.add('Thiến chó mèo');

    // Hiển thị thông tin đặt dịch vụ (chỉ là ví dụ)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thông tin đặt dịch vụ'),
          content: Text(
            'Tên: $name\nSĐT: $phone\nThú cưng: $pet\nDịch vụ đã chọn: ${selectedServices.join(', ')}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
