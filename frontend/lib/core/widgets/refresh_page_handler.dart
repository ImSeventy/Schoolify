import 'package:flutter/material.dart';

class RefreshPageHandler extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const RefreshPageHandler({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      color: Theme.of(context).scaffoldBackgroundColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
