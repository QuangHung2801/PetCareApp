// Trang đăng thú cưng mới
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostPetPage extends StatelessWidget {
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
              decoration: InputDecoration(labelText: "Pet Name"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Contact Info"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng thông tin thú cưng ở đây
              },
              child: Text("Post"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}