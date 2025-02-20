import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spaceship_academy/pages/allCourse.dart';
import '../Widgets/myLearningItem.dart';

class MyLearning extends StatefulWidget {
  const MyLearning({super.key});

  @override
  _MyLearningState createState() => _MyLearningState();
}

class _MyLearningState extends State<MyLearning> {
  List<String> imagePaths = [];
  final String token = "YOUR_BEARER_TOKEN"; // ใช้ Token ที่ได้

  @override
  void initState() {
    super.initState();
    fetchMyLearning();
  }

  Future<void> fetchMyLearning() async {
    try {
      final response = await http.post(
        Uri.parse("http://150.95.25.61:7779/api/mylearning"),
        headers: {
          "Authorization": "Bearer $token", // ส่ง Token
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "temp": {"page": 1, "size": 100, "search": ""}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> courses = data['learning']['data'];

        // Map ข้อมูลเพื่อเก็บเฉพาะ cos_profile
        setState(() {
          imagePaths = courses.map((course) {
            return course['cos_profile']?.toString() ??
                'assets/images/Logo_SA.png';
          }).toList();
        });
      } else {
        print("Failed to load courses: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching courses: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logoSA.png',
          height: 70,
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Mylearningitem(
              imagePath: imagePaths.isNotEmpty
                  ? imagePaths
                  : ['assets/images/Logo_SA.png'],
              menu: "All Courses",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllCourse()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
