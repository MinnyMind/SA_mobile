import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistEdit extends StatefulWidget {
  const PlaylistEdit({super.key});

  @override
  _PlaylistEditState createState() => _PlaylistEditState();
}

class _PlaylistEditState extends State<PlaylistEdit> {
  final TextEditingController _titleController = TextEditingController();
  List<Map<String, dynamic>> _playlistItems = [];
  List<String> playlists = [];
  String selectedPlaylistId = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaylist();
    fetchPlaylistItems();
  }

  Future<void> fetchPlaylist() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://localhost:7501/api/playlists?user_id=a56aa5dd-330a-4de9-ace1-40c16cc01c0e"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data['data'].isNotEmpty) {
            playlists = List<String>.from(
                data['data'].map((item) => item['play_title'] as String));
            selectedPlaylistId = data['data'][0]['play_id'];
            _titleController.text = playlists[0];
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
        Uri.parse(
            "http://localhost:7501/api/playlistsInfoMobile?user_id=a56aa5dd-330a-4de9-ace1-40c16cc01c0e&play_id=9c51cd12-fa8d-45ca-8388-4672ed9099f6"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _playlistItems = List<Map<String, dynamic>>.from(data['data']);
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
    if (_titleController.text.isEmpty || selectedPlaylistId.isEmpty) {
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse("http://localhost:7501/api/playlists"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "playlistId": selectedPlaylistId,
          "playlistName": _titleController.text,
          "playlistDescription": ""
        }),
      );

      final data = jsonDecode(response.body);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving playlist")),
      );
    }
  }

  Future<void> removeCourseFromPlaylist(
      String playId, String cosId, String userId) async {
    try {
      if (playId.isEmpty || cosId.isEmpty || userId.isEmpty) {
        return;
      }

      final response = await http.delete(
        Uri.parse("http://localhost:7501/api/CoursePlayListsEdit"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'userId': userId,
          'cosId': cosId,
          'playId': playId,
        }),
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
              width: 250, // กำหนดความกว้างของช่อง input
              padding:
                  EdgeInsets.only(right: 10), // เพิ่มช่องว่างด้านขวาเล็กน้อย
              child: TextField(
                controller: _titleController,
                textAlign: TextAlign.center, // จัดข้อความให้ตรงกลางในแนวนอน
                // textAlignVertical:TextAlignVertical.center, // จัดข้อความให้ตรงกลางในแนวตั้ง
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 12), // ปรับช่องว่างด้านในให้พอดีกับกรอบ
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
                maxLines: 1, // แสดงแค่ 1 บรรทัด
                textInputAction:
                    TextInputAction.done, // เมื่อกด 'done' บนคีย์บอร์ด
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                                  "https://via.placeholder.com/60",
                              item["cos_id"] ?? "", // ส่ง cos_id ไปด้วย
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
      String name, String description, String imageUrl, String courseId) {
    String fullImageUrl = imageUrl.startsWith("http")
        ? imageUrl
        : "http://localhost:7501/$imageUrl";

    return ListTile(
      leading: Image.network(
        fullImageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            "https://via.placeholder.com/60", // ใช้รูป Default ถ้าโหลดไม่ได้
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          );
        },
      ),
      title: Text(name, style: TextStyle(color: Colors.white)),
      subtitle: Text(description, style: TextStyle(color: Colors.white70)),
      trailing: IconButton(
        onPressed: () => removeCourseFromPlaylist(selectedPlaylistId, courseId,
            "a56aa5dd-330a-4de9-ace1-40c16cc01c0e"),
        icon: Icon(Icons.delete, color: Colors.white),
      ),
    );
  }
}
