import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

enum DragDirection {
  up,
  down,
}

class CustomSnappingCalculator extends SnappingCalculator {
  CustomSnappingCalculator({
    required super.allSnappingPositions,
    required super.lastSnappingPosition,
    required super.maxHeight,
    required super.grabbingHeight,
    required super.currentPosition,
    required this.lastDragUpdates,
  });
  final List<DragUpdateDetails> lastDragUpdates;

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
    if (lastDragUpdates.isEmpty) return DragDirection.down;
    final lastUpdates = lastDragUpdates.take(4).toList();
    final downCount = lastUpdates.where((update) => update.delta.dy > 0).length;
    final upCount = lastUpdates.where((update) => update.delta.dy < 0).length;

    if (downCount > upCount) {
      return DragDirection.down;
    } else if (downCount < upCount) {
      return DragDirection.up;
    } else {
      return lastUpdates.first.delta.dy > 0
          ? DragDirection.down
          : DragDirection.up;
    }
  }

  bool _isFlicked() {
    if (lastDragUpdates.isEmpty) return false;
    final lastUpdates = lastDragUpdates.take(3).toList();
    for (var element in lastUpdates) {
      if (element.delta.dy.abs() > 5) return true;
    }
    return false;
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
