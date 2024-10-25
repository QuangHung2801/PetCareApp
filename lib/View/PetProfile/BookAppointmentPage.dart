import 'package:flutter/material.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final TextEditingController reasonController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedPet = "Chó Husky";

  // Danh sách thú cưng
  final List<String> pets = ["Chó Husky", "Mèo Anh lông ngắn", "Chim Vẹt"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt lịch khám cho thú cưng'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView( // Thêm SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn thú cưng
            Text("Chọn thú cưng", style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: selectedPet,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPet = newValue;
                });
              },
              items: pets.map<DropdownMenuItem<String>>((String pet) {
                return DropdownMenuItem<String>(
                  value: pet,
                  child: Text(pet),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Chọn ngày hẹn
            Text("Chọn ngày hẹn", style: TextStyle(fontSize: 16)),
            ListTile(
              title: Text(
                selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "Chọn ngày",
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16),

            // Chọn giờ hẹn
            Text("Chọn giờ hẹn", style: TextStyle(fontSize: 16)),
            ListTile(
              title: Text(
                selectedTime != null
                    ? "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}"
                    : "Chọn giờ",
              ),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 16),

            // Lý do khám
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: "Lý do khám",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),

            // Nút đặt lịch
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý logic đặt lịch tại đây
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Đặt lịch', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
