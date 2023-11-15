import "package:image_picker/image_picker.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/user_complete_model.dart";

abstract interface class UserService {
  Future<UserCompleteModel> getUserDataByUserId(int userId);
  Future<void> deleteMyAccount();
  Future<List<InterestModel>> getAllInterests();
  Future<void> updatePassword(String newPassword);
  Future<String> updatePicture(XFile newPicture);
  Future<void> updateUser(String fullname, String nickname, String email);
  void removeInterest(int interestId);
  void addInterest(int interestId);
}