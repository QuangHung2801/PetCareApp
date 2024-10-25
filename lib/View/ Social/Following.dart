import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePageSociety(),
    );
  }
}

class HomePageSociety extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageSociety> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    FollowingPage(),
    ForYouPage(),
    ClubsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/ssss.png', // Logo của ứng dụng
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Pet',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Xử lý tìm kiếm
            },
          ),
          IconButton(
            icon: Icon(Icons.mail, color: Colors.black),
            onPressed: () {
              // Xử lý thư
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs: For you, Following, Clubs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  child: Text(
                    'Dành cho bạn',
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.orange : Colors.black, // Đổi màu khi chọn
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(0),
                  child: Text(
                    'Theo dõi',
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.orange : Colors.black, // Đổi màu khi chọn
                      fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(2),
                  child: Text(
                    'Hội nhóm',
                    style: TextStyle(
                      color: _selectedIndex == 2 ? Colors.orange : Colors.black, // Đổi màu khi chọn
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Danh sách bài viết
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}

// Trang FollowingPage
class FollowingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        PostWidget(
          username: 'Linh Huệ',
          timeAgo: '1 giờ trước',
          content: 'Bé nhà dễ thương ngoan ngoãn 😍 #dog',
          imageUrl: 'assets/ssss.png',
        ),
        PostWidget(
          username: 'Linh Huệ',
          timeAgo: '2 giờ trước',
          content: 'Cần tìm bạn tình cho bé cún (đực) ai có nhu cầu liên hệ a',
          imageUrl: 'assets/ssss.png',
        ),
      ],
    );
  }
}

// Trang ForYouPage
class ForYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        PostWidget(
          username: 'Ngọc Bích',
          timeAgo: '3 phút trước',
          content: 'Hôm nay mình vừa mua một bé mèo xinh xắn 🐱',
          imageUrl: 'assets/ssss.png',
        ),
        PostWidget(
          username: 'Nam Nguyễn',
          timeAgo: '10 phút trước',
          content: 'Chó là bạn tốt nhất của con người!',
          imageUrl: 'assets/ssss.png',
        ),
        PostWidget(
          username: 'Minh Anh',
          timeAgo: '30 phút trước',
          content: 'Tìm nhà cho 2 bé cún này 🐶❤️',
          imageUrl: 'assets/ssss.png',
        ),
      ],
    );
  }
}

// Trang ClubsPage
class ClubsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        ClubWidget(
          clubName: 'Câu Lạc Bộ Chó',
          clubDescription: 'Nơi những người yêu chó có thể chia sẻ và kết nối!',
          imageUrl: 'assets/ssss.png',
        ),
        ClubWidget(
          clubName: 'Câu Lạc Bộ Mèo',
          clubDescription: 'Chúng tôi yêu mèo! Hãy tham gia và chia sẻ tình yêu của bạn.',
          imageUrl: 'assets/ssss.png',
        ),
        ClubWidget(
          clubName: 'Câu Lạc Bộ Thú Cưng',
          clubDescription: 'Một nơi dành cho tất cả những ai yêu thích thú cưng.',
          imageUrl: 'assets/ssss.png',
        ),
      ],
    );
  }
}

// Widget Club
class ClubWidget extends StatelessWidget {
  final String clubName;
  final String clubDescription;
  final String imageUrl;

  ClubWidget({
    required this.clubName,
    required this.clubDescription,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clubName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(clubDescription),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Xử lý tham gia câu lạc bộ
              },
              child: Text('Tham gia'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, // Màu chữ nút
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget bài viết
class PostWidget extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String content;
  final String imageUrl;

  PostWidget({
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/ssss.png'),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(timeAgo),
                        SizedBox(width: 5),
                        Icon(Icons.public, size: 12),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Theo dõi',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(content),
            SizedBox(height: 10),
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.favorite_border),
                SizedBox(width: 10),
                Icon(Icons.comment),
                SizedBox(width: 10),
                Icon(Icons.share),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
