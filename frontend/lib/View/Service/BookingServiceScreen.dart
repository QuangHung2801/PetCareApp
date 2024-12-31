// import 'package:flutter/material.dart';
//
// class BookingServiceScreen extends StatefulWidget {
//   @override
//   _BookingServiceScreenState createState() => _BookingServiceScreenState();
// }
//
// class _BookingServiceScreenState extends State<BookingServiceScreen> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _petController = TextEditingController();
//
//   bool surgerySelected = false;
//   bool vaccinationSelected = false;
//   bool endoscopySelected = false;
//   bool neuteringSelected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Đặt dịch vụ'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Input Fields
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Tên khách hàng'),
//             ),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(labelText: 'Số điện thoại'),
//               keyboardType: TextInputType.phone,
//             ),
//             TextField(
//               controller: _petController,
//               decoration: InputDecoration(labelText: 'Thú cưng'),
//             ),
//             SizedBox(height: 20),
//
//             // Service selection checkboxes
//             Text(
//               'Chọn dịch vụ:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             CheckboxListTile(
//               title: Text('Phẫu thuật'),
//               value: surgerySelected,
//               onChanged: (value) {
//                 setState(() {
//                   surgerySelected = value!;
//                 });
//               },
//             ),
//             CheckboxListTile(
//               title: Text('Tiêm phòng'),
//               value: vaccinationSelected,
//               onChanged: (value) {
//                 setState(() {
//                   vaccinationSelected = value!;
//                 });
//               },
//             ),
//             CheckboxListTile(
//               title: Text('Nội soi'),
//               value: endoscopySelected,
//               onChanged: (value) {
//                 setState(() {
//                   endoscopySelected = value!;
//                 });
//               },
//             ),
//             CheckboxListTile(
//               title: Text('Thiến chó mèo'),
//               value: neuteringSelected,
//               onChanged: (value) {
//                 setState(() {
//                   neuteringSelected = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//
//             // Submit Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   _submitBooking();
//                 },
//                 child: Text('Xác nhận đặt dịch vụ'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   textStyle: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _submitBooking() {
//     String name = _nameController.text;
//     String phone = _phoneController.text;
//     String pet = _petController.text;
//
//     if (name.isEmpty || phone.isEmpty || pet.isEmpty) {
//       // Show error dialog if any field is empty
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Lỗi'),
//             content: Text('Vui lòng điền đầy đủ thông tin!'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     List<String> selectedServices = [];
//     if (surgerySelected) selectedServices.add(' Tắm chó, mèo');
//     if (vaccinationSelected) selectedServices.add('Tỉa lông');
//     if (endoscopySelected) selectedServices.add('Khách sạn thú cưng');
//     if (neuteringSelected) selectedServices.add('Cắt móng');
//
//     if (selectedServices.isEmpty) {
//       // Show error if no services are selected
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Lỗi'),
//             content: Text('Vui lòng chọn ít nhất một dịch vụ!'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     // Show confirmation dialog
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Thông tin đặt dịch vụ'),
//           content: Text(
//             'Tên: $name\nSĐT: $phone\nThú cưng: $pet\nDịch vụ đã chọn: ${selectedServices.join(', ')}',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Hủy'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Process the booking (e.g., save to database or send to server)
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('Đặt dịch vụ thành công!'),
//                 ));
//               },
//               child: Text('Đặt dịch vụ'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
