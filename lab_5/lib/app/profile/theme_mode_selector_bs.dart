part of 'profile_page.dart';

class ThemeModeSelectorBottomSheet extends StatelessWidget {
  const ThemeModeSelectorBottomSheet._({required this.selectedMode});

  final AppThemeMode selectedMode;

  static Future<AppThemeMode?> show(BuildContext context, AppThemeMode selectedMode) => showModalBottomSheet(
        context: context,
        builder: (_) => ThemeModeSelectorBottomSheet._(selectedMode: selectedMode),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final AppThemeMode mode in AppThemeMode.values)
            RadioListTile(
              value: mode,
              groupValue: selectedMode,
              onChanged: (AppThemeMode? mode) {
                if (mode == null) return;

                context.read<SettingsRepository>().setThemeMode(mode);

                Navigator.pop(context, mode);
              },
              title: Text(
                mode.title,
                style: context.fonts.regular16,
              ),
            ),
        ],
      ),
    );
  }
}
