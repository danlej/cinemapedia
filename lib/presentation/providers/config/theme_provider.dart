import 'package:cinemapedia/config/constants/setting_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/infrastructure/services/services.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return ThemeNotifier(keyValueStorageService: keyValueStorageService);
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  final KeyValueStorageService keyValueStorageService;

  ThemeNotifier({required this.keyValueStorageService}) : super(AppTheme()) {
    checkIsDarkMode();
  }

  void toggleDarkMode() async {
    final bool isDark = !state.isDarkMode;

    await keyValueStorageService.setKeyValue<bool>(SettingKeys.isDark, isDark);

    state = state.copyWith(isDarkMode: isDark);
  }

  void checkIsDarkMode() async {
    bool? isDark = await keyValueStorageService.getValue<bool>(SettingKeys.isDark);

    isDark ??= true;

    state = state.copyWith(isDarkMode: isDark);
  }
}
