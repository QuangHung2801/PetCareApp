import 'package:flutter/material.dart';

class GiaiPhauScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pet Medical Record"),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Quay lại trang trước
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with pet image and name
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        // backgroundImage: AssetImage('assets/cat.png'), // Replace with your image path
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Catty",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text("30/07/2021 "),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Treatment and Surgery button
                ElevatedButton.icon(
                  icon: Icon(Icons.healing),
                  label: Text('Điều trị và phẫu thuật'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Date and Clinical Diagnosis
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thời gian',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('10/08/2021'),
                        SizedBox(height: 16),
                        Text(
                          'Chẩn đoán lâm sàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nhiệt độ cơ thể'),
                            Text('37.5 độ'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Trọng lượng'),
                            Text('5 kg'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nhịp tim'),
                            Text('190/phút'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tần số hô hấp'),
                            Text('190/phút'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Màu niêm mạc'),
                            Text('Bình thường'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Additional diagnostics and conclusion
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chẩn đoán cận lâm sàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Kết quả xét nghiệm máu'),
                        TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Thêm hình ảnh'),
                          onPressed: () {},
                        ),
                        SizedBox(height: 8),
                        Text('Kết luận'),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Nhập kết luận',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Kit test bệnh'),
                        TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Thêm hình ảnh'),
                          onPressed: () {},
                        ),
                        SizedBox(height: 8),
                        Text('Kết luận'),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Nhập kết luận',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
