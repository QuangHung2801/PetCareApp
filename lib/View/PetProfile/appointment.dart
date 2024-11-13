// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AppointmentReminderPage extends StatefulWidget {
//   @override
//   _AppointmentReminderPageState createState() => _AppointmentReminderPageState();
// }
//
// class _AppointmentReminderPageState extends State<AppointmentReminderPage> {
//   // Keep the type of appointments as List<Map<String, String>>
//   List<Map<String, String>> appointments = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAppointments();
//   }
//
//   // Function to fetch appointments from the backend
//   Future<void> _fetchAppointments() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? sessionId = prefs.getString('JSESSIONID');
//
//       final response = await http.get(
//         Uri.parse('http://10.0.2.2:8888/api/admin/appointments/confirmed'),
//         headers: {
//           'Cookie': '$sessionId', // Replace with actual session ID
//         },
//       );
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//
//         setState(() {
//           // Ensure that the values are converted to String
//           appointments = data
//               .map((appointment) => {
//             "petName": appointment['petName']?.toString() ?? '',
//             "category": appointment['category']?.toString() ?? '',
//             "date": appointment['date']?.toString() ?? '',
//             "time": appointment['time']?.toString() ?? '',
//             "reason": appointment['reason']?.toString() ?? '',
//           })
//               .toList();
//         });
//
//         // Show a success SnackBar to notify the user
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Cuộc hẹn đã được tải thành công!')),
//         );
//       } else {
//         // Log the error if the response status code is not 200
//         print('Failed to load appointments. Status code: ${response.statusCode}');
//         throw Exception('Failed to load appointments');
//       }
//     } catch (error) {
//       // Log any errors that occur during the HTTP request or data processing
//       print('Error occurred while fetching appointments: $error');
//
//       // Show an error SnackBar to notify the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi khi tải cuộc hẹn. Vui lòng thử lại!')),
//       );
//
//       throw Exception('Error occurred while fetching appointments: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lịch nhắc hẹn khám bệnh'),
//         backgroundColor: Colors.orange,
//       ),
//       body: appointments.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: appointments.length,
//         itemBuilder: (context, index) {
//           final appointment = appointments[index];
//
//           return Card(
//             margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Thú cưng: ${appointment['petName']}",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text("Loại thú cưng: ${appointment['category']}"),
//                   Text("Ngày hẹn: ${appointment['date']}"),
//                   Text("Giờ hẹn: ${appointment['time']}"),
//                   Text("Lý do: ${appointment['reason']}"),
//                   SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle confirmation
//                       },
//                       child: Text("Xác nhận"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
