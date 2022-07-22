import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'cubit/media_picker_cubit.dart';
import 'media_picker.dart';
import 'widgets/src/folders_dropdown_row.dart';

class FastMediaPicker extends StatelessWidget {
  const FastMediaPicker({
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
    ScrollController scrollController =
        this.scrollController ?? ScrollController();
    return BlocProvider<MediaPickerCubit>(
        create: (context) => MediaPickerCubit(
              context,
              scrollController,
              backgroundColor,
              foregroundColor,
              maxSelection,
              emptyWidget,
              loadingWidget,
              onPicked,
            ),
        child: Sheet(
          child: MediaPicker(
            scrollController: scrollController,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            onPicked: onPicked,
            maxSelection: maxSelection,
            emptyWidget: emptyWidget,
            loadingWidget: loadingWidget,
          ),
        ));
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
          mediaQueryData.size.height - mediaQueryData.padding.top * 4,
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
      grabbingHeight: 61,
      grabbing: Container(
        decoration: BoxDecoration(
          color: context.watch<MediaPickerCubit>().backgroundColor,
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
                    color: context
                        .watch<MediaPickerCubit>()
                        .foregroundColor
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36, child: FoldersDropdownRow()),
            Divider(
              height: 1,
              color: context
                  .watch<MediaPickerCubit>()
                  .foregroundColor
                  .withOpacity(0.05),
            ),
          ],
        ),
      ),
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
