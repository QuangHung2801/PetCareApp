import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ungdungchamsocthucung/View/Menu/EditPetProfilePage.dart';

class PetSettingsPage extends StatelessWidget {
  final int petId;

  PetSettingsPage({required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Colors.black),
            title: Text('Chỉnh sửa thông tin thú cưng'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Truyền petId vào EditPetProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPetProfilePage(petId: petId),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Xóa thú cưng'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Thêm chức năng xóa hồ sơ thú cưng ở đây
              // Tùy chọn: Hiển thị hộp thoại xác nhận
            },
          ),
        ],
      ),
    );
  }
}
