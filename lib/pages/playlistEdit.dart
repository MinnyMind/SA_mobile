import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/navbar.dart';

class PlaylistEdit extends StatefulWidget {
  const PlaylistEdit({super.key});

  @override
  _PlaylistEditState createState() => _PlaylistEditState();
}

class _PlaylistEditState extends State<PlaylistEdit> {
  int _currentIndex = 3;
  TextEditingController _titleController =
      TextEditingController(text: "List Programming");

  // 🔹 รายการ Playlist ที่สามารถลบได้
  List<Map<String, String>> _playlistItems = [
    {
      "name": "Python",
      "description": "For beginner python",
      "image": "assets/Images/pythonlogo.png"
    },
    {
      "name": "Java",
      "description": "Develop secure and efficient applications using Java.",
      "image": "assets/Images/java.png"
    },
    {
      "name": "C++",
      "description":
          "Master the basics and advanced applications of C++ programming.",
      "image": "assets/Images/c++.png"
    },
    {
      "name": "Mongo DB",
      "description": "Manage NoSQL databases efficiently with MongoDB.",
      "image": "assets/Images/mongodb.png"
    },
    {
      "name": "Javascript",
      "description":
          "Understand from fundamentals to building web applications.",
      "image": "assets/Images/javascript.png"
    },
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 🔹 ฟังก์ชันลบรายการเมื่อกด Icon delete
  void _removeItem(int index) {
    setState(() {
      _playlistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Spacer(),
            IntrinsicWidth(
              child: SizedBox(
                height: 30,
                child: Center(
                  child: TextField(
                    controller: _titleController,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Color(0xFF121212),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF121212),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _playlistItems.length,
              itemBuilder: (context, index) {
                final item = _playlistItems[index];
                return _buildListItem(
                  item["name"]!,
                  item["description"]!,
                  item["image"]!,
                  () => _removeItem(index),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Playlist Name: ${_titleController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF121212),
                  side: BorderSide(color: Colors.grey),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text("Save", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget สำหรับสร้าง List Item
  Widget _buildListItem(String courseName, String courseDescription,
      String imageUrl, VoidCallback onMorePressed) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFF121212),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  courseDescription,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMorePressed,
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
