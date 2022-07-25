import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultEmptyBody extends StatelessWidget {
  const DefaultEmptyBody({Key? key, required this.noMediaText})
      : super(key: key);
  final String noMediaText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Icon(
          CupertinoIcons.photo,
          size: 64,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        const SizedBox(height: 8),
        Text(
          noMediaText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium!.color!,
          ),
        ),
      ],
    );
  }
}
