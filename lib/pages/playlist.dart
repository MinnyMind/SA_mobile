import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceship_academy/Widgets/playlistItem.dart';
import '../pages/playlistInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/playlistProvider.dart'; // Add this line to import PlaylistProvider

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
  
  Future<void> fetchPlaylist() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}/api/playlists"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"},
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
      print("❌ Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(20, 18, 24, 1),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          // Action to add a new playlist
        },
        child: const Icon(Icons.add_circle_outline_outlined, color: Colors.white, size: 40),
      ),
    );
  }
}
