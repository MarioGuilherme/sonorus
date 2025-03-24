import "package:dio/dio.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/domain/exceptions/chat_not_found_exception.dart";
import "package:sonorus/src/domain/exceptions/repository_exception.dart";
import "package:sonorus/src/dtos/view_models/chat_view_model.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";

class ChatRepositoryImpl implements ChatRepository {
  final HttpClient _httpClient;

  ChatRepositoryImpl(this._httpClient);

  @override
  Future<List<ChatViewModel>> getAll() async {
    try {
      final Response result = await this._httpClient.auth().get("/chats");
      return result.data.map<ChatViewModel>((chat) => ChatViewModel.fromMap(chat)).toList();
    } on Exception {
      throw RepositoryException();
    }
  }

  @override
  Future<ChatViewModel> getByFriendId(int friendId) async {
    try {
      final Response result = await this._httpClient.auth().get("/friends/$friendId/chat");
      return ChatViewModel.fromMap(result.data);
    } on Exception catch (exception) {
      if (exception is DioException)
        if (exception.response?.statusCode == 404) throw ChatNotFoundException();
      throw RepositoryException();
    }
  }
}