import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'widgets/src/media_picker.dart';

class FastMediaPicker {
  static Future<List<AssetEntity>?> pick(BuildContext context) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SheetMediaPicker(
          backgroundColor: Color.fromARGB(255, 50, 50, 50),
          foregroundColor: Colors.white,
          maxSelection: 4,
        ),
      ),
    );
    return result as List<AssetEntity>?;
  }
}
