import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit(
    this.context,
    this.scrollController,
    this.backgroundColor,
    this.foregroundColor,
    this.maxSelection,
    this.emptyWidget,
    this.loadingWidget,
    this.onPicked,
  ) : super(const MediaPickerState(status: MediaPickerStatus.loading)) {
    _init();
    addCallback();
  }

  final BuildContext context;

  final ScrollController scrollController;
  final Color backgroundColor;
  final Color foregroundColor;
  final int maxSelection;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Function(List<File?>) onPicked;

  List<AssetPathEntity>? folders;
  final ValueNotifier<AssetPathEntity?> selectedFolder = ValueNotifier(null);
  final ValueNotifier<bool> folderSelecting = ValueNotifier(false);

  final ValueNotifier<List<AssetEntity>?> assets = ValueNotifier(null);
  final ValueNotifier<List<AssetEntity>?> selectedAssets = ValueNotifier(null);
  final ValueNotifier<List<AssetEntity>?> updatedAssets = ValueNotifier(null);

  ScrollController? folderSelectingScrollController;
  final int pageSize = 36;

  @override
  Future<void> close() async {
    super.close();
    selectedFolder.dispose();
    folderSelecting.dispose();
    assets.dispose();
    selectedAssets.dispose();
    updatedAssets.dispose();
    folderSelectingScrollController?.dispose();
    await removeCallback();
  }

  // TODO: folder changes?
  void changeNotify(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments as Map<dynamic, dynamic>;
    List<dynamic> createList = arguments.containsKey('create')
        ? arguments['create'] as List<dynamic>
        : const [];
    List<dynamic> updateList = arguments.containsKey('update')
        ? arguments['update'] as List<dynamic>
        : const [];
    List<dynamic> deleteList = arguments.containsKey('delete')
        ? arguments['delete'] as List<dynamic>
        : const [];

    if (deleteList.isNotEmpty) {
      for (var element in deleteList) {
        Map<dynamic, dynamic> deletedElement = element as Map<dynamic, dynamic>;
        dynamic deletedId = deletedElement.containsKey('id')
            ? deletedElement['id'] as dynamic
            : const [];
        selectedAssets.value?.removeWhere((element) => element.id == deletedId);
        selectedAssets.value = selectedAssets.value?.toList();
      }
    }

    if (updateList.isNotEmpty && assets.value != null) {
      for (int i = 0; i < updateList.length; i++) {
        var element = updateList[i];
        Map<dynamic, dynamic> updatedElement = element as Map<dynamic, dynamic>;
        dynamic updatedId = updatedElement.containsKey('id')
            ? updatedElement['id'] as dynamic
            : const [];
        int index =
            assets.value!.indexWhere((element) => element.id == updatedId);
        if (index >= 0) {
          AssetEntity? updatedAsset = await AssetEntity.fromId(updatedId);
          if (updatedAsset != null) {
            tooggleUpdatedAsset(updatedAsset);
            assets.value?.replaceRange(index, index + 1, [updatedAsset]);
          }
        }
      }
    }

    if (createList.isNotEmpty || deleteList.isNotEmpty) {
      String? selectedFolderId = selectedFolder.value?.id;
      selectedFolder.value = null;
      await _initAllFolders(selectedFolderId: selectedFolderId);
    }
  }

  tooggleUpdatedAsset(AssetEntity asset) {
    if (updatedAssets.value == null) {
      updatedAssets.value = [asset];
    } else {
      updatedAssets.value = updatedAssets.value!.followedBy([asset]).toList();
    }
  }

  Future<void> addCallback() async {
    PhotoManager.addChangeCallback(changeNotify);
    await PhotoManager.startChangeNotify();
  }

  Future<void> removeCallback() async {
    PhotoManager.removeChangeCallback(changeNotify);
    await PhotoManager.stopChangeNotify();
  }

  _init() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.storage.status;
    } else {
      // TODO: ios 13 and below?
      status = await Permission.photos.status;
    }

    _emitPermissionStatus(status);

    // TODO: collect all assets if limited permission
    _initAllFolders();
  }

  _emitPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        emit(const MediaPickerState(status: MediaPickerStatus.fullPermission));
        break;
      case PermissionStatus.limited:
        emit(const MediaPickerState(
            status: MediaPickerStatus.limitedPermission));
        break;
      case PermissionStatus.denied:
        emit(
            const MediaPickerState(status: MediaPickerStatus.deniedPermission));
        break;
      default:
        emit(const MediaPickerState(
            status: MediaPickerStatus.permenantlyDeniedPermission));
    }
  }

  bool _foldersLoading = false;
  _initAllFolders({String? selectedFolderId}) async {
    if (_foldersLoading) return;
    _foldersLoading = true;
    if (state.status == MediaPickerStatus.loading) return;
    if (state.status == MediaPickerStatus.deniedPermission) return;
    if (state.status == MediaPickerStatus.permenantlyDeniedPermission) return;
    // TODO: limited always requests for more?
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.common,
      filterOption: FilterOptionGroup(),
    );
    // TODO: only show folders with assets
    folders = List<AssetPathEntity>.from(paths);
    // TODO: handle no folder
    if (folders!.isEmpty) {
      assets.value = null;
      _foldersLoading = false;
      return;
    }
    if (selectedFolderId == null) {
      await selectFolder(folders!.first);
    } else {
      await selectFolder(
          folders!.firstWhere((element) => element.id == selectedFolderId));
    }
    _foldersLoading = false;
  }

  toggleSelectFolderState(AssetPathEntity? prevSelectedFolder) {
    folderSelecting.value = !folderSelecting.value;
    if (folderSelecting.value) {
      folderSelectingScrollController = ScrollController(
        initialScrollOffset: scrollController.offset,
      );
    } else if (prevSelectedFolder?.id != selectedFolder.value?.id) {
      folderSelectingScrollController?.jumpTo(0);
      scrollController.jumpTo(0);
    }
  }

  Future<void> selectFolder(AssetPathEntity? folder) async {
    if (folder == null) return;
    if (selectedFolder.value == folder) return;
    assets.value = null;
    selectedFolder.value = folder;
    _endOfList = false;
    await fetchMoreAsset();
  }

  bool _isLoading = false;
  bool _endOfList = false;
  Future<void> fetchMoreAsset() async {
    if (_isLoading) return;
    if (_endOfList) return;
    if (selectedFolder.value == null) return;
    _isLoading = true;
    int start = assets.value?.length ?? 0;
    int end = start + pageSize;
    List<AssetEntity> al = await selectedFolder.value!.getAssetListRange(
      start: start,
      end: end,
    );
    _isLoading = false;
    if (al.isEmpty) {
      if (start == 0) {
        assets.value = const [];
      }
      return;
    } else if (al.length < pageSize) {
      _endOfList = true;
    }
    assets.value = (assets.value ?? const []).followedBy(al).toList();
  }

  tooggleSelectAsset(AssetEntity asset) {
    if (selectedAssets.value == null) {
      selectedAssets.value = [asset];
    } else {
      if (selectedAssets.value!.contains(asset)) {
        selectedAssets.value =
            selectedAssets.value!.where((a) => a != asset).toList();
      } else {
        if (!canSelectAsset()) return;
        selectedAssets.value =
            selectedAssets.value!.followedBy([asset]).toList();
      }
    }
  }

  bool canSelectAsset() {
    if (selectedAssets.value == null) return true;
    return selectedAssets.value!.length < maxSelection;
  }

  bool _doneLoading = false;
  done() async {
    // TODO: better way to do this - no async?
    if (_doneLoading) return;
    if (selectedAssets.value?.isEmpty ?? true) onPicked(const []);
    _doneLoading = true;
    List<File?> selectedFiles = await Future.wait(
      selectedAssets.value!.map((a) async {
        return await a.file;
      }),
    );
    _doneLoading = false;
    return onPicked(selectedFiles);
  }

  bool _appSettingsOpened = false;
  void requestPermission() async {
    if (state.status == MediaPickerStatus.permenantlyDeniedPermission) {
      await openAppSettings();
      _appSettingsOpened = true;
      return;
    }
    PermissionStatus? status;
    if (Platform.isAndroid) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }

    _emitPermissionStatus(status);
    _initAllFolders();
  }

  void refreshPermission() {
    if (!_appSettingsOpened) return;
    _appSettingsOpened = false;
    _init();
  }

  void manageLimited() {
    // TODO: push sheet
    // PhotoManager.openSetting();
    // PhotoManager.presentLimited();
  }
}
