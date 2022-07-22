import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/media_picker_cubit.dart';
import 'widgets/widgets.dart';

class FastMediaPicker extends StatelessWidget {
  const FastMediaPicker({
    Key? key,
    this.scrollController,
    required this.backgroundColor,
    required this.foregrounColor,
    this.maxSelection = 1,
    required this.onPicked,
    this.emptyWidget,
    this.loadingWidget,
  }) : super(key: key);
  final ScrollController? scrollController;
  final Color backgroundColor;
  final Color foregrounColor;
  final int maxSelection;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Function(List<File?> files) onPicked;

  @override
  Widget build(BuildContext context) {
    // Wrap with theme provider to support theme changes
    return BlocProvider<MediaPickerCubit>(
      create: (context) => MediaPickerCubit(
        context,
        scrollController ?? ScrollController(),
        backgroundColor,
        foregrounColor,
        maxSelection,
        emptyWidget,
        loadingWidget,
        onPicked,
      ),
      child: Material(
        color: backgroundColor,
        child: Column(
          children: [
            const FoldersDropdownRow(),
            Divider(
              height: 0,
              thickness: 1,
              color: foregrounColor.withOpacity(0.025),
            ),
            const LimitedPermissionRow(),
            Expanded(
              child: Stack(
                children: const [
                  MediaPickerBody(),
                  Positioned(
                    top: -1,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FolderListAnimator(),
                  ),
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
