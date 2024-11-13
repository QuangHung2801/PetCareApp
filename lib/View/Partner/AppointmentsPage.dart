import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Chờ xác nhận"),
            Tab(text: "Đã xác nhận"),
            Tab(text: "Đã hoàn thành"),
            Tab(text: "Đã huỷ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList("Chờ xác nhận"),
          _buildAppointmentList("Đã xác nhận"),
          _buildAppointmentList("Đã hoàn thành"),
          _buildAppointmentList("Đã huỷ"),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(String status) {
    // Replace with actual data fetching based on `status`
    List<String> appointments = [
      "$status Appointment 1",
      "$status Appointment 2",
      "$status Appointment 3",
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(appointments[index]),
            subtitle: Text("Details of the appointment..."),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to appointment details page
            },
          ),
        );
      },
    );
  }
}
