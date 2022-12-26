import 'package:flutter/material.dart';
import 'package:frontend/core/utils/extensions.dart';

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
      backgroundColor: context.colorScheme.onSurface,
      color: context.theme.scaffoldBackgroundColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
