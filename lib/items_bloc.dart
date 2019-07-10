import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'services/analytics.dart';

class ItemsBloc {
  BehaviorSubject<String> _sisc = BehaviorSubject<String>.seeded('');
  Stream<String> get selectItemStream => _sisc.stream;

  Future<bool> handleBackButton() {
    if (_sisc.value.isNotEmpty) {
      selectItem('');
      return Future.value(false);
    }
    return Future.value(true);
  }

  void selectItem(String itemKey) {
    Analytics.logItemClickEvent(itemKey);
    if (itemKey == _sisc.value) {
      _sisc.add('');
    } else {
      _sisc.add(itemKey);
    }
  }

  void deselectAll() {
    _sisc.add('');
  }
}
