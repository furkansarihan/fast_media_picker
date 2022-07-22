import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class FoldersDropdownRow extends StatelessWidget {
  const FoldersDropdownRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.status == MediaPickerStatus.noPermission) {
        return const SizedBox.shrink();
      }

      return ValueListenableBuilder(
        valueListenable: context.read<MediaPickerCubit>().selectedFolder,
        builder: (context, AssetPathEntity? folder, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(folder: folder),
            ],
          );
        },
      );
    });
  }
}

class DropdownButton extends StatelessWidget {
  const DropdownButton({Key? key, this.folder}) : super(key: key);
  final AssetPathEntity? folder;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: context.read<MediaPickerCubit>().folders == null
          ? null
          : () => context.read<MediaPickerCubit>().toggleSelectFolderState(
                context.read<MediaPickerCubit>().selectedFolder.value,
              ),
      child: Center(
        child: Row(
          children: [
            Text(
              // TODO: translate
              folder?.name ?? 'recents',
              style: TextStyle(
                fontSize: 16,
                color: context.read<MediaPickerCubit>().foregrounColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            ValueListenableBuilder(
              valueListenable: context.read<MediaPickerCubit>().folderSelecting,
              builder: (context, bool selecting, _) {
                return Icon(
                  selecting
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 16,
                  color: context.read<MediaPickerCubit>().foregrounColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
