import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_detail_screen.dart'; // Đảm bảo bạn đã có PetDetailScreen

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
    required this.adopted,
    required this.user,
    required this.contactPhone
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
      contactPhone: json['contactPhone'],
      adopted: json['adopted'],
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

class UserPostsPage extends StatefulWidget {
  @override
  _UserPostsPageState createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {

  Future<List<PetPost>> fetchUserPosts(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');

    final request = http.Request('GET', Uri.parse('http://10.0.2.2:8888/api/adoption/user/$userId'));
    request.headers['Cookie'] = '$sessionId';
    request.headers['Content-Type'] = 'application/json';

    final result = await request.send();
    final responseData = await result.stream.bytesToString();

    if (result.statusCode == 200) {
      List<dynamic> data = json.decode(responseData);
      return data.map((json) => PetPost.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Pet Posts"),
      ),
      body: FutureBuilder<List<PetPost>>(
        future: _fetchUserPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<PetPost> petPosts = snapshot.data!;

          return ListView.builder(
            itemCount: petPosts.length,
            itemBuilder: (context, index) {
              PetPost petPost = petPosts[index];
              return Card(
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
                            'adopted': petPost.adopted,
                            'contactPhone':petPost.contactPhone,
                            'posterUserId': petPost.user.id.toString(),
                          },
                          currentUserId: userId ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<PetPost>> _fetchUserPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId') ?? '';

    if (userId.isEmpty) {
      throw Exception('User ID not found.');
    }

    return await fetchUserPosts(userId);
  }
}
