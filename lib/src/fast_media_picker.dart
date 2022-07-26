import 'package:fast_media_picker/src/configs.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'widgets/src/sheet_media_picker.dart';

class FastMediaPicker {
  static Future<List<AssetEntity>?> pick(
    BuildContext context, {
    FastMediaPickerConfigs? configs,
  }) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(),
        reverseTransitionDuration: const Duration(),
        pageBuilder: (context, animation, secondaryAnimation) {
          Brightness brightness = Theme.of(context).brightness;
          ThemeData themeData;
          if (brightness == Brightness.dark) {
            themeData = Theme.of(context).copyWith(
              backgroundColor: const Color.fromARGB(255, 40, 40, 40),
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
            child: SheetMediaPicker(
              configs: configs ?? const FastMediaPickerConfigs(),
            ),
          );
        },
      ),
    );
    return result as List<AssetEntity>?;
  }
}
