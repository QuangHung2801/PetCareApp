import 'package:flutter/material.dart';
import 'package:ungdungchamsocthucung/View/Service/pet_care_screen.dart';
import 'package:ungdungchamsocthucung/View/Service/pet_hotel_screen.dart';
import 'package:ungdungchamsocthucung/View/Service/petfood_screen.dart';
import 'package:ungdungchamsocthucung/View/Service/petsitting_screen.dart';
import 'package:ungdungchamsocthucung/View/Service/transport_screen.dart';
import 'package:ungdungchamsocthucung/View/Service/veterinary_screen.dart';
import 'package:ungdungchamsocthucung/View/Service/walking_screen.dart';

import 'adopt_screen.dart';
import 'cleaning_screen.dart';
import 'clinic_list_screen.dart';


class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Dịch vụ', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/banner2.jpg', // Đường dẫn tới hình ảnh trong thư mục assets
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClinicListScreen()),
                    );
                  },
                  child: ServiceCard(
                    title: 'Phòng khám thú y',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetCareScreen()),
                    );
                  },
                  child: ServiceCard(
                    title: 'Chăm sóc thú cưng',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildServiceIcon(
                  context,
                  Icons.pets,
                  'Nhận nuôi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdoptPetPage()),
                    );
                  },
                ),
                _buildServiceIcon(
                  context,
                  Icons.local_hospital,
                  'Tiệm thú y',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VeterinaryScreen()),
                    );
                  },
                ),
                _buildServiceIcon(
                  context,
                  Icons.delivery_dining,
                  'Vận chuyển',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VeterinaryScreen()),
                    );
                  },
                ),

                _buildServiceIcon(
                  context,
                  Icons.food_bank,
                  'Thức ăn',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetFoodScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context, IconData icon, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blueAccent),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;

  ServiceCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
