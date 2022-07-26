import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

enum DragDirection {
  up,
  down,
}

class CustomSnappingCalculator extends SnappingCalculator {
  CustomSnappingCalculator(
      {required super.allSnappingPositions,
      required super.lastSnappingPosition,
      required super.maxHeight,
      required super.grabbingHeight,
      required super.currentPosition,
      this.lastDragUpdateDetails});
  DragUpdateDetails? lastDragUpdateDetails;

  @override
  SnappingPosition getBestSnappingPosition() {
    var snappingPositionsSorted = _getPositionInSizeOrder(allSnappingPositions);
    if (currentPosition > getBiggestPositionPixels()) {
      return snappingPositionsSorted.last;
    } else if (currentPosition < getSmallestPositionPixels()) {
      return snappingPositionsSorted.first;
    }

    final isFlicked = _isFlicked();
    if (isFlicked) {
      final dragDirection = _getDragDirection();
      final current = SnappingPosition.pixels(
        positionPixels: currentPosition,
      );
      snappingPositionsSorted.insert(0, current);
      snappingPositionsSorted = _getPositionInSizeOrder(
        snappingPositionsSorted,
      );
      final currentIndex = snappingPositionsSorted.indexOf(current);
      if (dragDirection == DragDirection.up) {
        final index =
            (currentIndex + 1).clamp(0, snappingPositionsSorted.length - 1);
        return snappingPositionsSorted[index];
      } else {
        final index =
            (currentIndex - 1).clamp(0, snappingPositionsSorted.length - 1);
        return snappingPositionsSorted[index];
      }
    }

    return _getClosestSnappingPosition(allSnappingPositions);
  }

  SnappingPosition _getClosestSnappingPosition(
    List<SnappingPosition> snappingPositionsToCheck,
  ) {
    double? minDistance;
    SnappingPosition? closestSnappingPosition;
    for (var snappingPosition in snappingPositionsToCheck) {
      double distance = _getDistanceToSnappingPosition(snappingPosition);

      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        closestSnappingPosition = snappingPosition;
      }
    }
    return closestSnappingPosition!;
  }

  @override
  double getBiggestPositionPixels() {
    return _getSnappingPositionsPositionInPixels().reduce(max);
  }

  @override
  double getSmallestPositionPixels() {
    return _getSnappingPositionsPositionInPixels().reduce(min);
  }

  List<double> _getSnappingPositionsPositionInPixels() {
    return allSnappingPositions.map((snappingPosition) {
      return snappingPosition.getPositionInPixels(maxHeight, grabbingHeight);
    }).toList();
  }

  DragDirection _getDragDirection() {
    if (lastDragUpdateDetails == null) return DragDirection.down;
    return lastDragUpdateDetails!.delta.dy > 0
        ? DragDirection.down
        : DragDirection.up;
  }

  bool _isFlicked() {
    return lastDragUpdateDetails != null &&
        lastDragUpdateDetails!.delta.dy.abs() > 5;
  }

  double _getDistanceToSnappingPosition(SnappingPosition snappingPosition) {
    double pos = snappingPosition.getPositionInPixels(
      maxHeight,
      grabbingHeight,
    );
    return (pos - currentPosition).abs();
  }

  List<SnappingPosition> _getPositionInSizeOrder(
    List<SnappingPosition> snappingPositions,
  ) {
    var snappingPositionsToSort = [...snappingPositions];
    snappingPositionsToSort.sort((a, b) {
      return a
          .getPositionInPixels(maxHeight, grabbingHeight)
          .compareTo(b.getPositionInPixels(maxHeight, grabbingHeight));
    });
    return snappingPositionsToSort;
  }
}
