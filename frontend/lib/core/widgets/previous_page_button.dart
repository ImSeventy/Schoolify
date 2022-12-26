import 'package:flutter/material.dart';

class PreviousPageButton extends StatelessWidget {
  const PreviousPageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.arrow_back_ios_sharp,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
