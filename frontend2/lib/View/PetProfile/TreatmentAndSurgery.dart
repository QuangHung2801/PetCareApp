import 'package:flutter/material.dart';


class MedicalRecord extends StatefulWidget {
  @override
  _MedicalRecordState createState() => _MedicalRecordState();
}

class _MedicalRecordState extends State<MedicalRecord> {
  final TextEditingController _surgeryTypeController = TextEditingController();
  final TextEditingController _surgeryDateController = TextEditingController();
  final TextEditingController _surgeryNoteController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _conclusionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần đầu với hình ảnh và tên
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/cat_image.jpg'), // Thêm hình ảnh của bạn ở đây
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('30/07/2021 | Mèo Mỹ lông ngắn'),
                ],
              )
            ],
          ),
          SizedBox(height: 20),

          // Nút Điều trị và Phẫu thuật
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Điều trị và phẫu thuật',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Form Điều trị và Phẫu thuật
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thông tin Điều trị và Phẫu thuật', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: _surgeryTypeController,
                  decoration: InputDecoration(
                    labelText: 'Loại phẫu thuật',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _surgeryDateController,
                  decoration: InputDecoration(
                    labelText: 'Thời gian phẫu thuật',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _surgeryDateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _surgeryNoteController,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý lưu thông tin điều trị
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Thông tin đã nhập'),
                        content: Text(getInputData()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Lưu thông tin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Phần chẩn đoán lâm sàng
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chẩn đoán lâm sàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: _diagnosisController,
                  decoration: InputDecoration(
                    labelText: 'Chẩn đoán',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Text('Kết luận', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: _conclusionController,
                  decoration: InputDecoration(
                    hintText: 'Nhập kết luận',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getInputData() {
    return 'Loại phẫu thuật: ${_surgeryTypeController.text}\n'
        'Thời gian phẫu thuật: ${_surgeryDateController.text}\n'
        'Ghi chú: ${_surgeryNoteController.text}\n'
        'Chẩn đoán: ${_diagnosisController.text}\n'
        'Kết luận: ${_conclusionController.text}';
  }
}
