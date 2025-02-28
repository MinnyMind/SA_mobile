import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceship_academy/Widgets/playlistItem.dart';
import '../pages/playlistInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/playlistProvider.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool isLoading = true;
  final String baseUrl = "http://localhost:7501";
  final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJidXVfZGV2IiwiZnVwIjoiYTU2YWE1ZGQtMzMwYS00ZGU5LWFjZTEtNDBjMTZjYzAxYzBlIiwidXNlciI6IuC4lOC4uOC4geC4lOC4uOC5i-C4oiDguK3guK3guKXguK3guLDguKPguLLguKfguKciLCJpYXQiOjE3NDAwNjM4NTIsImV4cCI6MTc0MDY2ODY1MiwidHR0X2lkIjoiVFRUMjY1In0.HUC8104Oy9dAWwFyk0kXR1xWgGUap6nMnc_D9eFGS9I"; 

  @override
  void initState() {
    super.initState();
    fetchPlaylist();
  }

  //ดึงข้อมูล Playlist จากเซิร์ฟเวอร์
  Future<void> fetchPlaylist() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}/api/playlists"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
        playlistProvider.setPlaylists(List<Map<String, dynamic>>.from(data['data']));

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching playlists: $e");
      setState(() => isLoading = false);
    }
  }

  ///แสดง Modal `Create Playlist`
  void _showCreatePlaylistDialog() {
    TextEditingController playlistController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Create Playlist",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: playlistController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter playlist title",
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () async {
                String newPlaylistName = playlistController.text.trim();
                if (newPlaylistName.isNotEmpty) {
                  await createPlaylist(newPlaylistName, "New Playlist"); //สร้าง Playlist ใหม่
                  Navigator.pop(context); // ปิด Modal
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text("Confirm", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  //ส่งข้อมูลไปยัง API เพื่อสร้าง Playlist ใหม่
  Future<void> createPlaylist(String playlistName, String playlistDescription) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}/api/createPlaylist"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "playlistName": playlistName,
          "playlistDescription": playlistDescription,
        }),
      );

      if (response.statusCode == 200) {
        print("Playlist Created: $playlistName");
        fetchPlaylist(); //รีโหลด Playlist ใหม่
      } else {
        print("Failed to create playlist: ${response.statusCode}");
      }
    } catch (e) {
      print("Error creating playlist: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("PLAYLIST", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<PlaylistProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListView.builder(
                    itemCount: provider.playlists.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaylistInfo(
                                playId: provider.playlists[index]['play_id'].toString(),
                              ),
                            ),
                          );
                        },
                        child: Playlistitem(
                          playlistName: provider.playlists[index]['play_title'] ?? 'No Title',
                          imagePath: provider.playlists[index]['image'] ?? "assets/images/logoSA.png",
                        ),
                      );
                    },
                  ),
                );
              },
            ),

      //ปุ่ม `+` เพื่อสร้าง Playlist ใหม่
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: _showCreatePlaylistDialog,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
