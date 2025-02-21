import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/courseItem.dart';
import 'package:spaceship_academy/pages/playlistEdit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistInfo extends StatefulWidget {
  final String playId; // ประกาศตัวแปร playId

  const PlaylistInfo({
    Key? key, 
    required this.playId
    }) : 
    super(key: key);
    
  @override
  State<PlaylistInfo> createState() => _PlaylistInfoState();
}
class _PlaylistInfoState extends State<PlaylistInfo> {
  List courses = [];
  List<Map<String, dynamic>> playlists = []; // สมมติว่ามี play_id และ play_title
  Map<String, bool> selectedPlaylists = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("Received playId: ${widget.playId}");
    fetchCourses();
    fetchPlaylist();
    
  }

Future<void> fetchCourses() async {
  try {
    final response = await http.get(
      Uri.parse("http://localhost:7501/api/playlistsInfoMobile").replace(
        queryParameters: {
          "user_id": "a56aa5dd-330a-4de9-ace1-40c16cc01c0e",
          "play_id": widget.playId,
          // "play_id": "1190cbdd-c63b-4773-ad75-f1d0c01cdbeb",
        },
      ),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        courses = data['data'] ?? [];
        isLoading = false;
      });
    }
    print("Courses: $courses");
  } catch (e) {
    print("❌ Error: $e");
    setState(() => isLoading = false);
  }
}


Future<void> fetchPlaylist() async {
  try {
    final response = await http.get(
      Uri.parse("http://localhost:7501/api/playlists").replace(
        queryParameters: {
          "user_id": "a56aa5dd-330a-4de9-ace1-40c16cc01c0e",
        },
      ),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        playlists = List<Map<String, dynamic>>.from(data['data']);
        for (var play in playlists) {
          selectedPlaylists[play['play_id']] = false;
        }
        isLoading = false;
      });
    }
  } catch (e) {
    print("❌ Error: $e");
    setState(() => isLoading = false);
  }
}


Future<void> addCourseToPlaylist(String playId, Map<String, dynamic> course) async {
try {
  print("Adding course to playlist..."+course['cos_id']);
  print("Adding course to playlist..."+playId);
  final response = await http.post(
    Uri.parse("http://localhost:7501/api/addCoursePlayLists"),
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      "userId": "a56aa5dd-330a-4de9-ace1-40c16cc01c0e",
      "cosId": course['cos_id'],
      "playId": playId,
    }),
  );
  
  if (response.statusCode == 200) {
    print("✅ Course added to playlist successfully");
  } else {
    print("❌ Failed to add course: ${response.statusCode} ${response.body}");
  }
} catch (e) {
  print("❌ Failed to add course: $e");
}

}

Future<void> fetchCoursePlaylists(Map<String, dynamic> course) async {
  try {
    final cosId = course['cos_id'];
    final response = await http.get(
      Uri.parse("http://localhost:7501/api/checkPlaylists").replace(
        queryParameters: {"cosId": cosId},
      ),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] is List) {
        List<String> coursePlaylists = (data['data'] as List)
            .map((item) => item['play_title'].toString().trim())
            .toList();

        setState(() {
          selectedPlaylists.clear(); // ล้างค่าเก่า
          for (var play in playlists) {
            String playTitle = play['play_title'].toString().trim();
            selectedPlaylists[playTitle] = coursePlaylists.contains(playTitle);
          }
          print(selectedPlaylists);
        });
      }
    }
  } catch (e) {
    print("❌ Failed to fetch course playlists: $e");
  }
}


Future<void> removeCourseFromPlaylist(String playId, String cosId) async {
  try {
    final response = await http.delete(
      Uri.parse("http://localhost:7501/api/CoursePlayLists"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": "a56aa5dd-330a-4de9-ace1-40c16cc01c0e",
        "cosId": cosId, 
        "playId": playId}),
    );
    
    if (response.statusCode == 200) {
      print("✅ Removed course $cosId from playlist $playId successfully");
    }
  } catch (e) {
    print("❌ Error removing course from playlist: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("List Programming", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaylistEdit()));
            },
            icon: const Icon(Icons.more_vert, color: Colors.white70),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CourseItem(
                    imageUrl: (course["cos_profile"] != null && course["cos_profile"].isNotEmpty) 
                    ? course["cos_profile"] 
                    : "assets/images/logoSA.png",
                    courseName: course["cos_title"] ?? "Unknown Course",
                    courseDescription: course["cos_subtitle"] ?? "No description available",
                      onMorePressed: () async {
                        await fetchCoursePlaylists(course); // โหลดค่าก่อน
                        if (!mounted) return; // ป้องกัน error ถ้า widget ถูก dispose

                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Add to playlist",
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        ...playlists.map((playlist) {
                                          final playTitle = playlist['play_title'].trim();
                                          bool isChecked = selectedPlaylists[playTitle] ?? false;

                                          return CheckboxListTile(
                                            title: Text(
                                              playTitle,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            value: isChecked,
                                              onChanged: (bool? value) {
                                                setModalState(() {
                                                  selectedPlaylists[playTitle] = value ?? false;
                                                });

                                                if (value == true) {
                                                  // เพิ่มคอร์สเข้า playlist
                                                  addCourseToPlaylist(playlist['play_id'], course);
                                                } else {
                                                  // ลบคอร์สออกจาก playlist
                                                  removeCourseFromPlaylist(playlist['play_id'], course['cos_id']).then((_) {
                                                    Navigator.pop(context); // ปิด BottomSheet
                                                    fetchCourses(); // โหลดข้อมูลใหม่
                                                  });
                                                }
                                              },

                                            activeColor: Colors.white,
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

