import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExplorePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('07:11', style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("Khám phá", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text("Bản tin Pet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.network('banner4.jpg'),  // Thay bằng URL ảnh thực
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pety Adoption - Tìm mái ấm mới cho các bạn chó...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text("Bảng vàng Pety", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          UserRow(name: "Lê Mỹ Nhân"),
          UserRow(name: "Hình Hoàng Thuận Thiên"),
          UserRow(name: "Thu Hiền"),
        ],
      ),

    );
  }
}

class UserRow extends StatelessWidget {
  final String name;

  UserRow({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            // backgroundImage: NetworkImage('https://example.com/avatar_image.jpg'),  // Thay bằng URL ảnh thực
          ),
          SizedBox(width: 16),
          Expanded(child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ElevatedButton(
            onPressed: () {},
            child: Text('Theo dõi'),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(), backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
