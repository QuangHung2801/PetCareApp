import 'package:flutter/material.dart';

class LichSuTriBenhScreen extends StatelessWidget {
  // Danh sách lịch sử trị bệnh mẫu
  final List<TreatmentHistory> treatmentHistory = [
    TreatmentHistory(
      disease: 'Cúm',
      date: '01/01/2023',
      medication: 'Thuốc A',
    ),
    TreatmentHistory(
      disease: 'Tiêu chảy',
      date: '15/01/2023',
      medication: 'Thuốc B',
    ),
    TreatmentHistory(
      disease: 'Nhiễm trùng',
      date: '20/01/2023',
      medication: 'Thuốc C',
    ),
    TreatmentHistory(
      disease: 'Sán',
      date: '05/02/2023',
      medication: 'Endogard',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch Sử Trị Bệnh'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Lịch Sử Trị Bệnh', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: treatmentHistory.length,
              itemBuilder: (context, index) {
                final history = treatmentHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('${history.disease}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Thuốc: ${history.medication}\nNgày: ${history.date}'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Model cho Lịch sử Trị Bệnh
class TreatmentHistory {
  final String disease;
  final String date;
  final String medication;

  TreatmentHistory({
    required this.disease,
    required this.date,
    required this.medication,
  });
}
