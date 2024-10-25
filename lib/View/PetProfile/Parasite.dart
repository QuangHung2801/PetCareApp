import 'package:flutter/material.dart';

class NoiKySinhScreen extends StatefulWidget {
  @override
  _NoiKySinhScreenState createState() => _NoiKySinhScreenState();
}

class _NoiKySinhScreenState extends State<NoiKySinhScreen> {
  DateTime selectedDate = DateTime.now();
  bool isCheckedSan = false;
  bool isCheckedGiun = false;
  bool isCheckedThuoc1 = false;
  bool isCheckedThuoc2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nội ký sinh'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  // backgroundImage: NetworkImage('https://link-to-cat-image'), // Thay bằng URL ảnh thực tế
                ),
                SizedBox(width: 16),
                Expanded( // Wrap Column with Expanded
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.female, color: Colors.orange),
                          SizedBox(width: 4),
                          Text('Catty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text('30/07/2021 | Mèo Mỹ lông ngắn', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Nội ký sinh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text('Thời gian', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Chọn ngày',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              controller: TextEditingController(
                text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
            ),
            SizedBox(height: 20),
            Text('Bệnh', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Sán'),
              value: isCheckedSan,
              onChanged:(bool? value) {
                setState(() {
                  isCheckedSan = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Giun'),
              value: isCheckedGiun,
              onChanged: (bool?value) {
                setState(() {
                  isCheckedGiun = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Thuốc', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Endogard'),
              value: isCheckedThuoc1,
              onChanged: (bool? value) {
                setState(() {
                  isCheckedThuoc1 = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Vime deworm'),
              value: isCheckedThuoc2,
              onChanged: (bool? value) {
                setState(() {
                  isCheckedThuoc2 = value!;
                });
              },
            ),
            // Thêm các checkbox khác theo yêu cầu của bạn
          ],
        ),
      ),
    );
  }
}
