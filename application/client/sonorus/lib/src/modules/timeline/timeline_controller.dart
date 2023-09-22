import "package:mobx/mobx.dart";

import "package:sonorus/src/services/timeline/timeline_service.dart";

part "timeline_controller.g.dart";

class TimelineController = TimelineControllerBase with _$TimelineController;

enum TimelineStateStatus {
  initial,
  error
}

abstract class TimelineControllerBase with Store {
  final TimelineService _timelineService;

  @readonly
  // ignore: prefer_final_fields
  TimelineStateStatus _timelineStatus = TimelineStateStatus.initial;

  @readonly
  String? _errorMessage;

  TimelineControllerBase(this._timelineService);

  Future<void> getPosts() async {}
}