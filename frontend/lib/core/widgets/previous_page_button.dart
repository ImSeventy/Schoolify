import 'package:flutter/material.dart';
import 'package:frontend/core/utils/extensions.dart';

class PreviousPageButton extends StatelessWidget {
  const PreviousPageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.navigator.pop();
      },
      icon: Icon(
        Icons.arrow_back_ios_sharp,
        color: context.colorScheme.onBackground,
      ),
    );
  }
}
