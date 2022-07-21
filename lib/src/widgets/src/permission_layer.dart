import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionLayer extends StatelessWidget {
  const PermissionLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.status == MediaPickerStatus.fullPermission ||
          state.status == MediaPickerStatus.limitedPermission) {
        return const SizedBox.shrink();
      }
      // TODO: custom widget
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Permission is required to use this app',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please grant permission to use this app',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            child: const Text('Go to Settings'),
            onPressed: () => context.read<MediaPickerCubit>().openSetting(),
          ),
        ],
      );
    });
  }
}
