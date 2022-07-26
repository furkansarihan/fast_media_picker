# fast_media_picker

A media picker based on Instagram's UI design.

![fast_color_picker](https://github.com/furkansarihan/fast_media_picker/blob/assets/assets/fast_color_picker.gif)

## Getting started
Before using fast_media_picker, [photo_manager](https://pub.dev/packages/photo_manager) and [permission_handler](https://pub.dev/packages/permission_handler) need to be configured.

You can (should) also check the [Example](https://github.com/furkansarihan/fast_media_picker/tree/main/example) for correct setup details.
### Setup photo_manager
Please read [this](https://pub.dev/packages/photo_manager#configure-native-platforms) section.

### Setup permission_handler
Please read [this](https://pub.dev/packages/permission_handler#setup) section.


## Usage

Example usage;

```dart
List<AssetEntity>? result = await FastMediaPicker.pick(
    context,
    configs: FastMediaPickerConfigs(
        type: RequestType.image,
        pickLimit: 1,
        crossAxisCount: 4,
    ),
);
```

Getting the first File from [AssetEntity](https://pub.dev/packages/photo_manager#get-assets-assetentity);

```dart
if (result == null || result.isEmpty) return;
File? image = await result.first.file;
```

### Customize UI

The body while fast_color_picker asking for permission.

```dart
configs: FastMediaPickerConfigs(
    ...
    // This, also can be your Widget.
    permissionRequestWidget: DefaultPermissionRequestBody(
        // Title with big font.
        titleText: '',
        // Messages shows as a icon-text pair.
        messages: [
            PermissionRequestMessages(icon, 'message'),
        ],
        // Button to request permission.
        allowActionText: '',
        // Button to go to Settings.
        goToSettingsActionText: '',
    ),
),
```

## TODO
* [ ] Add support for video preview