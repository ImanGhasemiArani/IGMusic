import 'dart:typed_data';

class SongMetadata {
  late final int id;
  late final String data;
  late final String title;
  late final String artist;
  late final String album;
  late final Uint8List? artwork;

  SongMetadata({
    required this.id,
    required this.data,
    required this.title,
    required String? artist,
    required String? album,
    required Uint8List? artwork,
  })  : artist = artist ?? "Unknown",
        album = album ?? "Unknown",
        artwork = ((artwork != null && artwork.isNotEmpty) ? artwork : null);

  SongMetadata.defaultValue() {
    id = 0;
    data = "";
    title = "Unknown";
    artist = "Unknown";
    album = "Unknown";
    artwork = null;
  }
}
