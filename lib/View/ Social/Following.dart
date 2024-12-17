import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CreatePostPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Pet App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePageSociety(),
    );
  }
}

Future<List<Post>> fetchPosts() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/posts'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print("Dữ liệu bài viết nhận được: $jsonResponse");

    return jsonResponse.map((post) => Post.fromJson(post)).toList();
  } else {
    print("Lỗi: ${response.statusCode}");
    throw Exception('Failed to load posts');
  }
}

class Post {
  final int id;
  final String username;
  final String content;
  final List<String> imageUrls;


  Post({required this.id, required this.username, required this.content, required this.imageUrls});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0, // Default to 0 if null
      username: json['username'] ?? 'Hùng', // Default to 'Unknown' if null
      content: json['content'] ?? 'No Content', // Default to 'No Content' if null
      imageUrls: json['imageUrls'] != null && json['imageUrls'] is List
          ? List<String>.from(json['imageUrls'])
          : [], // Default to empty string if null
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
              'assets/dog.jpg', // Logo của ứng dụng
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Pet Pet',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search, color: Colors.black),
          //   onPressed: () {
          //     // Xử lý tìm kiếm
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.mail, color: Colors.black),
          //   onPressed: () {
          //     // Xử lý thư
          //   },
          // ),
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
                  onPressed: () => _onItemTapped(0),
                  child: Text(
                    'Cộng đồng',
                    style: TextStyle(
                      color: _selectedIndex == 0? Colors.orange : Colors.black, // Đổi màu khi chọn
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  child: Text(
                    'Cá nhân',
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.orange : Colors.black,
                      fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                // TextButton(
                //   onPressed: () => _onItemTapped(2),
                //   child: Text(
                //     'Hội nhóm',
                //     style: TextStyle(
                //       color: _selectedIndex == 2 ? Colors.orange : Colors.black, // Đổi màu khi chọn
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreatePostPage(); // Hiển thị CreatePostPage khi nhấn vào ListTile
                },
              );
            },

            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/user.jpg'), // Thay ảnh đại diện của bạn
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: 'thông tin pet cần đăng?',
                border: InputBorder.none,
              ),
              enabled: false, // Ngăn người dùng nhập vào TextField
            ),
          ),

          Divider(),
          // Các nút chức năng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FeatureButton(
                icon: Icons.videocam,
                color: Colors.red,
                label: 'Video trực tiếp',
              ),
              FeatureButton(
                icon: Icons.photo,
                color: Colors.green,
                label: 'Ảnh/video',
              ),
              FeatureButton(
                icon: Icons.emoji_emotions,
                color: Colors.yellow[800],
                label: 'Cảm xúc/hoạt động',
              ),
            ],
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


class FeatureButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String label;

  const FeatureButton({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts(); // Gọi API lấy tất cả bài viết
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Có lỗi xảy raa!'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài viết'));
        } else {

          // Hiển thị danh sách bài viết
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Post post = snapshot.data![index];
              return PostWidget(
                username: post.username,
                timeAgo: 'Vài phút trướct',
                content: post.content,
                imageUrls: post.imageUrls,
              );
            },
          );
        }
      },
    );
  }
}

Future<List<Post>> fetchForYouPosts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/posts/$userId'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print("Dữ liệu bài viết ForYou nhận được: $jsonResponse");

    return jsonResponse.map((post) => Post.fromJson(post)).toList();
  } else {
    print("Lỗi: ${response.statusCode}");
    throw Exception('Failed to load posts');
  }
}


class ForYouPage extends StatefulWidget {
  @override
  _ForYouPageState createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  late Future<List<Post>> futurePosts2;

  @override
  void initState() {
    super.initState();
    futurePosts2 = fetchForYouPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: futurePosts2,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Có lỗi xảy ra!'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài viết'));
        } else {
          // Lọc bài viết chỉ của người dùng hiện tại


          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Post post = snapshot.data![index];
              return PostWidget(
                username: post.username,
                timeAgo: 'Vài phút trước',
                content: post.content,
                imageUrls: post.imageUrls,
              );
            },
          );
        }
      },
    );
  }
}


//
//
//
//
//
// // Widget bài viết
class PostWidget extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String content;
  final List<String> imageUrls;

  PostWidget({
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.imageUrls,
  });
//
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
                  backgroundImage: AssetImage('assets/user.jpg'),
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
            // Text(content),
            SizedBox(height: 10),
            // Hiển thị tất cả ảnh từ imageUrls
            Column(
              children: imageUrls.map((imageUrl) {
                // Kết hợp URL đầy đủ cho mỗi ảnh
                String fullImageUrl = 'http://10.0.2.2:8888/$imageUrl';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Image.network(
                    fullImageUrl,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                  ),
                );
              }).toList(),
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