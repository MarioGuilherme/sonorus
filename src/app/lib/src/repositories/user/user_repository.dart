import "package:sonorus/src/dtos/input_models/associate_collection_of_interests_input_model.dart";
import "package:sonorus/src/dtos/input_models/save_user_picture_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_password_input_model.dart";
import "package:sonorus/src/dtos/input_models/update_user_input_model.dart";
import "package:sonorus/src/dtos/interest_dto.dart";

abstract interface class UserRepository {
  Future<void> associateCollectionOfInterests(AssociateCollectionOfInterestsInputModel inputModel);
  Future<void> associateInterest(int interestId);
  Future<void> deleteMyAccount();
  Future<List<InterestDto>> getMyInterests();
  Future<void> updatePassword(UpdatePasswordInputModel inputModel);
  Future<void> updateUser(UpdateUserInputModel inputModel);
  Future<String> updatePicture(UpdateUserPictureInputModel inputModel);
  Future<void> disassociateInterest(int interestId);
}