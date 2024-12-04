import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ungdungchamsocthucung/View/Service/pet_care_screen.dart';

import 'NearbyServiceScreen.dart';
import 'NutritionListScreen.dart';
import 'adopt_screen.dart';
import 'clinic_list_screen.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

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
            width: MediaQuery.of(context).size.width, // Chiếm toàn bộ chiều rộng màn hình
            height: 150,
            margin: EdgeInsets.zero, // Loại bỏ khoảng cách bên trên và xung quanh
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  children: [
                    Image.asset('assets/banner2.jpg', fit: BoxFit.cover),
                    Image.asset('assets/banner4.jpg', fit: BoxFit.cover),
                    Image.asset('assets/banner3.jpg', fit: BoxFit.cover),
                    Image.asset('assets/banner1.jpg', fit: BoxFit.cover),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(left: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFixedServiceCard(
                context,
                title: 'Phòng khám thú y',
                gradientColors: [Colors.blueAccent, Colors.lightBlue],
                shadowColor: Colors.blueAccent.withOpacity(0.5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClinicListScreen()),
                  );
                },
              ),
              _buildFixedServiceCard(
                context,
                title: 'Chăm sóc thú cưng',
                gradientColors: [Colors.pinkAccent, Colors.pink],
                shadowColor: Colors.pinkAccent.withOpacity(0.5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetCareScreen()),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(18.0),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NearbyServiceScreen()),
                    );
                  },
                  child: ServiceCard(
                    title: 'Dịch vụ gần nhà',
                    gradientColors: [Colors.greenAccent, Colors.green],
                    shadowColor: Colors.greenAccent.withOpacity(1),
                  ),
                ),
                SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                          MaterialPageRoute(builder: (context) => ClinicListScreen()),
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
                          MaterialPageRoute(builder: (context) => AdoptPetPage()),
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
                          MaterialPageRoute(builder: (context) => NutritionListScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


  Widget _buildFixedServiceCard(BuildContext context,
      {required String title,
        required List<Color> gradientColors,
        required Color shadowColor,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0, 4),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context, IconData icon, String label,
      {required VoidCallback onTap}) {
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


class ServiceCard extends StatelessWidget {
  final String title;
  final List<Color>? gradientColors;
  final Color? shadowColor;

  ServiceCard({required this.title, this.gradientColors, this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Giới hạn chiều cao để tránh làm lệch giao diện
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(
          colors: gradientColors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: gradientColors == null ? Colors.grey[300] : null,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          if (shadowColor != null)
            BoxShadow(
              color: shadowColor!,
              offset: Offset(0, 4),
              blurRadius: 8.0,
            ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

