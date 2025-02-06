import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0 || index == 1 || index == 2 || index == 3 || index == 4) {
          onTap(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromRGBO(74, 68, 88, 1), 
      selectedItemColor: Colors.white, 
      unselectedItemColor: Colors.grey, 
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          label: "Courses",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play),
          label: "Playlist",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
