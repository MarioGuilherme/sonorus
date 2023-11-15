import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/user_complete_model.dart";
import "package:sonorus/src/repositories/user/user_repository.dart";

import "package:sonorus/src/services/user/user_service.dart";

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl(this._userRepository);

  @override
  Future<UserCompleteModel> getUserDataByUserId(int userId) async => this._userRepository.getUserDataByUserId(userId);

  @override
  Future<void> deleteMyAccount() async => this._userRepository.deleteAccount(Modular.get<CurrentUserModel>().userId!);
 
  @override
  Future<List<InterestModel>> getAllInterests() async => this._userRepository.getAllInterests();

  @override
  Future<void> updatePassword(String newPassword) async => this._userRepository.updatePassword(newPassword);

  @override
  Future<String> updatePicture(XFile newPicture) async => this._userRepository.updatePicture(newPicture);

  @override
  void removeInterest(int interestId) => this._userRepository.removeInterest(interestId);
  
  @override
  void addInterest(int interestId) => this._userRepository.addInterest(interestId);
  
  @override
  Future<void> updateUser(String fullname, String nickname, String email) => this._userRepository.updateUser(fullname, nickname, email);
}