import 'package:flutter/material.dart';
import 'package:ungdungchamsocthucung/View/PetProfile/vaccine.dart';

import 'ExternalParasites.dart';
import 'Parasite.dart';
import 'medicalHistory.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sổ sức khỏe thú cưng',
      home: PetHealthScreen(),
    );
  }
}

class PetHealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sổ sức khỏe thú cưng'),
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
                _buildGridItem('Nội ký sinh', Icons.bug_report ,context, NoiKySinhScreen()),
                _buildGridItem('Ngoại ký sinh', Icons.bug_report_outlined ,context, NgoaiKySinhScreen()),
                _buildGridItem('Tiêm phòng Vaccine', Icons.vaccines,context, TiemPhongVaccineScreen()),
                _buildGridItem('Điều trị và phẫu thuật', Icons.local_hospital,context, NoiKySinhScreen()),
                _buildGridItem('Lịch sử điều trị bệnh', Icons.history,context, LichSuTriBenhScreen()),
                _buildGridItem('Thông tin thú cưng', Icons.pets,context, NoiKySinhScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon, BuildContext context, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
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