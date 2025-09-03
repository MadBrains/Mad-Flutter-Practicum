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

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  static final _tween = Tween<Alignment>(begin: Alignment.centerLeft, end: Alignment.centerRight);

  late final ValueNotifier<AppThemeMode> _themeModeNotifier = ValueNotifier(_settingsRepository.themeMode);

  late final AnimationController _alignmentController;
  late Animation<AlignmentGeometry> _alignmentAnimation;

  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    _alignmentController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _alignmentController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _alignmentAnimation = _tween.animate(_alignmentController);
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
            AlignTransition(
              alignment: _alignmentAnimation,
              child: ElevatedButton(
                onPressed: () => context.read<SettingsRepository>().setToken(null),
                child: Text(
                  'Выйти',
                  style: fonts.regular14.copyWith(color: context.colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
