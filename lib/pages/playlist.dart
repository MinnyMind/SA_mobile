import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/playlistItem.dart';
import '../pages/playlistInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './myLearning.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List<Map<String, dynamic>> playlists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaylist();
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
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(20, 18, 24, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
             Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => MyLearning()),
            );
          },
        ),
        title:
Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
              "PLAYLIST",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print(playlists[index]['play_id']);
                      // ส่ง play_id ไปยังหน้า PlaylistInfo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaylistInfo(playId: playlists[index]['play_id']),
                        ),
                      );
                    },
                    child: Playlistitem(
                      playlistName:
                          playlists[index]['play_title'] ?? 'No Title',
                      imagePath: (playlists[index]['image'] != null &&
                              playlists[index]['image'].isNotEmpty)
                          ? playlists[index]['image']
                          : "assets/images/logoSA.png",
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          // Action to add a new playlist
        },
        child: const Icon(Icons.add_circle_outline_outlined,
        color: Colors.white,
        size: 40,
    ),
      ),
    );
  }
}
