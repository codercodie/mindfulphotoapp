import 'package:flutter/material.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}