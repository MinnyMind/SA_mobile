import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/courseItem.dart';


class PlaylistInfo extends StatelessWidget { //หน้า playlistInfo แก้ได้หมดยกเว้นชื่อ class

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

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {},
          ),
          title: const Text(
            "List Programming",
            style: TextStyle(color: Colors.white,),
            
          ),
          // centerTitle: true, // จัดกึ่งกลาง title
          backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
          actions: [
            IconButton(
              onPressed: () {},
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
          final GlobalKey key = GlobalKey(); // สร้าง key สำหรับแต่ละ item

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CourseItem(
              key: key,
              imageUrl: item["image"]!,
              courseName: item["name"]!,
              courseDescription: item["description"]!,
              onMorePressed: () {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset offset = renderBox.localToGlobal(Offset.zero);

                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx + renderBox.size.width - 40, // ตำแหน่งชิดขวา
                    offset.dy + renderBox.size.height / 2, // กึ่งกลางไอเท็ม
                    offset.dx + renderBox.size.width,
                    offset.dy + renderBox.size.height,
                  ),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.playlist_add),
                        title: const Text("Add to playlist..."),
                        onTap: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.remove_circle),
                        title: const Text("Remove from ..."),
                        onTap: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.archive),
                        title: const Text("Archived Course"),
                        onTap: () {},
                      ),
                    ),
                  ],
                );
              },

            ),
          );
        },
      ),
    );
  }
}
