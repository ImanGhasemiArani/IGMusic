import '../controllers/file_manager.dart';

class Playlist {
  int id;
  String name;
  final List<int> audiosMetadataID;

  Playlist({required this.id, required this.name, List<int>? audiosMetadataID})
      : audiosMetadataID = audiosMetadataID ?? <int>[];

  void addAudioMetadataID(int id) {
    audiosMetadataID.add(id);
    updatePlaylistToDevice(playlist: this);
  }

  void removeAudioMetadataID(int id) {
    audiosMetadataID.remove(id);
    updatePlaylistToDevice(playlist: this);
  }

  void changePlaylistName(String newName) {
    name = newName;
    updatePlaylistToDevice(playlist: this);
  }
}
