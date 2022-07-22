import 'dart:io';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class MediaPicker extends StatelessWidget {
  const MediaPicker({
    Key? key,
    this.scrollController,
    required this.backgroundColor,
    required this.foregroundColor,
    this.maxSelection = 1,
    required this.onPicked,
    this.emptyWidget,
    this.loadingWidget,
  }) : super(key: key);
  final ScrollController? scrollController;
  final Color backgroundColor;
  final Color foregroundColor;
  final int maxSelection;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Function(List<File?> files) onPicked;

  @override
  Widget build(BuildContext context) {
    // Wrap with theme provider to support theme changes
    return Material(
      color: backgroundColor,
      child: Column(
        children: [
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
    );
  }
}
