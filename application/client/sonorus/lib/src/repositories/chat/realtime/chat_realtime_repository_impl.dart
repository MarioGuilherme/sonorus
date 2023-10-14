import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/message_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/chat/realtime/chat_realtime_repository.dart";

class ChatRealtimeRepositoryImpl implements ChatRealtimeRepository {
  final HttpClient _httpClient;

  ChatRealtimeRepositoryImpl(this._httpClient);

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final Response result = await _httpClient.chatMicrosservice().auth().get("/chats/$chatId/messages");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<MessageModel>((message) => MessageModel.fromMap(message)).toList();
    } on DioException {
      rethrow;
    }
  }
}