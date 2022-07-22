import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'last_folder_media.dart';

class FolderSelectList extends StatelessWidget {
  const FolderSelectList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: context.watch<MediaPickerCubit>().backgroundColor,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: context.watch<MediaPickerCubit>().scrollController,
          itemCount: context.read<MediaPickerCubit>().folders!.length,
          itemBuilder: (context, index) {
            final folder = context.read<MediaPickerCubit>().folders![index];

            return FutureBuilder(
              future: folder.assetCountAsync,
              builder: (context, AsyncSnapshot<int> snapshot) {
                return FolderSelectListTile(
                  folder: folder,
                  assetCount: snapshot.data,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FolderSelectListTile extends StatelessWidget {
  const FolderSelectListTile({
    Key? key,
    required this.folder,
    required this.assetCount,
  }) : super(key: key);
  final AssetPathEntity folder;
  final int? assetCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prevSelectedFolder =
            context.read<MediaPickerCubit>().selectedFolder.value;
        context.read<MediaPickerCubit>().selectFolder(folder);
        context
            .read<MediaPickerCubit>()
            .toggleSelectFolderState(prevSelectedFolder);
      },
      child: ListTile(
        dense: false,
        hoverColor: Colors.transparent,
        selectedColor: Colors.transparent,
        title: Text(
          folder.name,
          style: TextStyle(
            fontSize: 14,
            color: context.read<MediaPickerCubit>().foregroundColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        horizontalTitleGap: 8,
        leading: LastFolderMedia(
          folder: folder,
          assetCount: assetCount,
        ),
        trailing: Text(
          assetCount?.toString() ?? '',
          style: TextStyle(
            color: context.read<MediaPickerCubit>().foregroundColor,
          ),
        ),
      ),
    );
  }
}
