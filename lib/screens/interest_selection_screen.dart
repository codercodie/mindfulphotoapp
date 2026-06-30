import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content/interests.dart';
import '../state/profile_store.dart';
import '../theme/text_styles.dart';

class InterestSelectionScreen extends ConsumerStatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  ConsumerState<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState
    extends ConsumerState<InterestSelectionScreen> {
  static const int minimumInterests = 3;
  static const int maximumInterests = 15;

  late final Set<String> _selectedInterestIds;

  @override
  void initState() {
    super.initState();

    final profile = ref.read(profileStoreProvider);

    _selectedInterestIds = {...profile.interestIds};
  }

  void _toggleInterest(String interestId) {
    final isSelected = _selectedInterestIds.contains(interestId);

    if (!isSelected && _selectedInterestIds.length >= maximumInterests) {
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text('you can select up to 15 interests.')),
      );

      return;
    }

    setState(() {
      if (isSelected) {
        _selectedInterestIds.remove(interestId);
      } else {
        _selectedInterestIds.add(interestId);
      }
    });
  }

  void _save() {
    if (_selectedInterestIds.length < minimumInterests) {
      return;
    }

    ref
        .read(profileStoreProvider.notifier)
        .updateInterests(_selectedInterestIds.toList());

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final enoughSelected = _selectedInterestIds.length >= minimumInterests;

    return Scaffold(
      appBar: AppBar(
        title: Text('your interests', style: text.quicksandHeading),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  Text(
                    'what catches your interest?',
                    style: text.quicksandHeading.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'choose at least 3 so we can suggest people '
                    'you might enjoy following.',
                    style: text.quicksandBody.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_selectedInterestIds.length}/$maximumInterests selected',
                    style: text.quicksandSmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: interestOptions.map((interest) {
                      final isSelected = _selectedInterestIds.contains(
                        interest.id,
                      );

                      return FilterChip(
                        selected: isSelected,
                        showCheckmark: false,
                        avatar: Text(interest.emoji),
                        label: Text(interest.id),
                        onSelected: (_) {
                          _toggleInterest(interest.id);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: ElevatedButton(
                onPressed: enoughSelected ? _save : null,
                child: Text(
                  enoughSelected ? 'save interests' : 'choose at least 3',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
