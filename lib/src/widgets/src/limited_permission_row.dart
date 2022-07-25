import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LimitedPermissionRow extends StatelessWidget {
  const LimitedPermissionRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.status != MediaPickerStatus.limitedPermission) {
        return const SizedBox.shrink();
      }
      return context
          .read<MediaPickerCubit>()
          .configs
          .limitedPermissionRowWidget;
    });
  }
}
