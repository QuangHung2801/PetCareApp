import 'package:flutter/material.dart';

import 'add_pet_adopt_screen.dart';

class AdoptPetPage extends StatelessWidget {
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
      body: SingleChildScrollView(
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
            // Nút đăng thú cưng
            Align(
              alignment: Alignment.centerLeft, // Căn giữa theo chiều dọc và sang trái theo chiều ngang
              child: ElevatedButton.icon(
                onPressed: () {
                  // Chuyển đến trang đăng thú cưng
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostPetPage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text("Post"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Danh mục
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: Text("View All")),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView( // Thêm SingleChildScrollView để tránh tràn dọc
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryButton("Cats"),
                    CategoryButton("Dogs"),
                    CategoryButton("Birds"),
                    CategoryButton("Fish"),
                  ],
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

          ],
        ),
    ),
      ),
    );
  }
}



// Các class hỗ trợ
class CategoryButton extends StatelessWidget {
  final String label;

  CategoryButton(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(label),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final String image;
  final String name;

  PetCard({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Image.asset(image, height: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
