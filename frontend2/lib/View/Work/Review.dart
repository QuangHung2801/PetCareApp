import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  final int appointmentId;

  const ReviewScreen({Key? key, required this.appointmentId}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double rating = 0.0;
  String comment = '';
  bool isSubmitting = false;
  bool hasReviewed = false;

  @override
  void initState() {
    super.initState();
    checkIfReviewed();
  }

  Future<void> checkIfReviewed() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('JSESSIONID');

      if (sessionId == null) {
        throw Exception("Vui lòng đăng nhập lại.");
      }

      final url = Uri.parse('http://10.0.2.2:8888/api/appointments/check-review/${widget.appointmentId}');
      final response = await http.get(
        url,
        headers: {'Cookie': 'JSESSIONID=$sessionId'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          hasReviewed = data['hasReviewed'];
        });
      } else {
        throw Exception('Không thể kiểm tra trạng thái đánh giá.');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> submitReview() async {
    if (hasReviewed) return; // Ngừng nếu đã đánh giá rồi

    setState(() {
      isSubmitting = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('JSESSIONID');
      String? userId = prefs.getString('userId');

      if (sessionId == null || userId == null) {
        throw Exception("Session ID or user ID not found. Please log in again.");
      }

      int intRating = rating.toInt(); // Làm tròn xuống nếu cần

      final url = Uri.parse(
        'http://10.0.2.2:8888/api/appointments/review/${widget.appointmentId}'
            '?rating=$intRating&comment=${Uri.encodeComponent(comment)}&userId=$userId',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );

      if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasReviewed_${widget.appointmentId}', true); // Lưu trạng thái đã đánh giá

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to submit review: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá dịch vụ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasReviewed)
              const Text(
                'Bạn đã gửi đánh giá trước đó. Cảm ơn bạn!',
                style: TextStyle(fontSize: 16, color: Colors.green),
              )
            else ...[
              const Text('Đánh giá:', style: TextStyle(fontSize: 16)),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Bình luận:', style: TextStyle(fontSize: 16)),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập bình luận của bạn...',
                ),
                onChanged: (value) {
                  setState(() {
                    comment = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: hasReviewed ? null : submitReview, // Disable nếu đã đánh giá
                child: const Text('Gửi đánh giá'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
