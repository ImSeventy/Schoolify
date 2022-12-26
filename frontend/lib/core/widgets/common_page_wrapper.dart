import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/utils/extensions.dart';
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
            color: context.theme.scaffoldBackgroundColor,
          ),
          Transform.translate(
            offset: const Offset(-10, 0),
            child: SvgPicture.asset(
              ImagesPaths.firstLoginIcons,
              color: context.colorScheme.onSurface,
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
