import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/courseItem.dart';

class AllCourse extends StatefulWidget {
  //หน้า all course แก้ได้หมด ห้ามแก้ชื่อ class
  const AllCourse({super.key});

  @override
  _AllCourseState createState() => _AllCourseState();
}

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
      }
    ];

/// ✅ **เก็บค่า isSelected ไว้ข้างนอก**
  final Map<String, bool> isSelected = {
    "Programming": false,
    "Marketing": false,
    "Math": false,
  };

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Row(
          children: [
            const Spacer(),
            const Text(
              "ALL COURSES",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
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
                );
              },
            ),
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