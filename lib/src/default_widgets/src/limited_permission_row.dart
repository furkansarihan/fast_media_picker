import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultLimitedPermissionRow extends StatelessWidget {
  const DefaultLimitedPermissionRow({
    Key? key,
    required this.limitedPermissionDescriptionText,
    required this.manageLimitedPermissionText,
  }) : super(key: key);
  final String limitedPermissionDescriptionText;
  final String manageLimitedPermissionText;

  @override
  Widget build(BuildContext context) {
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
                limitedPermissionDescriptionText,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
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
                child: Text(manageLimitedPermissionText,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .color!
                              .withOpacity(0.8),
                        )),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
