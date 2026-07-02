import 'package:flutter/material.dart';

import '../content/interests.dart';
import '../theme/text_styles.dart';

class InterestSelectionScreen extends StatefulWidget {
  final List<String> initialInterestIds;

  const InterestSelectionScreen({super.key, required this.initialInterestIds});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  static const int minimumInterests = 3;
  static const int maximumInterests = 15;

  late final Set<String> _selectedInterestIds;

  @override
  void initState() {
    super.initState();
    _selectedInterestIds = {...widget.initialInterestIds};
  }

  void _toggleInterest(String interestId) {
    final isSelected = _selectedInterestIds.contains(interestId);

    if (!isSelected && _selectedInterestIds.length >= maximumInterests) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('you can select up to 15 interests.'),
          duration: Duration(seconds: 2),
        ),
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

  void _saveInterests() {
    if (_selectedInterestIds.length < minimumInterests) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('choose at least 3 interests.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.of(context).pop<List<String>>(_selectedInterestIds.toList());
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
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
                  Text(
                    'what catches your interest?',
                    style: text.quicksandHeading.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'choose at least 3 so we can suggest people '
                    'you might enjoy following.',
                    style: text.quicksandBody.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.68),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${_selectedInterestIds.length}/'
                    '$maximumInterests selected',
                    style: text.quicksandSmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 9,
                    runSpacing: 10,
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
                        selectedColor: colors.primary,
                        backgroundColor: colors.surface,
                        labelStyle: text.quicksandBody.copyWith(
                          color: isSelected
                              ? colors.onPrimary
                              : colors.onSurface,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? colors.primary
                              : colors.onSurface.withValues(alpha: 0.28),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.96),
                border: Border(
                  top: BorderSide(
                    color: colors.onSurface.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: enoughSelected ? _saveInterests : null,
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
