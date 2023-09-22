// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimelineController on TimelineControllerBase, Store {
  late final _$_timelineStatusAtom =
      Atom(name: 'TimelineControllerBase._timelineStatus', context: context);

  TimelineStateStatus get timelineStatus {
    _$_timelineStatusAtom.reportRead();
    return super._timelineStatus;
  }

  @override
  TimelineStateStatus get _timelineStatus => timelineStatus;

  @override
  set _timelineStatus(TimelineStateStatus value) {
    _$_timelineStatusAtom.reportWrite(value, super._timelineStatus, () {
      super._timelineStatus = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'TimelineControllerBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
