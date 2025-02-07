import 'package:flutter/material.dart';

class Playlist extends StatelessWidget {
  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ALL PLAYLIST',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          _buildPlaylistItem(
            'List Programming',
            'assets/Images/juanjo-jaramillo-mZnx9429i94-unsplash-1024x683.jpg', // Replace with actual image URL
          ),
          _buildPlaylistItem(
            'List Marketing',
            'assets/Images/marketing.png', // Replace with actual image URL
          ),
          _buildPlaylistItem(
            'List Math',
            'assets/Images/math.png', // Replace with actual image URL
          ),
          _buildPlaylistItem(
            'List Science',
            'assets/Images/science.png', // Replace with actual image URL
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          // Action to add a new playlist
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPlaylistItem(String title, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Action for more options
            },
          ),
        ],
      ),
    );
  }
}
