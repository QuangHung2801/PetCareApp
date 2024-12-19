import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CommentPage.dart';
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

  print('Response body: ${response.body}');
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    List<Post> posts = data.map((json) => Post.fromJson(json)).toList();
    posts.forEach((post) {
      print('Name: ${post.name}'); // Kiểm tra dữ liệu name
    });
    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

class Post {
  final int id;
  final String name;
  final String content;
  final List<String> imageUrls;
  final String createdAt;
  final int likeCount;
  final String image;


  Post({required this.id, required this.name, required this.content, required this.imageUrls,required this.createdAt, required this.likeCount,required this.image,});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0, // Default to 0 if null
      name: json['user'] != null && json['user']['name'] != null
          ? json['user']['name'] // Lấy username từ object user
          : 'Hùng', // Default nếu không có // Default to 'Unknown' if null
      content: json['content'] ?? 'No Content', // Default to 'No Content' if null
      imageUrls: json['imageUrls'] != null && json['imageUrls'] is List
          ? List<String>.from(json['imageUrls'])
          : [],
      createdAt: json['createdAt'] ?? 'N/A',
      likeCount: json['likeCount'] ?? 0,
      image:json['petProfile'] != null && json['petProfile']['imageUrl'] != null
          ? json['petProfile']['imageUrl'] // Lấy username từ object user
          : '',// Default to empty string if null
    );
  }
}

String _formatDate(String date) {
  try {
    final parsedDate = DateTime.parse(date);
    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} lúc ${parsedDate.hour}:${parsedDate.minute}"; // Thêm giờ phút
  } catch (e) {
    return "Không xác định"; // Trả về chuỗi mặc định nếu không hợp lệ
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
          // Bạn có thể thêm các icon button ở đây nếu cần.
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Tabs: For you, Following
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => _onItemTapped(0),
                    child: Text(
                      'Cộng đồng',
                      style: TextStyle(
                        color: _selectedIndex == 0 ? Colors.orange : Colors.black,
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
                ],
              ),
            ),
          ),

          // ListTile (thêm bài viết mới)
          SliverToBoxAdapter(
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreatePostPage();
                  },
                );
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpg'),
              ),
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'thông tin pet cần đăng?',
                  border: InputBorder.none,
                ),
                enabled: false,
              ),
            ),
          ),

          // Nút chức năng
          SliverToBoxAdapter(
            child: Row(
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
          ),

          // Danh sách bài viết
          SliverFillRemaining(
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
          return Text("Lỗi: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài viết'));
        } else {

          // Hiển thị danh sách bài viết
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Post post = snapshot.data![index];
              return PostWidget(
                name: post.name,
                createdAt: post.createdAt ,
                content: post.content,
                imageUrls: post.imageUrls,
                postId: post.id,
                likeCount:post.likeCount,
                image:post.image,
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
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    print("Dữ liệu bài viết ForYou nhận được: $jsonResponse");

    return jsonResponse.map((post) => Post.fromJson(post)).toList();
  } else {
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
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài viết'));
        } else {
          // Lọc bài viết chỉ của người dùng hiện tại


          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Post post = snapshot.data![index];
              return PostWidget(
                name: post.name,
                createdAt: post.createdAt,
                content: post.content,
                imageUrls: post.imageUrls,
                postId: post.id,
                  likeCount:post.likeCount,
                image:post.image,
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
class PostWidget extends StatefulWidget {
  final String name;
  final String createdAt;
  final String content;
  final List<String> imageUrls;
  final int postId;
  final int likeCount;
  final String image;

  PostWidget({
    required this.name,
    required this.createdAt,
    required this.content,
    required this.imageUrls,
    required this.postId,
    required this.likeCount,
    required this.image,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false; // Theo dõi trạng thái thích
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likeCount;
    checkLikeStatus(); // Kiểm tra trạng thái like khi khởi tạo widget
  }

  Future<void> checkLikeStatus() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8888/api/likes/status?userId=$userId&postId=${widget.postId}'),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          setState(() {
            isLiked = json.decode(response.body);
          });
        } else {
          print('Server error: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Lấy userId từ local storage

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bạn cần đăng nhập để thực hiện chức năng này!'),
      ));
      return;
    }

    try {
      String apiUrl = 'http://10.0.2.2:8888/api/likes?userId=$userId&postId=${widget.postId}';

      final response = isLiked
          ? await http.delete(Uri.parse(apiUrl))
          : await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          isLiked = !isLiked;
          likeCount += isLiked ? 1 : -1; // Cập nhật số lượng like
        });
        await checkLikeStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Có lỗi xảy ra khi cập nhật lượt thích!'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Không thể kết nối tới server!'),
      ));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                      widget.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          _formatDate(widget.createdAt), // Format the date
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.public, size: 12),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      // Thay CircleAvatar bằng Image.network để lấy hình ảnh từ MySQL
                      widget.image.isNotEmpty
                          ? CircleAvatar(
                        backgroundImage: NetworkImage('http://10.0.2.2:8888/${widget.image}'), // Thêm URL gốc vào trước tên file
                        radius: 15,
                      )
                          : Container(), // Nếu không có hình ảnh, không hiển thị gì
                      SizedBox(width: 5),
                      Text(
                        'Theo dõi',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Content of the post
            Text(
              widget.content,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            // Images of the post
            Column(
              children: widget.imageUrls.map((imageUrl) {
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
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: toggleLike,
                ),
                Text('$likeCount', style: TextStyle(fontSize: 16)), // Hiển thị số lượng like
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(postId: widget.postId),
                      ),
                    );
                  },
                  child: Icon(Icons.comment),
                ),
                SizedBox(width: 10),
                Icon(Icons.share),
              ],
            )
          ],
        ),
      ),
    );
  }
}