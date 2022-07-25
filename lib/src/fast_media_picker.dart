import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'widgets/src/sheet_media_picker.dart';

class FastMediaPicker {
  static Future<List<AssetEntity>?> pick(BuildContext context) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Stack(
            children: [
              FadeTransition(
                opacity: animation,
                child: Container(color: Colors.black38),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ],
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          Brightness brightness = Theme.of(context).brightness;
          ThemeData themeData;
          if (brightness == Brightness.dark) {
            themeData = Theme.of(context).copyWith(
              backgroundColor: const Color.fromARGB(255, 50, 50, 50),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          } else {
            themeData = Theme.of(context).copyWith(
              backgroundColor: Colors.white,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }

          return Theme(
            data: themeData,
            child: const SheetMediaPicker(
              maxSelection: 4,
            ),
          );
        },
      ),
    );
    return result as List<AssetEntity>?;
  }
}
