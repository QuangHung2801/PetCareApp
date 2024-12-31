import 'dart:async';
import 'package:flutter/material.dart';

import 'adopt_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PetServicesPage(),
    );
  }
}

class PetServicesPage extends StatefulWidget {
  @override
  _PetServicesPageState createState() => _PetServicesPageState();
}

class _PetServicesPageState extends State<PetServicesPage> {
  int _currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);
  Timer? _bannerTimer;


  @override
  void initState() {
    super.initState();

    _bannerTimer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0; // Quay lại trang đầu tiên
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannerTimer?.cancel(); // Huỷ Timer khi không sử dụng nữa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thêm phần hiển thị địa chỉ và icon vị trí
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Địa chỉ:', style: TextStyle(fontSize: 14)),
                Icon(Icons.location_on, size: 20), // Icon vị trí
              ],
            ),
            SizedBox(height: 10), // Khoảng cách nhỏ giữa địa chỉ và tiêu đề
            Text('Dịch vụ thú cưng', style: TextStyle(fontSize: 18)),

          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Banner section with PageView
          Container(
            height: 120, // Giảm chiều cao banner
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildBannerImage('assets/banner1.jpg'),
                    _buildBannerImage('assets/banner2.jpg'),
                    _buildBannerImage('assets/banner3.jpg'),
                    _buildBannerImage('assets/banner4.jpg'),
                  ],
                ),
                // Page indicators (dots)
                Positioned(
                  bottom: 5, // Giảm khoảng cách tới đáy
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) => _buildDot(index)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8), // Giảm khoảng cách giữa banner và các icon
          // Icon services section
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            children: [
              _buildServiceIcon(
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
                Icons.local_hospital,
                'Tiệm thú y',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdoptPetPage()),
                  );
                },
              ),
              _buildServiceIcon(
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
                Icons.directions_walk,
                'Dắt thú cưng',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdoptPetPage()),
                  );
                },
              ),
              _buildServiceIcon(
                Icons.home,
                'Giữ thú cưng',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdoptPetPage()),
                  );
                },
              ),
              _buildServiceIcon(
                Icons.cleaning_services,
                'Vệ sinh',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdoptPetPage()),
                  );
                },
              ),
              _buildServiceIcon(
                Icons.airline_seat_flat,
                'Khách sạn',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdoptPetPage()),
                  );
                },
              ),
              _buildServiceIcon(
                Icons.food_bank,
                'Thức ăn',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdoptPetPage()),
                  );
                },
              ),
            ],
          ),
        ),
          SizedBox(height: 8), // Giảm khoảng cách trước phần dịch vụ đề xuất
          // Suggested services section
          Container(
            padding: EdgeInsets.all(8), // Giảm padding
            alignment: Alignment.centerLeft,
            child: Text(
              'Dịch vụ đề xuất',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSuggestedService('Dịch vụ chăm sóc thú cưng tận nơi'),
                _buildSuggestedService('Bác sĩ thú y trực tuyến'),
                _buildSuggestedService('Giao đồ ăn cho thú cưng'),
                _buildSuggestedService('Khách sạn cho thú cưng'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build each service icon
  Widget _buildServiceIcon(IconData icon, String label, {required Null Function() onTap}) {
    return GestureDetector(
      onTap: onTap, // Thêm sự kiện onTap cho mỗi biểu tượng
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            child: Icon(icon, size: 25),
          ),
          SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Function to build each suggested service
  Widget _buildSuggestedService(String serviceName) {
    return ListTile(
      title: Text(serviceName, style: TextStyle(fontSize: 14)), // Giảm kích thước text
      leading: Icon(Icons.arrow_forward, size: 20), // Giảm kích thước icon
    );
  }

  // Function to build each banner image
  Widget _buildBannerImage(String imagePath) {
    return Image.asset(imagePath, fit: BoxFit.cover);
  }

  // Function to build each dot for the page indicator
  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4), // Giảm khoảng cách giữa các dot
      width: _currentPage == index ? 10 : 7, // Giảm kích thước dot
      height: _currentPage == index ? 10 : 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
