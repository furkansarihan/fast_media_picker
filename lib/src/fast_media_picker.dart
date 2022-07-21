import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/media_picker_cubit.dart';
import 'widgets/widgets.dart';

class FastMediaPicker extends StatelessWidget {
  const FastMediaPicker({
    Key? key,
    required this.backgroundColor,
    required this.foregrounColor,
    this.maxSelection = 1,
    required this.onPicked,
  }) : super(key: key);
  final Color backgroundColor;
  final Color foregrounColor;
  final int maxSelection;
  final Function(List<File?> files) onPicked;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediaPickerCubit>(
      create: (context) => MediaPickerCubit(
        context,
        backgroundColor,
        foregrounColor,
        maxSelection,
        onPicked,
      ),
      child: Material(
        color: backgroundColor,
        child: Column(
          children: [
            const FoldersDropdownRow(),
            const Divider(height: 0, thickness: 1),
            const LimitedPermissionRow(),
            Expanded(
              child: Stack(
                children: const [
                  MediaPickerBody(),
                  FolderListAnimator(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: DoneButtonAnimator(),
                  ),
                  PermissionLayer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
