import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/playlistItem.dart';
import '../pages/playlistInfo.dart';
import 'package:spaceship_academy/pages/myLearning.dart';

class Playlist extends StatelessWidget {
  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> playlists = [
      {
        'name': 'List Programming',
        'image':
            'assets/Images/juanjo-jaramillo-mZnx9429i94-unsplash-1024x683.jpg'
      },
      {'name': 'List Marketing', 'image': 'assets/Images/marketing.png'},
      {'name': 'List Math', 'image': 'assets/Images/math.png'},
      {'name': 'List Science', 'image': 'assets/Images/science.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(20, 18, 24, 1),
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => MyLearning()),
              );
            }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
              "ALL PLAYLISTS",
              style: TextStyle(color: Colors.white,
              fontSize: 18),
              
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // เมื่อกดแล้วไปหน้า PlaylistInfo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaylistInfo()),
                );
              },
              child: Playlistitem(
                playlistName: playlists[index]['name']!,
                imagePath: playlists[index]['image']!,
              ),
            );
          },
        ),
      ),
        floatingActionButton: IconButton(
    icon: const Icon(Icons.add_circle_outline_outlined, color: Colors.white,size: 40,),
    onPressed: () {
      // Action to add a new playlist
    },
  ),
);
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.transparent,
      //   onPressed: () {
      //     // Action to add a new playlist
      //   },
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    
  }
}
