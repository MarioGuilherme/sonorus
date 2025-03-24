class MediaViewModel {
  final int mediaId;
  final String path;

  bool get isPicture => this.path.split(".").last != "mp4";

  MediaViewModel({ required this.mediaId, required this.path });

  factory MediaViewModel.fromMap(Map<String, dynamic> map) => MediaViewModel(
    mediaId: map["mediaId"] as int,
    path: map["path"] as String
  );
}