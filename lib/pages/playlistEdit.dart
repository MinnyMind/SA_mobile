import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:spaceship_academy/data/playlistProvider.dart';

class PlaylistEdit extends StatefulWidget {
  final String playId; // Add this field to accept playId

  const PlaylistEdit(
      {super.key, required this.playId}); // Add playId to constructor

  @override
  _PlaylistEditState createState() => _PlaylistEditState();
}

class _PlaylistEditState extends State<PlaylistEdit> {
  final TextEditingController _titleController = TextEditingController();
  List<Map<String, dynamic>> _playlistItems = [];
  List<Map<String, dynamic>> playlists = [];
  String selectedPlaylistId = "";
  bool isLoading = true;
  // final String baseUrl = "http://localhost:7501";
  final String baseUrl = "http://150.95.25.61:7501";
  final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJidXVfZGV2IiwiZnVwIjoiYTU2YWE1ZGQtMzMwYS00ZGU5LWFjZTEtNDBjMTZjYzAxYzBlIiwidXNlciI6IuC4lOC4uOC4geC4lOC4uOC5i-C4oiDguK3guK3guKXguK3guLDguKPguLLguKfguKciLCJpYXQiOjE3NDAwNjM4NTIsImV4cCI6MTc0MDY2ODY1MiwidHR0X2lkIjoiVFRUMjY1In0.HUC8104Oy9dAWwFyk0kXR1xWgGUap6nMnc_D9eFGS9I";
  List<String> imagePaths = [];
  List courses = [];

  @override
  void initState() {
    super.initState();
    fetchPlaylist();
    fetchPlaylistItems();
  }

  Future<void> fetchPlaylist() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}/api/playlists").replace(
          queryParameters: {
            "play_id": widget.playId,
          },
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data['data'].isNotEmpty) {
            playlists =
                List<Map<String, dynamic>>.from(data['data'].map((item) {
              return {
                'play_id': item['play_id'],
                'play_title': item['play_title'],
              };
            }));

            // Select the playlist based on the passed play_id
            selectedPlaylistId =
                widget.playId; // Get it from the widget parameter
            // Update the title controller text to match the selected playlist's title
            _titleController.text = playlists.firstWhere((playlist) =>
                playlist['play_id'].toString() ==
                selectedPlaylistId)['play_title'];
          }
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load playlists");
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchPlaylistItems() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}/api/playlistsInfoMobile").replace(
          queryParameters: {
            "play_id": widget.playId,
          },
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        courses = data['data'] ?? [];
        setState(() {

          _playlistItems = List<Map<String, dynamic>>.from(data['data']);

            imagePaths = courses.map((course) {
            final String imageUrl = course['cos_profile']?.toString() ?? '';
            
            return imageUrl.isNotEmpty && imageUrl.startsWith("http")
                ? 'assets/images/logoSA.png'
                : 'http://150.95.25.61:7501/' + imageUrl;
          }).toList();

          isLoading = false;
        });
      } else {
        throw Exception("Failed to load playlist items");
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> editPlaylist() async {
  if (_titleController.text.isEmpty || selectedPlaylistId.isEmpty) return;

  try {
    final response = await http.patch(
      Uri.parse("${baseUrl}/api/playlists"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "playlistId": selectedPlaylistId,
        "playlistName": _titleController.text,
        "playlistDescription": "" // หรือส่งข้อมูล description ที่ต้องการ
      }),
    );

    if (response.statusCode == 200) {
      // ใช้ provider เพื่ออัปเดต playlist
      final provider = Provider.of<PlaylistProvider>(context, listen: false);
      int index = provider.playlists.indexWhere(
          (playlist) => playlist['play_id'] == selectedPlaylistId);
      if (index != -1) {
        provider.updatePlaylist(
            index, _titleController.text); // ส่งชื่อ playlist ที่แก้ไข
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Playlist updated successfully!")),
      );

      // ไปหน้าก่อนหน้าและให้ข้อมูลถูกอัปเดต
      Navigator.pop(context);
    } else {
      throw Exception("Failed to update playlist");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving playlist: $e")),
    );
  }
}


  Future<void> removeCourseFromPlaylist(String playId, String cosId) async {
    try {
      if (playId.isEmpty || cosId.isEmpty) {
        return;
      }
      final response = await http.delete(
        Uri.parse("${baseUrl}/api/CoursePlayListsEdit").replace(
          queryParameters: {
            'cosId': cosId,
            'playId': playId,
          },
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          _playlistItems.removeWhere((item) => item["cos_id"] == cosId);
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 250, // Keep the width of the input field
                padding: EdgeInsets.only(right: 10), // Small space on the right
                child: TextField(
                  controller: _titleController,
                  textAlign:
                      TextAlign.center, // Align text horizontally at the center
                  textAlignVertical: TextAlignVertical
                      .center, // Align text vertically at the center
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, letterSpacing: -1.5),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal:
                            8), // Adjust padding for consistent appearance
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(20, 18, 24, 1),
                  ),
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                ),
              )
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )),
      backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _playlistItems.isEmpty
                      ? Center(
                          child: Text("No Courses Found",
                              style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: _playlistItems.length,
                          itemBuilder: (context, index) {
                            final item = _playlistItems[index];
                            return _buildListItem(
                              item["cos_title"] ?? "Unknown",
                              item["cos_subtitle"] ??
                                  "No description available",
                              item["cos_profile"] ??
                                  "assets/images/littleGirl.jpg",
                              item["cos_id"] ?? "",
                              index,
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40, // Adjusted the height to 60 for better fit
                    child: ElevatedButton(
                      onPressed: editPlaylist,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
                        side: BorderSide(color: Colors.grey),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

Widget _buildListItem(
    String name, String description, String imageUrl, String courseId, int index) {
  print(imagePaths);
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            (imagePaths.isNotEmpty && imagePaths.length > index && imagePaths[index].isNotEmpty)
                ? imagePaths[index]
                : "$baseUrl/assets/images/logoSA.png",  // Use default image if path is empty
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/littleGirl.jpg", // Use fallback image if there's an error
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => removeCourseFromPlaylist(selectedPlaylistId, courseId),
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
