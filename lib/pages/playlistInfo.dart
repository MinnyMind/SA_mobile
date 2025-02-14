import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/courseItem.dart';
import 'package:spaceship_academy/pages/playlist.dart';
import 'package:spaceship_academy/pages/playlistEdit.dart';
import 'package:spaceship_academy/widgets/navbar.dart';

class PlaylistInfo extends StatelessWidget {
  const PlaylistInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> programmingList = [
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
        "description": "Master the basics and advanced applications of C++ programming.",
        "image": "assets/images/c++.png"
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

    final List<String> playlists = ["Programming", "Marketing", "Math"];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "List Programming",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaylistEdit()));
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: programmingList.length,
        itemBuilder: (context, index) {
          final item = programmingList[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CourseItem(
              imageUrl: item["image"]!,
              courseName: item["name"]!,
              courseDescription: item["description"]!,
              onMorePressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Add to playlist",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                // const SizedBox(width: 15), 
                                const Text(
                                  "+",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                              const SizedBox(height: 10),
                              ...playlists.map((playlist) {
                                return CheckboxListTile(
                                  title: Text(
                                    playlist,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  value: false, // ค่าเริ่มต้น
                                  onChanged: (bool? value) {
                                    setState(() {});
                                  },
                                  activeColor: Colors.purpleAccent,
                                  checkColor: Colors.black,
                                  controlAffinity: ListTileControlAffinity.leading,
                                );
                              }).toList(),
                            ],
                          ),
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
}
