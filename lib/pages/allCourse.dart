import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/courseItem.dart';
import './myLearning.dart';

class AllCourse extends StatelessWidget {
  const AllCourse({super.key});

  @override
  Widget build(BuildContext context) {
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
      }
    ];

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
          children: [
            const Spacer(), // เพิ่มช่องว่าง
            const Text(
              "ALL COURSES",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1), // ให้ตรงกับ theme
      ),
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
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => MyLearning()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
