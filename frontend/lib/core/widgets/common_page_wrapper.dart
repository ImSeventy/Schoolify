import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/widgets/refresh_page_handler.dart';

import '../constants/images_paths.dart';

class CommonPageWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const CommonPageWrapper({Key? key, required this.onRefresh, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshPageHandler(
      onRefresh: onRefresh,
      child: Stack(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Transform.translate(
            offset: const Offset(-10, 0),
            child: SvgPicture.asset(
              ImagesPaths.firstLoginIcons,
              color: Theme.of(context).colorScheme.onSurface,
              width: 170,
            ),
          ),
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: child,
            ),
          ),
        ],
      ),
    );
  }
}
