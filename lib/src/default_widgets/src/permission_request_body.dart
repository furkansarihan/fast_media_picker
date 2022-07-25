import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionRequestMessages {
  final IconData icon;
  final String message;

  const PermissionRequestMessages(this.icon, this.message);
}

class DefaultPermissionRequestBody extends StatelessWidget {
  const DefaultPermissionRequestBody({
    Key? key,
    required this.titleText,
    required this.messages,
    required this.allowActionText,
    required this.goToSettingsActionText,
  }) : super(key: key);
  final String titleText;
  final List<PermissionRequestMessages> messages;
  final String allowActionText;
  final String goToSettingsActionText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            controller: context.read<MediaPickerCubit>().scrollController,
            child: const SizedBox.shrink(),
          ),
        ),
        OverflowBox(
          maxHeight: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              for (PermissionRequestMessages m in messages)
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 32),
                        Icon(
                          m.icon,
                          size: 32,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            m.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            color: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: GestureDetector(
              onTap: () {
                context.read<MediaPickerCubit>().requestPermission();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Text(
                    context.read<MediaPickerCubit>().state.status ==
                            MediaPickerStatus.permenantlyDeniedPermission
                        ? goToSettingsActionText
                        : allowActionText,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Divider(
            thickness: 1,
            height: 0,
            color: Theme.of(context)
                .textTheme
                .bodyMedium!
                .color!
                .withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}
