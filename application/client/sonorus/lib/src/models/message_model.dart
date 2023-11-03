import "dart:convert";

class MessageModel {
  final String content;
  final bool isSentByMe;
  final DateTime sentAt;

  MessageModel({
    required this.isSentByMe,
    required this.content,
    required this.sentAt
  });

  String get sentAgo {
    final DateTime now = DateTime.now();

    final int differenceSeconds = now.difference(this.sentAt).inSeconds;
    if (differenceSeconds <= 59)
      return "$differenceSeconds segundos atrás";

    final int differenceMinutes = now.difference(this.sentAt).inMinutes;
    if (differenceMinutes <= 59)
      return "$differenceMinutes minutos atrás";

    final int differenceHours = now.difference(this.sentAt).inHours;
    if (differenceHours <= 23)
      return "$differenceHours minutos atrás";

    final int differenceDays = now.difference(this.sentAt).inDays;
    if (differenceDays <= 30)
      return "$differenceDays dias atrás";

    return "${this.sentAt.day.toString().padLeft(2, "0")}/${this.sentAt.month.toString().padLeft(2, "0")}/${this.sentAt.year}";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "isSentByMe": isSentByMe,
      "content": content,
      "sentAt": sentAt.millisecondsSinceEpoch
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      isSentByMe: map["isSentByMe"] as bool,
      content: map["content"] as String,
      sentAt: DateTime.parse(map["sentAt"])
    );
  }

  String toJson() => json.encode(this.toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}