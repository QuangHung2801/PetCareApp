import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransportScreen extends StatefulWidget {
  @override
  _TransportScreenState createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  bool isSelectedNoiThanh = false;
  bool isSelectedLienTinh = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vận Chuyển Thú Cưng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row for two icons (Nội thành, Liên tỉnh)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Nội thành
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelectedNoiThanh = true;
                      isSelectedLienTinh = false; // Bỏ chọn Liên tỉnh
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: isSelectedNoiThanh ? Colors.orange : Colors.transparent,
                        child: Icon(Icons.location_on, size: 50),
                      ),
                      SizedBox(height: 8),
                      Text('Nội thành'),
                    ],
                  ),
                ),

                // Liên tỉnh
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelectedLienTinh = true;
                      isSelectedNoiThanh = false; // Bỏ chọn Nội thành
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: isSelectedLienTinh ? Colors.orange : Colors.transparent,
                        child: Icon(Icons.local_shipping, size: 50),
                      ),
                      SizedBox(height: 8),
                      Text('Liên tỉnh'),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Title "Đơn vị vận chuyển"
            Text(
              'Đơn vị vận chuyển',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.black),

            SizedBox(height: 10),

            // Delivery options (list of cards)
            Expanded(
              child: ListView(
                children: [
                  buildDeliveryCard('Vnpress'),
                  buildDeliveryCard('Vnpress'),
                  buildDeliveryCard('Vnpress'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a delivery card
  Widget buildDeliveryCard(String title) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 30,
        ),
        title: Text(title, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
