// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductDetailsController on _ProductDetailsControllerBase, Store {
  late final _$_statusAtom =
      Atom(name: '_ProductDetailsControllerBase._status', context: context);

  ProductDetailsPageStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  ProductDetailsPageStatus get _status => status;

  @override
  set _status(ProductDetailsPageStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: '_ProductDetailsControllerBase._error', context: context);

  String? get error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  String? get _error => error;

  @override
  set _error(String? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$deleteProductByIdAsyncAction = AsyncAction(
      '_ProductDetailsControllerBase.deleteProductById',
      context: context);

  @override
  Future<void> deleteProductById(int productId) {
    return _$deleteProductByIdAsyncAction
        .run(() => super.deleteProductById(productId));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
