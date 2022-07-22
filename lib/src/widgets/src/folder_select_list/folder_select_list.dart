import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                return ListTile(
                  dense: false,
                  title: Text(
                    folder.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.read<MediaPickerCubit>().foregrounColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  horizontalTitleGap: 8,
                  leading: LastFolderMedia(
                    folder: folder,
                    assetCount: snapshot.data,
                  ),
                  trailing: Text(
                    '${snapshot.data ?? 0}',
                    style: TextStyle(
                      color: context.read<MediaPickerCubit>().foregrounColor,
                    ),
                  ),
                  onTap: () async {
                    final prevSelectedFolder =
                        context.read<MediaPickerCubit>().selectedFolder.value;
                    context.read<MediaPickerCubit>().selectFolder(folder);
                    await Future.delayed(const Duration(milliseconds: 300));
                    context
                        .read<MediaPickerCubit>()
                        .toggleSelectFolderState(prevSelectedFolder);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
