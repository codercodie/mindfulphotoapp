import 'package:flutter/material.dart';
import '../models/corner.dart';
import '../theme/text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/corner_store.dart';

class CornersScreen extends ConsumerWidget {
  const CornersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corners = ref.watch(cornerStoreProvider);

    final joinedCorners = corners.where((corner) => corner.isJoined).toList();

    final discoverCorners = corners
        .where((corner) => !corner.isJoined)
        .toList();

    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('corners', style: text.quicksandHeading)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
        children: [
          Text(
            'connect with people who share your interests',
            style: text.quicksandBody.copyWith(
              color: colors.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 20),

          _SectionTitle(title: 'your corners'),
          const SizedBox(height: 12),
          ...joinedCorners.map(
            (corner) => CornerCard(
              corner: corner,
              onJoin: () {
                ref.read(cornerStoreProvider.notifier).joinCorner(corner.id);
              },
            ),
          ),

          const SizedBox(height: 26),

          _SectionTitle(title: 'discover'),
          const SizedBox(height: 12),
          ...discoverCorners.map(
            (corner) => CornerCard(
              corner: corner,
              onJoin: () {
                ref.read(cornerStoreProvider.notifier).joinCorner(corner.id);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('create'),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Text(
      title,
      style: text.quicksandHeading.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class CornerCard extends StatelessWidget {
  final Corner corner;
  final VoidCallback onJoin;

  const CornerCard({super.key, required this.corner, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colors.secondary.withValues(alpha: 0.22),
              child: Icon(_cornerIcon(corner.id), color: colors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    corner.name,
                    style: text.quicksandHeading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    corner.description,
                    style: text.quicksandSmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${corner.members} members • ${corner.glimmers} glimmers',
                    style: text.quicksandSmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _JoinBadge(corner: corner, onTap: onJoin),
          ],
        ),
      ),
    );
  }

  IconData _cornerIcon(String id) {
    switch (id) {
      case 'cats':
        return Icons.pets_outlined;
      case 'coffee':
        return Icons.local_cafe_outlined;
      case 'nature':
        return Icons.eco_outlined;
      case 'quiet':
        return Icons.nightlight_round_outlined;
      default:
        return Icons.auto_awesome_outlined;
    }
  }
}

class _JoinBadge extends StatelessWidget {
  final Corner corner;
  final VoidCallback onTap;

  const _JoinBadge({required this.corner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (corner.isJoined) {
      return Icon(Icons.check_circle_outline, color: colors.primary);
    }

    final label = switch (corner.joinType) {
      CornerJoinType.open => 'Join',
      CornerJoinType.request => 'Request',
      CornerJoinType.private => 'Private',
    };

    return TextButton(
      onPressed: corner.joinType == CornerJoinType.private ? null : onTap,
      child: Text(label),
    );
  }
}
