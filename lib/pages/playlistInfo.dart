import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/courseItem.dart';
import 'package:spaceship_academy/pages/playlistEdit.dart';
import 'package:dio/dio.dart';

class PlaylistInfo extends StatefulWidget {
  const PlaylistInfo({super.key});

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
    fetchCourses();
    fetchPlaylist();
  }

  Future<void> fetchCourses() async {
    final dio = Dio();
    // const defaultFilters = {
    //   "user_id": "a56aa5dd-330a-4de9-ace1-40c16cc01c0e",
    //   "play_id": "1190cbdd-c63b-4773-ad75-f1d0c01cdbeb"
    // };

    try {
      print("🚀 Fetching courses...");
      final response = await dio.get(
        "http://localhost:7501/api/playlistsInfoMobile",
          queryParameters: {
            "user_id": "a56aa5dd-330a-4de9-ace1-40c16cc01c0e",
            "play_id": "1190cbdd-c63b-4773-ad75-f1d0c01cdbeb",
          },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      setState(() {
        courses = response.data['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (e is DioException) {
        print("❌ Dio Error: ${e.message}");
      } else {
        print("❌ Unknown Error: $e");
      }
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchPlaylist() async {
    final dio = Dio();
    try {
      print("🚀 Fetching playlists...");
      final response = await dio.get(
        "http://localhost:7501/api/playlists",
        queryParameters: {
          "user_id": "a56aa5dd-330a-4de9-ace1-40c16cc01c0e",
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      // สมมติว่า response.data['data'] เป็น List ของ object ที่มี play_id และ play_title
      setState(() {
        playlists = List<Map<String, dynamic>>.from(response.data['data']);
        // กำหนดค่าเริ่มต้นให้ selectedPlaylists สำหรับแต่ละ playlist เป็น false
        for (var play in playlists) {
          selectedPlaylists[play['play_id']] = false;
        }
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => isLoading = false);
    }
  }

  // ฟังก์ชันสำหรับเรียก API เพิ่ม course ลง playlist
  Future<void> addCourseToPlaylist(String playId, Map<String, dynamic> course) async {
    final dio = Dio();
    try {
      // สมมติว่าคุณมีค่า user_id และ course_id อยู่แล้ว
      final userId = "a56aa5dd-330a-4de9-ace1-40c16cc01c0e";
      final cosId = course['cos_id']; // หรือชื่อ field ที่ใช้แทน course id
      final datetime = DateTime.now().toIso8601String();

      final response = await dio.post(
        "http://localhost:7501/api/addCoursePlayLists",
        queryParameters: {
          "userId": userId,
        },
        data: {
          "cosId": cosId,
          "playId": playId,
          "datetime": datetime, // ถ้าต้องส่งค่านี้ไปด้วย
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      print("✅ Course added to playlist successfully: ${response.data}");
    } catch (e) {
      print("❌ Failed to add course: $e");
    }
  }
Future<void> fetchCoursePlaylists(Map<String, dynamic> course) async {
  final dio = Dio();
  try {
    final cosId = course['cos_id'];
    final response = await dio.get(
      "http://localhost:7501/api/checkPlaylists",
      queryParameters: {"cosId": cosId},
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    if (response.data != null && response.data['data'] is List) {
      List<String> coursePlaylists = (response.data['data'] as List)
          .map((item) => item['play_title'].toString().trim()) // ใช้ play_title แทน play_id
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
  } catch (e) {
    print("❌ Failed to fetch course playlists: $e");
  }
}

Future<void> removeCourseFromPlaylist(String playId, String cosId, String userId) async {
  final dio = Dio();
  try {
    final response = await dio.delete(
      "http://localhost:7501/api/CoursePlayLists",
      queryParameters: {
          "userId": userId,
      },
      data: {"cosId": cosId, "playId": playId},
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    if (response.statusCode == 200) {
      print("✅ Removed course $cosId from playlist $playId successfully");
    } else {
      print("❌ Failed to remove course $cosId from playlist $playId");
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
                    imageUrl: course["cos_profile"] != null && course["cos_profile"].isNotEmpty
                        ? course["cos_profile"]
                        : "assets/images/littleGirl.jpg",
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

                    print("playTitle: $playTitle, selected: $isChecked"); // ตรวจสอบค่า

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
                          addCourseToPlaylist(playTitle, course);
                        }
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

