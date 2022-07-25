import 'package:flutter/material.dart';

class DefaultLoadingBody extends StatelessWidget {
  const DefaultLoadingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 16),
        CircularProgressIndicator.adaptive(),
      ],
    );
  }
}
