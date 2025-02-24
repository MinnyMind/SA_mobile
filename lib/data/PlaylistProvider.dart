import 'package:flutter/material.dart';

class PlaylistProvider with ChangeNotifier {
  List<Map<String, dynamic>> _playlists = [];

  List<Map<String, dynamic>> get playlists => _playlists;

  void setPlaylists(List<Map<String, dynamic>> playlists) {
    _playlists = playlists;
    notifyListeners();
  }

  void addPlaylist(Map<String, dynamic> playlist) {
    _playlists.add(playlist);
    notifyListeners();
  }

  void removePlaylist(String playlist) {
    _playlists.remove(playlist);
    notifyListeners();
  }

  // Add this method to update a playlist
  void updatePlaylist(int index, String updatedTitle) {
    if (index >= 0 && index < _playlists.length) {
      _playlists[index]['play_title'] = updatedTitle;
      notifyListeners();
    }
  }

}
