import "dart:convert";

import "package:sonorus/src/dtos/interest_dto.dart";

class AssociateCollectionOfInterestsInputModel {
  final List<InterestDto> interests;

  AssociateCollectionOfInterestsInputModel({ required this.interests });

  String toJson() => json.encode({ "interests": interests.map((x) => x.toMap()).toList() });
}