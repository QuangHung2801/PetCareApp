import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'add_pet_adopt_screen.dart';

// Model for Pet Adoption Post
class PetPost {
  final String petName;
  final String type;
  final double weight;
  final String birthDate;
  final String description;
  final String imageUrl;
  final bool adopted;

  PetPost({
    required this.petName,
    required this.type,
    required this.weight,
    required this.birthDate,
    required this.description,
    required this.imageUrl,
    required this.adopted,
  });

  factory PetPost.fromJson(Map<String, dynamic> json) {
    return PetPost(
      petName: json['petName'],
      type: json['type'],
      weight: json['weight'],
      birthDate: json['birthDate'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      adopted: json['adopted'],
    );
  }
}

class AdoptPetPage extends StatelessWidget {
  // Fetch the pet posts from the backend API
  Future<List<PetPost>> fetchPetPosts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/adoption/all'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');

    final request = http.Request('GET', Uri.parse('http://10.0.2.2:8888/api/adoption/all'));
    request.headers['Cookie'] = '$sessionId';  // Gửi sessionId trong header Cookie
    request.headers['Content-Type'] = 'application/json';

    final result = await request.send();
    final responseData = await result.stream.bytesToString();

    if (result.statusCode == 200) {
      List<dynamic> data = json.decode(responseData);
      return data.map((json) => PetPost.fromJson(json)).toList();
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          List<PetPost> petPosts = snapshot.data!;

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
                  // Section for posting a pet adoption post
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
                                ? Image.network(petPost.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                                : Icon(Icons.pets, size: 60),
                            trailing: Icon(
                              petPost.adopted ? Icons.check_circle : Icons.cancel,
                              color: petPost.adopted ? Colors.green : Colors.red,
                            ),
                            onTap: () {
                              // Navigate to pet details page
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
