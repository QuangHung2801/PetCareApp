import 'package:flutter/material.dart';
import 'package:ungdungchamsocthucung/View/PetProfile/vaccine.dart';

import 'Viewappointment.dart';
import 'PetProfile.dart';



class PetCareManagement extends StatelessWidget {
  late final int petId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lưa chon'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.orange,
              child: Icon(Icons.pets, size: 50, color: Colors.white),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: [
                _buildGridItem('Nhắc lịch hẹn', Icons.timelapse, context, PetHealthScreen(), Colors.red),
                _buildGridItem('Sổ sức khỏe thú cưng', Icons.book, context, PetHealthScreen(), Colors.green),
                _buildGridItem('Đặt lịch hẹn' , Icons.timer, context,  ViewAppointment(), Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo một mục lưới (grid item) với màu tùy chỉnh
  Widget _buildGridItem(String title, IconData icon, BuildContext context, Widget destinationScreen, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color, // Sử dụng màu được truyền vào
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.white),
            SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
