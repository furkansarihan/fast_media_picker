import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultDoneButton extends StatelessWidget {
  const DefaultDoneButton({
    Key? key,
    required this.doneButtonText,
  }) : super(key: key);
  final String doneButtonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MediaPickerCubit>().done();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Text(
            doneButtonText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
