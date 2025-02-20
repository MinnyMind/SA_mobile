import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:spaceship_academy/pages/allCourse.dart';
import '../Widgets/myLearningItem.dart';

class MyLearning extends StatefulWidget {
  const MyLearning({super.key});

  @override
  _MyLearningState createState() => _MyLearningState();
}

class _MyLearningState extends State<MyLearning> {
  List<String> imagePaths = []; // เก็บรายการคอร์สที่ได้จาก API
  final String token = "YOUR_FIXED_TOKEN"; // ใส่ Token คงที่

  @override
  void initState() {
    super.initState();
    fetchMyLearning();
  }

  Future<void> fetchMyLearning() async {
    try {
      Dio dio = Dio();
      final response = await dio.post(
        "https://yourapi.com/mylearning", // ใส่ URL API ที่ถูกต้อง
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // ส่ง Token ไปกับ Header
            "Content-Type": "application/json",
          },
        ),
        data: {
          "temp": {"page": 1, "size": 12, "search": ""}
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> courses = response.data['learning'];
        setState(() {
          imagePaths = courses
              .map((course) => course['cos_profile'].toString())
              .toList();
        });
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
                  : [
                      'assets/Images/default.png'
                    ], // ใช้ค่าเริ่มต้นหากไม่มีข้อมูล
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
