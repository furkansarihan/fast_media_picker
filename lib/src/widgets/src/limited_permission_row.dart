import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LimitedPermissionRow extends StatelessWidget {
  const LimitedPermissionRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.status != MediaPickerStatus.limitedPermission) {
        return const SizedBox.shrink();
      }
      // TODO: custom text
      return Container(
        color: Colors.black38,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            onTap: () {
              context.read<MediaPickerCubit>().manageLimited();
            },
            title: Text(
              'Limited Permission',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context
                        .read<MediaPickerCubit>()
                        .foregrounColor
                        .withOpacity(0.5),
                  ),
            ),
            trailing: Text('Manage',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: context
                          .read<MediaPickerCubit>()
                          .foregrounColor
                          .withOpacity(0.8),
                    )),
          ),
        ),
      );
    });
  }
}
