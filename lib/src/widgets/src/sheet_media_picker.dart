import 'dart:developer';

import 'package:fast_media_picker/src/configs.dart';
import 'package:fast_media_picker/src/widgets/src/custom_snapping_calculator.dart';
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
      positionFactor: -1,
      grabbingContentOffset: GrabbingContentOffset.bottom,
    );
    const SnappingPosition middle = SnappingPosition.factor(
      positionFactor: 0.7,
      grabbingContentOffset: GrabbingContentOffset.middle,
    );
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    SnappingPosition top = SnappingPosition.pixels(
      positionPixels:
          mediaQueryData.size.height - mediaQueryData.padding.top - 68,
      grabbingContentOffset: GrabbingContentOffset.top,
    );
    // TODO: fix scroll jump when sheet is dragged from grabbing widget
    // TODO: fix gap between grabbing widget and sheetBelow
    Widget sheet = SnappingSheet(
      controller: context.read<MediaPickerCubit>().snappingSheetController,
      lockOverflowDrag: false,
      onSnapStart: (positionData, snappingPosition) {
        if (snappingPosition == bottom) {
          Navigator.of(context).maybePop();
        }
      },
      onSheetMoved: (positionData) {
        context.read<MediaPickerCubit>().currentSheetPosition.value =
            positionData.pixels;
      },
      getSnappingCalculator: ({
        List<SnappingPosition>? allSnappingPositions,
        double? currentPosition,
        double? grabbingHeight,
        DragUpdateDetails? lastDragUpdateDetails,
        SnappingPosition? lastSnappingPosition,
        double? maxHeight,
      }) =>
          CustomSnappingCalculator(
        allSnappingPositions: allSnappingPositions!,
        currentPosition: currentPosition!,
        grabbingHeight: grabbingHeight!,
        lastDragUpdateDetails: lastDragUpdateDetails,
        lastSnappingPosition: lastSnappingPosition!,
        maxHeight: maxHeight!,
      ),
      initialSnappingPosition: bottom,
      snappingPositions: [
        bottom,
        middle,
        top,
      ],
      grabbingHeight: 68,
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

    return Stack(
      children: [
        const SheetBackground(),
        sheet,
      ],
    );
  }
}

class SheetBackground extends StatelessWidget {
  const SheetBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().currentSheetPosition,
      builder: (context, double position, _) {
        double opacity = position / MediaQuery.of(context).size.height;
        return Container(
          color: Colors.black.withOpacity(opacity.clamp(0, 0.6)),
        );
      },
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
            height: 28,
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
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
