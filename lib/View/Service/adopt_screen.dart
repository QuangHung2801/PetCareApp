import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungdungchamsocthucung/View/Service/pet_detail_screen.dart';
import 'add_pet_adopt_screen.dart';
import 'UserPostsPage.dart';

// Model for Pet Adoption Post
class PetPost {
  final int id;
  final String petName;
  final String type;
  final double weight;
  final String birthDate;
  final String description;
  final String imageUrl;
  final String contactPhone;
  final bool adopted;
  final User user;

  PetPost({
    required this.id,
    required this.petName,
    required this.type,
    required this.weight,
    required this.birthDate,
    required this.description,
    required this.imageUrl,
    required this.contactPhone,
    required this.adopted,
    required this.user,
  });

  factory PetPost.fromJson(Map<String, dynamic> json) {
    return PetPost(
      id: json['id'],
      petName: json['petName'],
      type: json['type'],
      weight: json['weight'],
      birthDate: json['birthDate'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      adopted: json['adopted'],
      contactPhone: json['contactPhone'],
      user: User.fromJson(json['user']), // Khởi tạo đối tượng User
    );
  }
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}

class AdoptPetPage extends StatefulWidget {
  @override
  _AdoptPetPageState createState() => _AdoptPetPageState();
}

class _AdoptPetPageState extends State<AdoptPetPage> {
  String selectedCategory = "tất cả";
  List<String> categories = ["tất cả", "chó", "mèo", "chim", "khác"];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  // Lấy userId của người dùng hiện tại
  _getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
    });
  }

  // Fetch the pet posts from the backend API
  Future<List<PetPost>> fetchPetPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');

    final request = http.Request('GET', Uri.parse('http://10.0.2.2:8888/api/adoption/all'));
    request.headers['Cookie'] = '$sessionId';
    request.headers['Content-Type'] = 'application/json';

    final result = await request.send();
    final responseData = await result.stream.bytesToString();

    if (result.statusCode == 200) {
      List<dynamic> data = json.decode(responseData);
      List<PetPost> posts = data.map((json) => PetPost.fromJson(json)).toList();

      // Lọc bài viết của người dùng hiện tại
      if (currentUserId != null) {
        posts = posts.where((post) => post.user.id.toString() != currentUserId).toList();
      }

      return posts;
    } else {
      throw Exception('Failed to load pet posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Icon(Icons.notifications),
              ],
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<PetPost>>(
        future: fetchPetPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<PetPost> petPosts = snapshot.data!;

          // Lọc danh sách thú cưng theo category được chọn
          if (selectedCategory != "tất cả") {
            petPosts = petPosts.where((post) => post.type.toLowerCase() == selectedCategory.toLowerCase()).toList();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner giới thiệu
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Join Our Animal Lovers Community",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Join Us"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset("assets/cat1.png", height: 100),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PostPetPage()),
                            );
                          },
                          child: Text("Post"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list), // Icon
                        SizedBox(width: 8), // Khoảng cách giữa icon và text
                        Text('My Post'), // Chữ "My Post"
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserPostsPage()),
                      );
                    },
                  ),
                  // Section chọn category
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: selectedCategory == category
                                    ? Colors.blue
                                    : Colors.grey[300],
                                foregroundColor: selectedCategory == category
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              child: Text(category),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Danh sách thú cưng
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adopt Pet",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(onPressed: () {}, child: Text("View All")),
                      ],
                    ),
                  ),
                  // Pet posts list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: petPosts.length,
                    itemBuilder: (context, index) {
                      PetPost petPost = petPosts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              petPost.petName,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text('${petPost.type} | Weight: ${petPost.weight}kg'),
                            leading: petPost.imageUrl.isNotEmpty
                                ? Image.network(petPost.imageUrl)
                                : Icon(Icons.pets, size: 60),
                            trailing: Icon(
                              petPost.adopted ? Icons.check_circle : Icons.cancel,
                              color: petPost.adopted ? Colors.green : Colors.red,
                            ),
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? userId = prefs.getString('userId');
                              print("Current User ID: $userId");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PetDetailScreen(
                                    pet: {
                                      'id': petPost.id,
                                      'name': petPost.petName,
                                      'type': petPost.type,
                                      'weight': petPost.weight,
                                      'birthDate': petPost.birthDate,
                                      'description': petPost.description,
                                      'imageUrl': petPost.imageUrl,
                                      'contactPhone': petPost.contactPhone,
                                      'adopted': petPost.adopted,
                                      'posterUserId': petPost.user.id.toString(), // Sửa để lấy id đúng
                                    },currentUserId: userId ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}