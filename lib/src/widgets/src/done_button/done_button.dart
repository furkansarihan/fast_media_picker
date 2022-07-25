import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoneButton extends StatelessWidget {
  const DoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: customize
    Color backgroundColor = Theme.of(context).primaryColor;
    Color textColor =
        backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: () {
        context.read<MediaPickerCubit>().done();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: backgroundColor,
        child: Center(
          child: Text(
            'Done',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
