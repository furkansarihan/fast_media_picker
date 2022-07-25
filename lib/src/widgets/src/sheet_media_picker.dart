import 'package:fast_media_picker/src/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../cubit/media_picker_cubit.dart';
import 'picker_body.dart';
import 'folders_dropdown_row.dart';

class SheetMediaPicker extends StatelessWidget {
  const SheetMediaPicker({
    Key? key,
    required this.configs,
  }) : super(key: key);
  final FastMediaPickerConfigs configs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediaPickerCubit>(
        create: (context) => MediaPickerCubit(
              context,
              configs,
            ),
        child: const Sheet(child: PickerBody()));
  }
}

class Sheet extends StatelessWidget {
  const Sheet({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const SnappingPosition bottom = SnappingPosition.factor(
      positionFactor: 0,
      grabbingContentOffset: GrabbingContentOffset.bottom,
    );
    const SnappingPosition middle = SnappingPosition.factor(
      positionFactor: 0.75,
      grabbingContentOffset: GrabbingContentOffset.middle,
    );
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    SnappingPosition top = SnappingPosition.pixels(
      positionPixels:
          mediaQueryData.size.height - mediaQueryData.padding.top - 60,
      grabbingContentOffset: GrabbingContentOffset.top,
    );
    // TODO: background color based on sheet drag
    // TODO: fix scroll jump when sheet is dragged from grabbing widget
    // TODO: fix gap between grabbing widget and sheetBelow
    return SnappingSheet(
      lockOverflowDrag: false,
      onSnapCompleted: (_, snappingPosition) {
        if (snappingPosition == bottom) {
          Navigator.of(context).maybePop();
        }
      },
      initialSnappingPosition: middle,
      snappingPositions: [
        bottom,
        middle,
        top,
      ],
      grabbingHeight: 60,
      grabbing: const GrabbingWidget(),
      sheetBelow: SnappingSheetContent(
        draggable: true,
        sizeBehavior: SheetSizeStatic(
          size: MediaQuery.of(context).size.height * 0.4,
        ),
        childScrollController:
            context.watch<MediaPickerCubit>().scrollController,
        child: child,
      ),
    );
  }
}

class GrabbingWidget extends StatelessWidget {
  const GrabbingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 24,
            child: Center(
              child: Container(
                height: 4,
                width: 38,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36, child: FoldersDropdownRow()),
        ],
      ),
    );
  }
}
