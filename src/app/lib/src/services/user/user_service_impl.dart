import "package:flutter_modular/flutter_modular.dart";
import "package:image_picker/image_picker.dart";

import "package:sonorus/src/core/utils/auth_utils.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/input_models/associate_collection_of_interests_input_model.dart";
import "package:sonorus/src/dtos/input_models/save_user_picture_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_password_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_user_input_model.dart";
import "package:sonorus/src/dtos/interest_dto.dart";
import "package:sonorus/src/repositories/user/user_repository.dart";
import "package:sonorus/src/services/user/user_service.dart";

class UserServiceImpl implements UserService {
  final UserRepository _repository;

  UserServiceImpl(this._repository);

  @override
  Future<void> deleteMyAccount() async {
    await this._repository.deleteMyAccount();
    await AuthUtils.clearSession();
  }
 
  @override
  Future<List<InterestDto>> getMyInterests() => this._repository.getMyInterests();

  @override
  Future<void> updatePassword(String password) async {
    final UpdatePasswordInputModel inputModel = UpdatePasswordInputModel(password: password);
    await this._repository.updatePassword(inputModel);
  }

  @override
  Future<void> updatePicture(XFile file) async {
    final UpdateUserPictureInputModel inputModel = UpdateUserPictureInputModel(file: file);
    final String uri = await this._repository.updatePicture(inputModel);
    final AuthenticatedUser currentUser = Modular.get<AuthenticatedUser>();
    currentUser.picture = uri;
  }

  @override
  Future<void> disassociateInterest(int interestId) => this._repository.disassociateInterest(interestId);
  
  @override
  Future<void> associateInterest(int interestId) => this._repository.associateInterest(interestId);
  
  @override
  Future<void> updateUser(String fullname, String nickname, String email) async {
    final UpdateUserInputModel inputModel = UpdateUserInputModel(
      fullname: fullname.trim(),
      nickname: nickname.trim(),
      email: email.trim()
    );
    await this._repository.updateUser(inputModel);
  }

  @override
  Future<void> associateCollectionOfInterests(List<InterestDto> interests) async {
    final AssociateCollectionOfInterestsInputModel inputModel = AssociateCollectionOfInterestsInputModel(interests: interests);
    await this._repository.associateCollectionOfInterests(inputModel);
  }
}