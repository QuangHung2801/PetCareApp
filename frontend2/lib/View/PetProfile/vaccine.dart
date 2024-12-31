import 'package:flutter/material.dart';
class TiemPhongVaccineScreen extends StatefulWidget {
  @override
  _TiemPhongVaccineScreenState createState() => _TiemPhongVaccineScreenState();
}

class _TiemPhongVaccineScreenState extends State<TiemPhongVaccineScreen> {
  DateTime selectedDate = DateTime.now();
  bool isCheckedPrimucell = false;
  bool isCheckedRabisin = false;
  bool isCheckedPurevax = false;
  bool isCheckedNobivac = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiêm phòng Vaccine'),
        backgroundColor: Colors.orange,
        actions: [
          TextButton(
            onPressed: () {
              // Thêm logic cho nút "Thêm" tại đây
            },
            child: Text(
              'Thêm',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
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
              child: Text('Tiêm phòng Vaccine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,  // Màu chữ
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
            Text('Vaccine cho mèo', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Primucell FIP'),
              value: isCheckedPrimucell,
              onChanged:(bool? value) {
                setState(() {
                  isCheckedPrimucell = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Rabisin'),
              value: isCheckedRabisin,
              onChanged: (bool? value) {
                setState(() {
                  isCheckedRabisin = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Purevax RCPCh'),
              value: isCheckedPurevax,
              onChanged: (bool? value) {
                setState(() {
                  isCheckedPurevax = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Nobivac Feline 1-HCPCh'),
              value: isCheckedNobivac,
              onChanged: (bool? value) {
                setState(() {
                  isCheckedNobivac = value!;
                });
              },
            ),
            // Thêm các checkbox khác nếu cần
          ],
        ),
      ),
    );
  }
}
