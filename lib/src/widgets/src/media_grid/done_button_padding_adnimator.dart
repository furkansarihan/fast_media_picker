import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class DoneButtonPaddingAnimator extends StatelessWidget {
  const DoneButtonPaddingAnimator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().selectedAssets,
      builder: (context, List<AssetEntity>? selectedAssets, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: selectedAssets?.isEmpty ?? true ? 0 : 48,
        );
      },
    );
  }
}
