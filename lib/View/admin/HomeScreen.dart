import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pendingPartners = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingPartners();
  }

  Future<void> _fetchPendingPartners() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8888/api/partner/pending'));

    if (response.statusCode == 200) {
      setState(() {
        pendingPartners = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load pending partners');
    }
  }

  Future<void> _approvePartner(int id) async {
    final response = await http.put(Uri.parse('http://10.0.2.2:8888/api/partner/approve/$id'));

    if (response.statusCode == 200) {
      _fetchPendingPartners(); // Reload the list after approval
    } else {
      throw Exception('Failed to approve partner');
    }
  }

  Future<void> _deletePartner(int id) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8888/api/partner/delete/$id'));

    if (response.statusCode == 200) {
      _fetchPendingPartners(); // Reload the list after deletion
    } else {
      print('Delete response: ${response.statusCode}');
      throw Exception('Failed to delete partner');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Đối Tác Chờ Duyệt'),
      ),
      body: ListView.builder(
        itemCount: pendingPartners.length,
        itemBuilder: (context, index) {
          final partner = pendingPartners[index];
          return ListTile(
            title: Text(partner['businessName']),
            subtitle: Text(partner['address']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _approvePartner(partner['id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePartner(partner['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
