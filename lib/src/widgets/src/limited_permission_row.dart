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
        height: 48,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "You've given limited permission to access photos and videos.",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: context
                            .read<MediaPickerCubit>()
                            .foregroundColor
                            .withOpacity(0.6),
                      ),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  context.read<MediaPickerCubit>().manageLimited();
                },
                child: Container(
                  height: 100,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text('Manage',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: context
                                .read<MediaPickerCubit>()
                                .foregroundColor
                                .withOpacity(0.8),
                          )),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      );
    });
  }
}
