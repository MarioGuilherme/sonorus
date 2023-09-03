import "package:image_picker/image_picker.dart";
import "package:sonorus/src/models/auth_token_model.dart";
import "package:sonorus/src/models/interest_model.dart";

abstract interface class AuthRepository {
  Future<List<InterestModel>> getInterests();
  Future<AuthTokenModel> login(Map<String, String> data);
  Future<AuthTokenModel> register(String fullname, String nickname, String email, String password);
  Future<void> savePicture(XFile file);
  Future<void> saveInterests(List<InterestModel> interests);
}