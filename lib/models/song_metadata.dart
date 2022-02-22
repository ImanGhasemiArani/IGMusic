import 'dart:typed_data';

class SongMetadata {
  late final int id;
  late final String data;
  late final String title;
  late final String artist;
  late final String album;
  late final Uint8List? artwork;
  late bool? isLiked;

  SongMetadata({
    required this.id,
    required this.data,
    required this.title,
    String? artist = "Unknown",
    String? album = "Unknown",
    Uint8List? artwork,
    this.isLiked = false,
  })  : artist = artist ?? "Unknown",
        album = album ?? "Unknown",
        artwork = ((artwork != null && artwork.isNotEmpty) ? artwork : null);

  SongMetadata.fromJSON(Map<String, dynamic> map) {
    id = map["id"];
    data = map["data"];
    title = map["title"];
    artist = map["artist"];
    album = map["album"];
    var art = map["artwork"] as String?;
    artwork = art != null ? Uint8List.fromList(art.codeUnits) : null;
    isLiked = map["isLiked"];
  }

  SongMetadata.defaultValue() {
    id = 0;
    data = "";
    title = "Unknown";
    artist = "Unknown";
    album = "Unknown";
    artwork = null;
    isLiked = false;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "data": data,
      "title": title,
      "artist": artist,
      "album": album,
      "artwork": artwork != null ? String.fromCharCodes(artwork!) : null,
      "isLiked": isLiked,
    };
  }
}
