
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Keys
class RemoteConfigKeys {
  static const String childcareUrl = "childcare_registration_url";
  static const String showPromoBanner = "show_promo_banner";
}

// Defaults
final Map<String, dynamic> _defaults = {
  RemoteConfigKeys.childcareUrl: "https://www.ezchildtrack.com/parentapplicationa/en/primary",
  RemoteConfigKeys.showPromoBanner: true,
};

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig}) 
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setDefaults(_defaults);
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1), // Cache for 1 hour
    ));
    await fetchAndActivate();
  }

  Future<bool> fetchAndActivate() async {
    return await _remoteConfig.fetchAndActivate();
  }

  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
}

// Riverpod Provider
final remoteConfigProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService();
});

// FutureProvider to ensure initialization before app starts (optional pattern)
final remoteConfigInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(remoteConfigProvider);
  await service.initialize();
});
