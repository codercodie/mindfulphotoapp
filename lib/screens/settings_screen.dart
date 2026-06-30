import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content/packs.dart';
import '../state/app_settings_store.dart';
import '../state/profile_store.dart';
import '../theme/text_styles.dart';
import '../theme/theme_pack.dart';
import '../theme/themes.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final profile = ref.watch(profileStoreProvider);
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('settings', style: text.quicksandHeading)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          const _SectionHeading(
            title: 'theme',
            description: 'choose your theme and color palette.',
          ),
          const SizedBox(height: 10),

          ...themePacks.map((themePack) {
            final isActive = profile.enabledThemePackId == themePack.id;

            final isUnlocked = profile.unlockedThemePackIds.contains(
              themePack.id,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ThemePackTile(
                themePack: themePack,
                isActive: isActive,
                isUnlocked: isUnlocked,
                onTap: isUnlocked
                    ? () {
                        ref
                            .read(profileStoreProvider.notifier)
                            .updateThemePack(themePack.id);
                      }
                    : null,
              ),
            );
          }),

          const SizedBox(height: 26),

          const _SectionHeading(
            title: 'prompt packs',
            description: 'choose which kinds of prompts can appear.',
          ),
          const SizedBox(height: 10),

          ...packs.map((pack) {
            final isUnlocked = profile.unlockedPromptPackIds.contains(pack.id);

            final isActive = profile.enabledPromptPackIds.contains(pack.id);

            void showUnlockInfo() {
              _showUnlockInfo(
                context,
                title: pack.name,
                message: _promptPackUnlockMessage(pack.id),
              );
            }

            return ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: isUnlocked ? null : showUnlockInfo,
              leading: Icon(
                isUnlocked ? Icons.auto_awesome_outlined : Icons.lock_outline,
                color: isUnlocked
                    ? null
                    : colors.onSurface.withValues(alpha: 0.45),
              ),
              title: Text(
                pack.name,
                style: text.quicksandBody.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isUnlocked
                      ? colors.onSurface
                      : colors.onSurface.withValues(alpha: 0.45),
                ),
              ),
              trailing: isUnlocked
                  ? Switch(
                      value: isActive,
                      onChanged: (enabled) {
                        if (!enabled &&
                            profile.enabledPromptPackIds.length == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'at least one prompt pack must remain active.',
                              ),
                            ),
                          );
                          return;
                        }

                        ref
                            .read(profileStoreProvider.notifier)
                            .setPromptPackEnabled(pack.id, enabled);
                      },
                    )
                  : IconButton(
                      tooltip: 'how to unlock',
                      onPressed: showUnlockInfo,
                      icon: const Icon(Icons.help_outline),
                    ),
            );
          }),

          const SizedBox(height: 26),

          const _SectionHeading(
            title: 'general',
            description: 'take control of your experience in wabisnaps.',
          ),
          const SizedBox(height: 8),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.tag_faces_outlined),
            title: const Text('show reaction counts'),
            subtitle: const Text('display the number beside each reaction.'),
            value: settings.showReactionCounts,
            onChanged: (value) {
              ref
                  .read(appSettingsProvider.notifier)
                  .setShowReactionCounts(value);
            },
          ),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('daily prompt reminder'),
            subtitle: const Text('remind me when the daily prompt is ready.'),
            value: settings.dailyPromptReminder,
            onChanged: (value) {
              ref
                  .read(appSettingsProvider.notifier)
                  .setDailyPromptReminder(value);
            },
          ),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.motion_photos_off_outlined),
            title: const Text('reduce motion'),
            subtitle: const Text('use fewer animations and transitions.'),
            value: settings.reduceMotion,
            onChanged: (value) {
              ref.read(appSettingsProvider.notifier).setReduceMotion(value);
            },
          ),

          const Divider(height: 34),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: const Text('privacy'),
            subtitle: const Text('profile visibility and blocked accounts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Add privacy settings page later.
            },
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('about'),
            subtitle: const Text('app information and acknowledgements'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'wabisnaps',
                applicationVersion: '0.1.0',
              );
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String description;

  const _SectionHeading({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.quicksandHeading.copyWith(fontSize: 22)),
        const SizedBox(height: 3),
        Text(
          description,
          style: text.quicksandSmall.copyWith(
            color: colors.onSurface.withValues(alpha: 0.58),
          ),
        ),
      ],
    );
  }
}

class _ThemePackTile extends StatelessWidget {
  final ThemePack themePack;
  final bool isActive;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const _ThemePackTile({
    required this.themePack,
    required this.isActive,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    void showUnlockInfo() {
      _showUnlockInfo(
        context,
        title: themePack.name,
        message: _themeUnlockMessage(themePack.id),
      );
    }

    return ListTile(
      onTap: isUnlocked ? onTap : showUnlockInfo,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      minLeadingWidth: 62,
      horizontalTitleGap: 16,
      tileColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.1),
        ),
      ),
      leading: Opacity(
        opacity: isUnlocked ? 1 : 0.45,
        child: SizedBox(
          width: 62,
          height: 30,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 1,
                child: _ColourDot(color: themePack.primary),
              ),
              Positioned(
                left: 17,
                top: 1,
                child: _ColourDot(color: themePack.secondary),
              ),
              Positioned(
                left: 34,
                top: 1,
                child: _ColourDot(color: themePack.accent),
              ),
            ],
          ),
        ),
      ),
      title: Text(
        themePack.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isUnlocked
              ? colors.onSurface
              : colors.onSurface.withValues(alpha: 0.45),
        ),
      ),
      subtitle: isActive ? const Text('current theme') : null,
      trailing: isActive
          ? Icon(Icons.check_circle, color: colors.primary)
          : isUnlocked
          ? Icon(
              Icons.circle_outlined,
              color: colors.onSurface.withValues(alpha: 0.45),
            )
          : IconButton(
              tooltip: 'how to unlock',
              onPressed: showUnlockInfo,
              icon: const Icon(Icons.help_outline),
            ),
    );
  }
}

class _ColourDot extends StatelessWidget {
  final Color color;

  const _ColourDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

Future<void> _showUnlockInfo(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('got it!'),
          ),
        ],
      );
    },
  );
}

String _themeUnlockMessage(String themeId) {
  switch (themeId) {
    case 'mist':
      return 'unlock this theme by capturing 10 glimmers.';
    default:
      return 'this theme is not unlocked yet.';
  }
}

String _promptPackUnlockMessage(String packId) {
  switch (packId) {
    case 'indoors':
      return 'unlock this pack by capturing 5 indoor glimmers.';
    default:
      return 'this prompt pack is not unlocked yet.';
  }
}
