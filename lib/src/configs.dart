import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

import 'default_widgets/default_widgets.dart';

class FastMediaPickerConfigs {
  final RequestType type;
  final int pickLimit;
  final int crossAxisCount;

  final Widget emptyWidget;
  final Widget loadingWidget;
  final Widget doneWidget;
  final Widget permissionRequestWidget;
  final Widget limitedPermissionRowWidget;

  const FastMediaPickerConfigs({
    // TODO: video support
    this.type = RequestType.image,
    this.pickLimit = 1,
    this.crossAxisCount = 4,
    this.emptyWidget = const DefaultEmptyBody(
      noMediaText: 'No Media',
    ),
    this.loadingWidget = const DefaultLoadingBody(),
    this.doneWidget = const DefaultDoneButton(
      doneButtonText: 'Done',
    ),
    this.permissionRequestWidget = const DefaultPermissionRequestBody(
      titleText: 'Access your photos and videos',
      messages: [
        PermissionRequestMessages(
          CupertinoIcons.info,
          "You'll be given options to access all your photos or manually select a few.",
        ),
        PermissionRequestMessages(
          CupertinoIcons.checkmark_shield,
          "You're in control. You decide what photos and videos you share.",
        ),
        PermissionRequestMessages(
          CupertinoIcons.photo,
          "It's easier to share when you can access your whole photos and videos.",
        ),
      ],
      allowActionText: 'Allow',
      goToSettingsActionText: 'Go to settings',
    ),
    this.limitedPermissionRowWidget = const DefaultLimitedPermissionRow(
      limitedPermissionDescriptionText:
          "You've given limited permission to access photos and videos.",
      manageLimitedPermissionText: 'Manage',
    ),
  });
}
