import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 10, // Ví dụ có 10 thông báo
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Notification ${index + 1}"),
              subtitle: Text("Details about notification ${index + 1}..."),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Xử lý khi nhấn vào thông báo, ví dụ mở chi tiết
              },
            ),
          );
        },
      ),
    );
  }
}
