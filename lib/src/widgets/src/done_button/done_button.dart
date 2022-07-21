import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoneButton extends StatelessWidget {
  const DoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: customize
    return GestureDetector(
      onTap: () {
        context.read<MediaPickerCubit>().done();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Colors.blue,
        child: const Center(
          child: Text(
            'Done',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
