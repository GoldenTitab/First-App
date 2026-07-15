import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  OnboardingService._internal();
  static final OnboardingService _instance = OnboardingService._internal();
  factory OnboardingService() => _instance;

  static const String _welcomeSeenKey = 'welcome_seen';

  Future<bool> get hasSeenWelcome async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_welcomeSeenKey) ?? false;
  }

  Future<void> markWelcomeAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_welcomeSeenKey, true);
  }
}
