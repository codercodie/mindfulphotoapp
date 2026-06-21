import 'package:flutter/material.dart';
import '../data/test_data.dart';
import '../theme/text_styles.dart';

class ClustersScreen extends StatelessWidget {
  const ClustersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'clusters',
          style: text.quicksandHeading,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleMemories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final memory = sampleMemories[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Center(
                child: Text(
                  memory.caption,
                  textAlign: TextAlign.center,
                  style: text.quicksandSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}