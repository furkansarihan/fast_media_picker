import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionLayer extends StatefulWidget {
  const PermissionLayer({Key? key}) : super(key: key);

  @override
  State<PermissionLayer> createState() => _PermissionLayerState();
}

class _PermissionLayerState extends State<PermissionLayer>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    var cubit = context.read<MediaPickerCubit>();
    if (state != AppLifecycleState.resumed) return;
    if (cubit.state.status == MediaPickerStatus.deniedPermission ||
        cubit.state.status == MediaPickerStatus.permenantlyDeniedPermission) {
      cubit.refreshPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.status == MediaPickerStatus.fullPermission ||
          state.status == MediaPickerStatus.limitedPermission) {
        return const SizedBox.shrink();
      }
      // TODO: custom widget
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: context.read<MediaPickerCubit>().scrollController,
              child: const SizedBox.shrink(),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.photo,
                size: 64,
                color: context.read<MediaPickerCubit>().foregroundColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Please allow access to your photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.read<MediaPickerCubit>().foregroundColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please grant permission to use this app',
                style: TextStyle(
                  fontSize: 14,
                  color: context.read<MediaPickerCubit>().foregroundColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Divider(
              thickness: 1,
              height: 0,
              color: context
                  .watch<MediaPickerCubit>()
                  .foregroundColor
                  .withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                context.read<MediaPickerCubit>().requestPermission();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    state.status ==
                            MediaPickerStatus.permenantlyDeniedPermission
                        ? 'Go to settings'
                        : 'Allow',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
