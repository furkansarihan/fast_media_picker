import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

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
              child: context.read<MediaPickerCubit>().emptyWidget ??
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Icon(
                        CupertinoIcons.photo,
                        size: 64,
                        color: context.read<MediaPickerCubit>().foregroundColor,
                      ),
                      const SizedBox(height: 8),
                      Text('No Media',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: context
                                .read<MediaPickerCubit>()
                                .foregroundColor,
                          )),
                    ],
                  ),
            ),
          )),
    );
  }
}
