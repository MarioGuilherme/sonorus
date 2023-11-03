import "dart:convert";

class MediaModel {
  final int mediaId;
  final String path;

  MediaModel({
    required this.mediaId,
    required this.path
  });

  bool get isPicture => this.path.split(".").last != "mp4";

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "mediaId": mediaId,
      "path": path
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      mediaId: map["mediaId"] as int,
      path: map["path"] as String
    );
  }

  String toJson() => json.encode(this.toMap());

  factory MediaModel.fromJson(String source) => MediaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}