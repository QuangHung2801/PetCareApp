import 'dart:convert';
import 'package:flutter/material.dart';
import '../PetProfile/AddPetProfile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class PetProfile {
  final int id;
  final String name;
  final String imageUrl;

  PetProfile({required this.id, required this.name, required this.imageUrl});

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PetProfile> petProfiles = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchPetProfiles(); // Gọi phương thức để tải danh sách thú cưng
  }

  Future<void> fetchPetProfiles() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Retrieve the stored user ID

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8888/api/pet/all'),
        body: {'userId': userId}, // Use the retrieved user ID
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          petProfiles = data.map((json) => PetProfile.fromJson(json)).toList();
        });
      } else {
        print('Failed to load pet profiles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading pet profiles: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildUserProfile(),
          SizedBox(height: 20),
          _buildPetList(),
          SizedBox(height: 20),
          _buildAddProfileCard(context),
          SizedBox(height: 20),
          _buildMenuOptions(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'user',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Vào trang cá nhân'),
          ],
        ),
        Spacer(),
        Icon(Icons.qr_code_scanner),
      ],
    );
  }

  Widget _buildAddProfileCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPetProfilePage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(8),

        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thêm Profile thú cưng",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Nếu bạn có nuôi thú cưng thì tại sao không tạo Profile cho người bạn nhỏ của mình!",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline, size: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        _buildMenuOptionCard(
          icon: Icons.redeem,
          title: "Đổi thưởng",
          subtitle: "Rất nhiều phần quà đang chờ bạn đổi thưởng!",
          trailing: "0 Xu",
        ),
        SizedBox(height: 16),
        _buildMenuOptionCard(
          icon: Icons.nfc,
          title: "Pet Smart NFC",
        ),
        SizedBox(height: 16),
        _buildMenuOptionCard(
          icon: Icons.map,
          title: "Địa chỉ",
        ),
        SizedBox(height: 16),
        _buildMenuOptionCard(
          icon: Icons.pets,
          title: "Dịch vụ thú cưng",
        ),
      ],
    );
  }

  Widget _buildMenuOptionCard({required IconData icon, required String title, String? subtitle, String? trailing}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: Colors.orange),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
                ]
              ],
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  Widget _buildPetList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (petProfiles.isEmpty) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Gia đình của bạn có ${petProfiles.length} thành viên',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 130, // Adjust height if needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: petProfiles.length,
              itemBuilder: (context, index) {
                final pet = petProfiles[index];
                return Container(
                  width: 120, // Square card with width = height
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('http://10.0.2.2:8888/${pet.imageUrl}'),
                        radius: 35, // Adjust radius for circular image
                      ),
                      SizedBox(height: 5),
                      Text(
                        pet.name,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],

                  ),

                );

              },
            ),
          ),

        ],
      );
    }
  }


}
