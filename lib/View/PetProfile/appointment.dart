import 'package:flutter/material.dart';

class AppointmentReminderPage extends StatelessWidget {
  // Dữ liệu mẫu cho các lịch hẹn
  final List<Map<String, String>> appointments = [
    {
      "petName": "Chó Husky",
      "caterogy": "Chó",
      "date": "2024-10-30",
      "time": "10:30 AM",
      "reason": "Khám sức khỏe định kỳ",
    },
    {
      "petName": "Mèo Anh lông ngắn",
      "caterogy": "mèo",
      "date": "2024-11-05",
      "time": "02:00 PM",
      "reason": "Tiêm phòng",
    },
    {
      "petName": "Chim Vẹt",
      "caterogy": "Chim",
      "date": "2024-11-10",
      "time": "09:00 AM",
      "reason": "Khám răng miệng",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch nhắc hẹn khám bệnh'),
          backgroundColor:Colors.orange,
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thú cưng: ${appointment['petName']}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Loại thú cưng: ${appointment['caterogy']}"),
                  Text("Ngày hẹn: ${appointment['date']}"),
                  Text("Giờ hẹn: ${appointment['time']}"),
                  Text("Lý do: ${appointment['reason']}"),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý nhắc nhở
                      },
                      child: Text("Xác nhận"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
