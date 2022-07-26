import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetSelectedNotifier extends StatelessWidget {
  const AssetSelectedNotifier({
    Key? key,
    required this.asset,
  }) : super(key: key);
  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().selectedAssets,
      builder: (context, List<AssetEntity>? selectedAssets, _) {
        Widget child;
        if (selectedAssets != null && selectedAssets.contains(asset)) {
          child = Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
              color: Theme.of(context).colorScheme.primary,
            ),
            width: 20,
            height: 20,
            alignment: Alignment.center,
            child: Text(
              (selectedAssets.indexOf(asset) + 1).toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
          );
        } else if (!context.read<MediaPickerCubit>().canSelectAsset()) {
          child = const SizedBox.shrink();
        } else {
          child = Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
              color: Colors.white.withOpacity(0.5),
            ),
            width: 20,
            height: 20,
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }
}
