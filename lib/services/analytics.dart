import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static FirebaseAnalytics _firebase = FirebaseAnalytics();

  static Future<void> logScreenSwitch(String screenName) async {
    return _firebase.setCurrentScreen(screenName: screenName).then((_) {
      print('[event] setCurrentScreen($screenName)');
    });
  }

  static Future<void> logItemClickEvent(String itemKey) async {
    return _firebase.logEvent(name: 'item', parameters: {
      'key': itemKey,
    }).then((_) {
      print('[event] item($itemKey)');
    });
  }

  static Future<void> logChampionModalEvent(
      String championKey, bool isOpenEvent) async {
    return _firebase.logEvent(name: 'champion_modal', parameters: {
      'key': championKey,
      'is_open_event': isOpenEvent,
    }).then((_) {
      print('[event] champion_modal($championKey, ${isOpenEvent.toString()})');
    });
  }

  static Future<void> logOpenUrlEvent(String url) async {
    return _firebase.logEvent(name: 'launch_url', parameters: {
      'url': url,
    }).then((_) {
      print('[event] launch_url($url)');
    });
  }
}
