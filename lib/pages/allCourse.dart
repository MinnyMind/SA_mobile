import 'package:flutter/material.dart';
class AllCourse extends StatelessWidget { //หน้า all course แก้ได้หมด ห้ามแก้ชื่อ class
  const AllCourse({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Courses"),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Text(
          "แสดงคอร์สทั้งหมดที่นี่",
          style: TextStyle(fontSize: 18),
        ),
      ),
      // ไม่ต้องเพิ่ม bottomNavigationBar ในหน้า AllCourse นี้
    );
  }
}