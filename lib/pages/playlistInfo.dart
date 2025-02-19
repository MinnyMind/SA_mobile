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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
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


final List<String> playlists = ["Programming", "Marketing", "Math"];
  @override
  Widget build(BuildContext context) {
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const PlaylistEdit()));
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final item = courses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CourseItem(
                    imageUrl: item["cos_profile"] != null && item["cos_profile"].isNotEmpty
                      ? item["cos_profile"]
                      : "assets/images/littleGirl.jpg",
                    courseName: item["cos_title"] ?? "Unknown Course",
                    courseDescription: item["cos_subtitle"] ?? "No description available",
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
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            "+",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
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
