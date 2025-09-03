import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';
import 'package:mad_flutter_practicum/app/utils/theme/theme_data.dart';
import 'package:mad_flutter_practicum/app/utils/theme_mode_ext.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart';

part 'theme_mode_selector_bs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ValueNotifier<AppThemeMode> _themeModeNotifier = ValueNotifier(_settingsRepository.themeMode);

  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;

    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _themeModeNotifier,
              builder: (BuildContext context, AppThemeMode mode, Widget? child) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 24),
                  leading: Icon(Icons.dark_mode),
                  title: child,
                  subtitle: Text(
                    mode.title,
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final AppThemeMode? newMode = await ThemeModeSelectorBottomSheet.show(context, mode);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                  },
                );
              },
              child: Text(
                'Тема',
                style: fonts.regular16,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.read<SettingsRepository>().setToken(null),
              child: Text(
                'Выйти',
                style: fonts.regular14.copyWith(color: context.colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
