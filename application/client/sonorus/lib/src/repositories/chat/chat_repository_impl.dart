import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";

class ChatRepositoryImpl implements ChatRepository {
  final HttpClient _httpClient;

  ChatRepositoryImpl(this._httpClient);

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      final Response result = await this._httpClient.chatMS().auth().get("/chats");
      final RestResponseModel restResponse = RestResponseModel.fromMap(result.data);
      return restResponse.data.map<ChatModel>((chat) => ChatModel.fromMap(chat)).toList();
    } on DioException {
      rethrow;
    }
  }
}