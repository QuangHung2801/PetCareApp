import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPetPage extends StatefulWidget {
  @override
  _PostPetPageState createState() => _PostPetPageState();
}

class _PostPetPageState extends State<PostPetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  Future<void> _postPet() async {
    final String apiUrl = 'http://10.0.2.2:8888/api/pets/post';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'description': _descriptionController.text,
        'contactInfo': _contactInfoController.text,
        'imageUrl': 'default_image_url' // Add if you have an image field in backend
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pet posted successfully!")),
      );
      _nameController.clear();
      _descriptionController.clear();
      _contactInfoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post pet")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Pet for Adoption"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Pet Name"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _contactInfoController,
              decoration: InputDecoration(labelText: "Contact Info"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _postPet,
              child: Text("Post"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
