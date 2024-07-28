import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigProvider with ChangeNotifier {
  bool _isDiscounted = false;

  bool get isDiscounted => _isDiscounted;

  RemoteConfigProvider() {
    _initializeRemoteConfig();
  }

  Future<void> _initializeRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setDefaults(<String, bool>{
        'discountPrice': _isDiscounted,
      });

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await fetchConfig();
      _listenForUpdates();
    } catch (e) {
      print("Failed to initialize remote config: $e");
    }
  }

  Future<void> fetchConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      bool updated = await remoteConfig.fetchAndActivate();
      if (updated) {
        print("Remote config updated successfully");
      } else {
        print("Remote config not updated, using cached values");
      }

      // Get the value of the discountPrice
      _isDiscounted = remoteConfig.getBool('discountPrice');
      notifyListeners();
    } catch (e) {
      print("Failed to fetch remote config: $e");
    }
  }

  void _listenForUpdates() {
    final remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.onConfigUpdated.listen((event) async {
      print("Remote config updated");
      await fetchConfig();
    });
  }
}
