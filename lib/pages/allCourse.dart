import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spaceship_academy/Widgets/courseItem.dart';
import './myLearning.dart';

class AllCourse extends StatefulWidget {
  const AllCourse({super.key});

  @override
  _AllCourseState createState() => _AllCourseState();
}

class _AllCourseState extends State<AllCourse> {
  List<Map<String, dynamic>> allCourses = [];
  final String token = "YOUR_TOKEN_HERE"; // Replace with your actual token
  final String baseUrl = "http://localhost:7501";

  @override
  void initState() {
    super.initState();
    fetchAllCourses();
  }

  Future<void> fetchAllCourses() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/mylearning"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "temp": {"page": 1, "size": 20, "search": ""}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> courses = data['learning']['data'];

        setState(() {
          allCourses = courses
              .map((course) {
                return {
                  "name": (course['cos_title'] ?? 'Unnamed Course').trim(),
                  "description":
                      (course['username'] ?? 'No Description').trim(),
                  "image": course['cos_profile'] != null
                      ? (course['cos_profile'].toString().startsWith("http")
                          ? course['cos_profile']
                          : baseUrl + '/' + course['cos_profile'])
                      : '',
                };
              })
              .toList()
              .cast<Map<String, dynamic>>();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyLearning()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
              "ALL COURSES",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
      ),
      body: allCourses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: allCourses.length,
              itemBuilder: (context, index) {
                final item = allCourses[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CourseItem(
                    imageUrl: item["image"] ?? '',
                    courseName: item["name"] ?? 'Unnamed Course',
                    courseDescription: item["description"] ?? 'No Description',
                  ),
                );
              },
            ),
    );
  }
}
