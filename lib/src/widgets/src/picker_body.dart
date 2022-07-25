import 'package:flutter/material.dart';

import '../widgets.dart';

class PickerBody extends StatelessWidget {
  const PickerBody({
    Key? key,
    this.maxSelection = 1,
    this.emptyWidget,
    this.loadingWidget,
  }) : super(key: key);
  final int maxSelection;
  final Widget? emptyWidget;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    // Wrap with theme provider to support theme changes
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          const LimitedPermissionRow(),
          Expanded(
            child: Stack(
              children: const [
                MediaGrid(),
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
