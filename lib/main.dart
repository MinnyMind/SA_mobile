import 'package:flutter/material.dart';
import 'package:spaceship_academy/Widgets/navbar.dart';
import 'package:spaceship_academy/pages/logIn.dart';
import 'package:spaceship_academy/pages/myLearning.dart';
import 'package:spaceship_academy/pages/playlist.dart';
import 'package:spaceship_academy/pages/playlistEdit.dart';
import 'package:spaceship_academy/pages/playlistInfo.dart';
import './pages/allCourse.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    MyLearning(),
    PlaylistEdit(),
    Playlist(),
    PlaylistInfo(),
    AllCourse(),
  ];

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor:
            Color.fromRGBO(20, 18, 24, 1),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: _selectedIndex == 5
          ? LoginScreen()
          : Scaffold(
              body: _screens[_selectedIndex],
              bottomNavigationBar: CustomNavbar(
                currentIndex: _selectedIndex,
                onTap: _onNavbarTap,
              ),
            ),
    );
  }
}
