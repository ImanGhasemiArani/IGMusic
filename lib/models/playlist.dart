import '../controllers/file_manager.dart';

class Playlist {
  late int id;
  late String name;
  late final List<int> audiosMetadataID;

  Playlist({required this.id, required this.name, List<int>? audiosMetadataID})
      : audiosMetadataID = audiosMetadataID ?? <int>[];

  Playlist.fromJSON(Map<String, dynamic> map) {
    id = map["id"] as int;
    name = map["name"] as String;
    audiosMetadataID = (map["metasID"] as List<dynamic>).cast<int>();
  }

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

  Map<String, dynamic> toJSON() {
    return {"id": id, "name": name, "metasID": audiosMetadataID};
  }
}
