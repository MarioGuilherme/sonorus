import "package:image_picker/image_picker.dart";

import "package:sonorus/src/dtos/interest_dto.dart";

abstract interface class UserService {
  Future<void> associateInterest(int interestId);
  Future<void> deleteMyAccount();
  Future<void> disassociateInterest(int interestId);
  Future<List<InterestDto>> getMyInterests();
  Future<void> associateCollectionOfInterests(List<InterestDto> interests);
  Future<String> updatePicture(XFile file);
  Future<void> updatePassword(String password);
  Future<void> updateUser(String fullname, String nickname, String email);
}