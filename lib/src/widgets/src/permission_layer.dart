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
      return context.read<MediaPickerCubit>().configs.permissionRequestWidget;
    });
  }
}
