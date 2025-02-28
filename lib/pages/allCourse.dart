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
  final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJidXVfZGV2IiwiZnVwIjoiYTU2YWE1ZGQtMzMwYS00ZGU5LWFjZTEtNDBjMTZjYzAxYzBlIiwidXNlciI6IuC4lOC4uOC4geC4lOC4uOC5i-C4oiDguK3guK3guKXguK3guLDguKPguLLguKfguKciLCJpYXQiOjE3NDAwNjM4NTIsImV4cCI6MTc0MDY2ODY1MiwidHR0X2lkIjoiVFRUMjY1In0.HUC8104Oy9dAWwFyk0kXR1xWgGUap6nMnc_D9eFGS9I"; 
  final String baseUrl = "http://localhost:7501";
    List<String> imagePaths = [];

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
      }
    } catch (error) {
      print("Error fetching courses: $error");
    }
  }

/// ✅ **เก็บค่า isSelected ไว้ข้างนอก**
  final Map<String, bool> isSelected = {
    "Programming": false,
    "Marketing": false,
    "Math": false,
  };

@override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                    // imageUrl: item["image"] ?? 'assets/images/logoSA.png',
                    imagePath: imagePaths.isNotEmpty ? imagePaths : [],
                    courseName: item["name"] ?? 'Unnamed Course',
                    courseDescription: item["description"] ?? 'No Description',
                    onMorePressed: () => _showAddToPlaylistBottomSheet(context),
                  ),
                );
              },
            ),
    );
  }

 /// 🔹 **ฟังก์ชันแสดง Bottom Sheet**
  void _showAddToPlaylistBottomSheet(BuildContext context) {
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
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                        onPressed: () => _showCreatePlaylistDialog(context), // 🎯 เพิ่ม Popup เมื่อกด
                          // เพิ่มPlaylistใหม่
                      
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
  }

  /// 🔹 ฟังก์ชันสร้างแถวแต่ละอัน
  Widget _buildCourseDetail(String title, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A292D),
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

void _showCreatePlaylistDialog(BuildContext context) {
  TextEditingController playlistController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF1C1B1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟢 หัวข้อ "Create Playlist" + เส้นแบ่ง
              const Text(
                "Create Playlist",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Divider(color: Colors.white54, thickness: 1), // ✅ เส้นแบ่ง

              // 🟢 ช่องกรอกชื่อ Playlist
              const SizedBox(height: 10),
              TextField(
                controller: playlistController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter playlist title",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF2A292D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey, // ✅ เส้นขอบสีเทาอ่อน
                      width: 1, // ✅ ความหนาของเส้นขอบ
                    ),
                  ),
                ),
              ),

              // 🟢 ปุ่ม Cancel & Confirm (ขนาดหดลง + จัดตรงกลาง)
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // ✅ จัดปุ่มตรงกลาง
                children: [
                  SizedBox(
                    width: 100, // ✅ กำหนดความกว้างปุ่ม Cancel
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.2), // ✅ พื้นหลังสีเทาอ่อน
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18), // ✅ ขอบโค้ง
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12), // ✅ ปรับขนาดปุ่ม
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 14), // ✅ ตัวอักษรสีดำ
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // ✅ ระยะห่างระหว่างปุ่ม
                  SizedBox(
                    width: 100, // ✅ กำหนดความกว้างปุ่ม Confirm
                    child: ElevatedButton(
                      onPressed: () {
                        String newPlaylist = playlistController.text.trim();
                        if (newPlaylist.isNotEmpty) {
                          print("🎵 New Playlist Created: $newPlaylist");
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // ✅ พื้นหลังสีขาว
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18), // ✅ ขอบโค้ง
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12), // ✅ ปรับขนาดปุ่ม
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14), // ✅ ตัวอักษรสีดำ
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}