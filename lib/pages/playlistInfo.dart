import 'package:flutter/material.dart';

class PlaylistInfo extends StatelessWidget {
  const PlaylistInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> programmingList = [
      {
        "name": "Python",
        "description": "For beginner python",
        "image": "assets/images/python.png"
      },
      {
        "name": "Java",
        "description": "Develop secure and efficient applications using Java.",
        "image": "assets/images/java.png"
      },
      {
        "name": "C++",
        "description": "Master the basics and advanced applications of C++ programming.",
        "image": "assets/images/cpp.png"
      },
      {
        "name": "Mongo DB",
        "description": "Manage NoSQL databases efficiently with MongoDB.",
        "image": "assets/images/mongodb.png"
      },
      {
        "name": "Javascript",
        "description": "Understand from fundamentals to building web applications.",
        "image": "assets/images/javascript.png"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("List Programming"),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1), // ให้ตรงกับ theme
      ),
      body: ListView.builder(
        itemCount: programmingList.length,
        itemBuilder: (context, index) {
          final item = programmingList[index];
          return Card(
            color: Colors.black26, // ให้เข้ากับ theme ของแอป
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              // leading: Image.asset(
              //   item["image"]!,
              //   width: 50,
              //   height: 50,
              //   fit: BoxFit.cover,
              // ),
              title: Text(
                item["name"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // ให้ข้อความเป็นสีขาว
                ),
              ),
              subtitle: Text(
                item["description"]!,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.more_vert, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
