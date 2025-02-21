import 'package:go_router/go_router.dart';
import 'package:spaceship_academy/pages/logIn.dart';
import 'package:spaceship_academy/pages/myLearning.dart';
import 'package:spaceship_academy/pages/playlist.dart';
import 'package:spaceship_academy/pages/playlistInfo.dart';
import 'package:spaceship_academy/pages/playlistEdit.dart';
import 'package:spaceship_academy/pages/allCourse.dart';


final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/myLearning',
      builder: (context, state) => MyLearning(),
    ),
    GoRoute(
      path: '/playlist',
      builder: (context, state) => Playlist(),
    ),
    // GoRoute(
    //   path: '/playlistInfo',
    //   builder: (context, state) => PlaylistInfo(),
    // ),
    GoRoute(
      path: '/playlistEdit',
      builder: (context, state) => PlaylistEdit(),
     ),
     GoRoute(
      path: '/allCourse',
      builder: (context, state) => AllCourse(),
      )

  ],
);
