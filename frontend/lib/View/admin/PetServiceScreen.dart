import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PetService {
  final int id;
  final String name;

  PetService({required this.id, required this.name});

  factory PetService.fromJson(Map<String, dynamic> json) {
    return PetService(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class PetServiceScreen extends StatefulWidget {
  @override
  _PetServiceScreenState createState() => _PetServiceScreenState();
}

class _PetServiceScreenState extends State<PetServiceScreen> {
  List<PetService> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  // Hàm lấy danh sách dịch vụ từ API
  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/services/all'));

    if (response.statusCode == 200) {
      final List<dynamic> serviceList = json.decode(response.body);
      setState(() {
        services = serviceList.map((json) => PetService.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load services');
    }
  }

  // Hàm thêm dịch vụ
  Future<void> addService(String name) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8888/api/services/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 201) {
      fetchServices();
      Navigator.of(context).pop(); // Đóng màn hình thêm dịch vụ
    } else {
      throw Exception('Failed to add service');
    }
  }

  // Hàm xóa dịch vụ
  Future<void> deleteService(int id) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8888/api/services/delete/$id'));

    if (response.statusCode == 204) {
      fetchServices();
    } else {
      throw Exception('Failed to delete service');
    }
  }

  // Hàm sửa dịch vụ
  Future<void> updateService(int id, String name) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8888/api/services/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 200) {
      fetchServices();
      Navigator.of(context).pop(); // Đóng màn hình sửa dịch vụ
    } else {
      throw Exception('Failed to update service');
    }
  }

  // Hàm mở màn hình thêm dịch vụ
  void _openAddServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String serviceName = '';
        return AlertDialog(
          title: Text('Add New Service'),
          content: TextField(
            onChanged: (value) {
              serviceName = value;
            },
            decoration: InputDecoration(hintText: 'Enter service name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                addService(serviceName);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Hàm mở màn hình sửa dịch vụ
  void _openEditServiceDialog(int id, String currentName) {
    TextEditingController controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Service'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new service name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateService(id, controller.text);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pet Services')),
      body: Column(
        children: [
          // Hiển thị danh sách dịch vụ
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ListTile(
                  title: Text(service.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _openEditServiceDialog(service.id, service.name);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteService(service.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Nút thêm dịch vụ
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddServiceDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
