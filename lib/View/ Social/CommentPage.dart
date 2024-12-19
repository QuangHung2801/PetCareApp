import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  final int postId; // ID bài viết để load bình luận

  CommentPage({required this.postId});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = []; // Danh sách bình luận

  @override
  void initState() {
    super.initState();
    _loadComments(); // Load bình luận khi mở trang
  }

  Future<void> _loadComments() async {
    final url = Uri.parse('http://10.0.2.2:8888/api/comments?postId=${widget.postId}');
    try {
      final response = await http.get(url, headers: {'Accept': 'application/json; charset=UTF-8'});
      if (response.statusCode == 200) {
        setState(() {
          comments = List<Map<String, dynamic>>.from(json.decode(response.body) ?? []);
        });
      } else {
        print('Response body: ${response.body}');
        print('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      // Kiểm tra nếu userId là null
      if (userId == null) {
        print('User ID is null');
        return; // Nếu userId null, không tiếp tục hàm
      }

      final url = Uri.parse('http://10.0.2.2:8888/api/comments?userId=$userId&postId=${widget.postId}');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'}, // Đảm bảo gửi dữ liệu với mã hóa UTF-8
          body: json.encode({
            'content': _commentController.text, // Nội dung bình luận
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          setState(() {
            comments.add(json.decode(response.body) ?? {}); // Đảm bảo không thêm dữ liệu null
          });
          _commentController.clear(); // Xóa nội dung trong ô nhập
        } else {
          print('Failed to post comment: ${response.statusCode}');
          print('Error details: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bình luận'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Danh sách bình luận
          Expanded(
            child: comments.isEmpty
                ? Center(child: Text('Chưa có bình luận nào'))
                : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                String content = comments[index]['content'] ?? 'Nội dung bình luận không xác định'; // Default if content is null
                String username = comments[index]['user']['name'] ?? 'Tên người dùng không xác định';
                username = utf8.decode(utf8.encode(username));// Default if name is null
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/user.jpg'), // Hình ảnh người dùng
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      // Tên người gửi
                      Expanded(
                        child: Text(
                          username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(content), // Nội dung bình luận
                );
              },
            ),
          ),

          // Input để thêm bình luận
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Nhập bình luận...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.orange),
                  onPressed: _postComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
