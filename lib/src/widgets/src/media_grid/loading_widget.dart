import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().folderSelecting,
      builder: ((context, bool folderSelecting, child) =>
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: SingleChildScrollView(
              controller: folderSelecting
                  ? context
                      .read<MediaPickerCubit>()
                      .folderSelectingScrollController
                  : context.read<MediaPickerCubit>().scrollController,
              child: context.read<MediaPickerCubit>().configs.loadingWidget,
            ),
          )),
    );
  }
}
