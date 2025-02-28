import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spaceship_academy/pages/allCourse.dart';
import '../Widgets/myLearningItem.dart';
import './playlist.dart';

class MyLearning extends StatefulWidget {
  const MyLearning({super.key});

  @override
  _MyLearningState createState() => _MyLearningState();
}

class _MyLearningState extends State<MyLearning> {
  List<String> imagePaths = [];
  String imagePlaylistPaths = "";
  final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJidXVfZGV2IiwiZnVwIjoiYTU2YWE1ZGQtMzMwYS00ZGU5LWFjZTEtNDBjMTZjYzAxYzBlIiwidXNlciI6IuC4lOC4uOC4geC4lOC4uOC5i-C4oiDguK3guK3guKXguK3guLDguKPguLLguKfguKciLCJpYXQiOjE3NDAwNjM4NTIsImV4cCI6MTc0MDY2ODY1MiwidHR0X2lkIjoiVFRUMjY1In0.HUC8104Oy9dAWwFyk0kXR1xWgGUap6nMnc_D9eFGS9I";
  final String baseUrl = "http://150.95.25.61:7501/";
  Map<String, bool> selectedPlaylists = {};
  List<Map<String, dynamic>> playlists = [];

  @override
  void initState() {
    super.initState();
    fetchMyLearning();
  }

  Future<void> fetchMyLearning() async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}api/mylearning"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "temp": {"page": 1, "size": 20, "search": ""}
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> courses = data['learning']['data'];

        setState(() {
          imagePaths = courses.map((course) {
            final String imageUrl = course['cos_profile']?.toString() ?? '';

            return imageUrl.isNotEmpty && imageUrl.startsWith("http")
                ? 'assets/images/logoSA.png'
                : '$baseUrl$imageUrl';
          }).toList();
        });
      } else {
        print("Failed to load courses: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching courses: $error");
    }
  }

  Future<void> fetchCoursePlaylists(Map<String, dynamic> course) async {
    try {
      final cosId = course['cos_id'];
      final response = await http.get(
        Uri.parse("${baseUrl}api/playlistsInfoMobile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] is List && data['data'].isNotEmpty) {
        
          String? firstCourseImage =
              data['data'][0]['cos_profile']?.toString().trim();

            setState(() {
            imagePlaylistPaths = firstCourseImage ?? "";
          });
        }
      }
    } catch (e) {
      print("Failed to fetch course playlists: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logoSA.png',
          height: 70,
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Mylearningitem(
              imagePath: imagePaths.isNotEmpty ? imagePaths : [],
              menu: "All Courses",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllCourse()),
                );
              },
            ),
            Mylearningitem(
                imagePath:
                    imagePlaylistPaths.isNotEmpty ? imagePlaylistPaths : [],
                menu: "Playlists",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Playlist()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
