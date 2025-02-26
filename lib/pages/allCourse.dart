import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spaceship_academy/Widgets/courseItem.dart';
<<<<<<< HEAD

class AllCourse extends StatefulWidget {
  //หน้า all course แก้ได้หมด ห้ามแก้ชื่อ class
=======
import './myLearning.dart';

class AllCourse extends StatefulWidget {
>>>>>>> develope
  const AllCourse({super.key});

  @override
  _AllCourseState createState() => _AllCourseState();
}

<<<<<<< HEAD
  class _AllCourseState extends State<AllCourse> {
  final List<Map<String, String>> allCourses = [
    {
        "name": "Python",
        "description": "For beginner python",
        "image": "assets/images/pythonlogo.png"
      },
      {
        "name": "Java",
        "description": "Develop secure and efficient applications using Java.",
        "image": "assets/images/java.png"
      },
      {
        "name": "C++",
        "description":
            "Master the basics and advanced applications of C++ programming.",
        "image": "assets/images/c++.png"
      },
      {
        "name": "Mongo DB",
        "description": "Manage NoSQL databases efficiently with MongoDB.",
        "image": "assets/images/mongodb.png"
      },
      {
        "name": "Javascript",
        "description":
            "Understand from fundamentals to building web applications.",
        "image": "assets/images/javascript.png"
=======
class _AllCourseState extends State<AllCourse> {
  List<Map<String, dynamic>> allCourses = [];
  final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJidXVfZGV2IiwiZnVwIjoiYTU2YWE1ZGQtMzMwYS00ZGU5LWFjZTEtNDBjMTZjYzAxYzBlIiwidXNlciI6IuC4lOC4uOC4geC4lOC4uOC5i-C4oiDguK3guK3guKXguK3guLDguKPguLLguKfguKciLCJpYXQiOjE3NDAwNjM4NTIsImV4cCI6MTc0MDY2ODY1MiwidHR0X2lkIjoiVFRUMjY1In0.HUC8104Oy9dAWwFyk0kXR1xWgGUap6nMnc_D9eFGS9I"; 
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
                      :  'assets/images/logoSA.png' ,
                };
              })
              .toList()
              .cast<Map<String, dynamic>>();
        });
      } else {
        print("Failed to load courses: ${response.statusCode}");
>>>>>>> develope
      }
    } catch (error) {
      print("Error fetching courses: $error");
    }
  }

<<<<<<< HEAD
/// ✅ **เก็บค่า isSelected ไว้ข้างนอก**
  final Map<String, bool> isSelected = {
    "Programming": false,
    "Marketing": false,
    "Math": false,
  };

@override
=======
  @override
>>>>>>> develope
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
<<<<<<< HEAD
          onPressed: () {},
        ),
        title: Row(
          children: [
            const Spacer(),
            const Text(
=======
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => MyLearning()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
>>>>>>> develope
              "ALL COURSES",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
      ),
<<<<<<< HEAD
      body: ListView.builder(
        itemCount: allCourses.length,
        itemBuilder: (context, index) {
          final item = allCourses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CourseItem(
              imageUrl: item["image"]!,
              courseName: item["name"]!,
              courseDescription: item["description"]!,
              onMorePressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1C1B1F),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 🔹 Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Add to playlist...",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    onPressed: () {
                                      // เพิ่มคอร์สใหม่
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // 🔹 List ของ Playlist
                              _buildCourseDetail("Programming", setState),
                              _buildCourseDetail("Marketing", setState),
                              _buildCourseDetail("Math", setState),
                            ],
                          ),
                        );
                      },
                    );
                  },
=======
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
                    imageUrl: item["image"] ?? 'assets/images/logoSA.png',
                    courseName: item["name"] ?? 'Unnamed Course',
                    courseDescription: item["description"] ?? 'No Description',
                  ),
>>>>>>> develope
                );
              },
            ),
    );
  }

 /// 🔹 ฟังก์ชันสร้างแถวแต่ละอัน
  Widget _buildCourseDetail(String title, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A292D), // สีเทาเข้มของแถบรายการ
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                (isSelected[title] ?? false) ? Icons.check_circle : Icons.add_circle_outline,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  isSelected[title] = !(isSelected[title] ?? false);
                });
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}